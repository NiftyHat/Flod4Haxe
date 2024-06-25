/*
	Flip 1.2
	2012/03/13
	Christian Corti
	Neoart Costa Rica

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
	OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
	LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR
	IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

	This work is licensed under the Creative Commons Attribution-Noncommercial-Share Alike 3.0 Unported License.
	To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/3.0/ or send a letter to
	Creative Commons, 171 Second Street, Suite 300, San Francisco, California, 94105, USA.
 */
package neoart.flip;

import flash.utils.*;
import flash.Vector;
import haxe.Exception;

final class ZipFile
{
	public static inline final ENDIAN = "littleEndian";

	public var entries:Vector<ZipEntry>;

	var stream:ByteArray;

	public function new(stream:ByteArray)
	{
		this.stream = stream;
		this.stream.endian = ENDIAN;
		parseEnd();
	}

	public function extract(filename:String):ByteArray
	{
		var entry:ZipEntry, i:Int, len = entries.length;
		if (filename == "" || filename == null)
			return null;

		for (_tmp_ in 0...len)
		{
			i = _tmp_;
			entry = entries[i];
			if (entry.name == filename)
				return uncompress(entry);
		}

		return null;
	}

	public function uncompress(entry:ZipEntry):ByteArray
	{
		var buffer:ByteArray, inflater:Inflater, size:Int;
		if (entry == null)
			return null;

		stream.position = entry.offset + 28;
		size = stream.readUnsignedShort();
		stream.position += (entry.name.length + size);

		buffer = new ByteArray();
		buffer.endian = ENDIAN;
		if (entry.compressed > 0)
			stream.readBytes(buffer, 0, entry.compressed);

		switch (entry.method)
		{
			case 0:
				return buffer;
			case 8:
				inflater = new Inflater();
				inflater.input = buffer;
				inflater.inflate();
				return inflater.output;
			default:
				throw new Exception(ERROR4, 4);
		}
	}

	function parseCentral()
	{
		var entry:ZipEntry, i:Int, header = new ByteArray(), len = entries.length, size:Int;
		header.endian = ENDIAN;

		for (_tmp_ in 0...len)
		{
			i = _tmp_;
			stream.readBytes(header, 0, 46);
			header.position = 0;
			if (header.readUnsignedInt() != 0x02014b50)
				throw new Exception(ERROR2, 2);
			header.position += 24;

			size = header.readUnsignedShort();
			if (size == 0)
				throw new Exception(ERROR2, 2);
			entry = new ZipEntry();
			entry.name = stream.readUTFBytes(size);

			size = header.readUnsignedShort();
			if (size > 0)
			{
				entry.extra = new ByteArray();
				stream.readBytes(entry.extra, 0, size);
			}

			stream.position += header.readUnsignedShort();
			header.position = 6;
			entry.version = header.readUnsignedShort();

			entry.flag = header.readUnsignedShort();
			if ((entry.flag & 1) == 1)
				throw new Exception(ERROR3, 3);

			entry.method = header.readUnsignedShort();
			entry.time = header.readUnsignedInt();
			entry.crc = header.readUnsignedInt();
			entry.compressed = header.readUnsignedInt();
			entry.size = header.readUnsignedInt();

			header.position = 42;
			entry.offset = header.readUnsignedInt();
			entries[i] = entry;
		}
	}

	function parseEnd()
	{
		var i:Int = stream.length - 22, l = (i - 65536) > 0 ? i - 65536 : 0;

		do
		{
			if (stream[i] != 0x50)
				continue;
			stream.position = i;
			if (stream.readUnsignedInt() == 0x06054b50)
				break;
		}
		while (--i > l);

		if (i == l)
			throw new Exception(ERROR1, 1);

		stream.position = i + 10;
		entries = new Vector<ZipEntry>(stream.readUnsignedShort(), true);
		stream.position = i + 16;
		stream.position = stream.readUnsignedInt();
		parseCentral();
	}

	static inline final ERROR1 = "The archive is either in unknown format or damaged.";
	static inline final ERROR2 = "Unexpected end of archive.";
	static inline final ERROR3 = "Encrypted archive not supported.";
	static inline final ERROR4 = "Compression method not supported.";
}
