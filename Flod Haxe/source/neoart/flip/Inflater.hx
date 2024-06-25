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

final class Inflater
{
	@:allow(neoart.flip) var output:ByteArray;
	var inpbuf:ByteArray;
	var inpcnt:Int = 0;
	var outcnt:Int = 0;
	var bitbuf:Int = 0;
	var bitcnt:Int = 0;
	var flencode:Huffman;
	var fdiscode:Huffman;
	var dlencode:Huffman;
	var ddiscode:Huffman;

	public function new()
	{
		initialize();
	}

	public var input(never, set):ByteArray;

	function set_input(stream:ByteArray):ByteArray
	{
		inpbuf = stream;
		output = new ByteArray();
		inpbuf.endian = output.endian = ZipFile.ENDIAN;
		inpbuf.position = output.position = 0;
		inpcnt = outcnt = 0;
		return stream;
	}

	public function inflate():Int
	{
		var err:Int, last:Int, type:Int;

		do
		{
			last = bits(1);
			type = bits(2);
			err = type == 0 ? stored() : type == 1 ? codes(flencode, fdiscode) : type == 2 ? _dynamic() : 1;

			if (err != 0)
				throw new Exception(ERROR1, 1);
		}
		while (last == 0);

		return 0;
	}

	function bits(need:Int):Int
	{
		var buff = bitbuf, inplen = inpbuf.length;

		while (bitcnt < need)
		{
			if ((inpcnt : UInt) == inplen)
				throw new Exception(ERROR2, 2);
			buff |= inpbuf[inpcnt++] << bitcnt;
			bitcnt += 8;
		}

		bitbuf = buff >> need;
		bitcnt -= need;
		return buff & ((1 << need) - 1);
	}

	function codes(lencode:Huffman, discode:Huffman):Int
	{
		var dis:Int, len:Int, pos:Int, sym:Int;

		do
		{
			sym = decode(lencode);
			if (sym < 0)
				return sym;

			if (sym < 256)
			{
				output[outcnt++] = sym;
			}
			else if (sym > 256)
			{
				sym -= 257;
				if (sym >= 29)
					throw new Exception(ERROR3, 3);
				len = LENG[sym] + bits(LEXT[sym]);

				sym = decode(discode);
				if (sym < 0)
					return sym;
				dis = DIST[sym] + bits(DEXT[sym]);
				if (dis > outcnt)
					throw new Exception(ERROR4, 4);

				pos = outcnt - dis;
				while (len-- != 0)
					output[outcnt++] = output[pos++];
			}
		}
		while (sym != 256);

		return 0;
	}

	function construct(huff:Huffman, length:Vector<Int>, n:Int):Int
	{
		var len:Int, left = 1, offs = new Vector<Int>(16, true), sym:Int;

		for (_tmp_ in 0...16)
		{
			len = _tmp_;
			huff.count[len] = 0;
		};
		for (_tmp_ in 0...n)
		{
			sym = _tmp_;
			huff.count[length[sym]]++;
		};
		if (huff.count[0] == n)
			return 0;

		for (_tmp_ in 1...16)
		{
			len = _tmp_;
			left <<= 1;
			left -= huff.count[len];
			if (left < 0)
				return left;
		}

		for (_tmp_ in 1...15)
		{
			len = _tmp_;
			offs[len + 1] = offs[len] + huff.count[len];
		};

		for (_tmp_ in 0...n)
		{
			sym = _tmp_;
			if (length[sym] != 0)
				huff.symbol[offs[length[sym]]++] = sym;
		};

		return left;
	}

	function decode(huff:Huffman):Int
	{
		var buff = bitbuf, code = 0, count:Int, first = 0, index = 0, inplen = inpbuf.length, left = bitcnt, len = 1;

		while (1 != 0)
		{
			while (left-- != 0)
			{
				code |= buff & 1;
				buff >>= 1;
				count = huff.count[len];

				if (code < first + count)
				{
					bitbuf = buff;
					bitcnt = (bitcnt - len) & 7;
					return huff.symbol[index + (code - first)];
				}

				index += count;
				first += count;
				first <<= 1;
				code <<= 1;
				++len;
			}

			left = 16 - len;
			if (left == 0)
				break;
			if ((inpcnt : UInt) == inplen)
				throw new Exception(ERROR2, 2);
			buff = inpbuf[inpcnt++];
			if (left > 8)
				left = 8;
		}

		return -9;
	}

	function stored():Int
	{
		var inplen = inpbuf.length, len:Int;
		bitbuf = bitcnt = 0;

		if (((inpcnt + 4):UInt) > inplen)
			throw new Exception(ERROR2, 2);
		len = inpbuf[inpcnt++];
		len |= inpbuf[inpcnt++] << 8;

		if (inpbuf[inpcnt++] != (~len & 0xff) || inpbuf[inpcnt++] != ((~len >> 8) & 0xff))
			throw new Exception(ERROR5, 5);

		if (((inpcnt + len):UInt) > inplen)
			throw new Exception(ERROR2, 2);
		while (len-- != 0)
			output[outcnt++] = inpbuf[inpcnt++];
		return 0;
	}

	function initialize()
	{
		var length = new Vector<Int>(288, true), sym = 0;
		flencode = new Huffman(288);
		fdiscode = new Huffman(30);

		for (_tmp_ in 0...144)
		{
			sym = _tmp_;
			length[sym] = 8;
		};
		while (sym < 256)
		{
			length[sym] = 9;
			++sym;
		};
		while (sym < 280)
		{
			length[sym] = 7;
			++sym;
		};
		while (sym < 288)
		{
			length[sym] = 8;
			++sym;
		};
		construct(flencode, length, 288);

		for (_tmp_ in 0...30)
		{
			sym = _tmp_;
			length[sym] = 5;
		};
		construct(fdiscode, length, 30);

		dlencode = new Huffman(286);
		ddiscode = new Huffman(30);
	}

	function _dynamic():Int
	{
		var err:Int, index = 0, len:Int, length = new Vector<Int>(316, true), nlen = bits(5) + 257, ndis = bits(5) + 1, ncode = bits(4) + 4, max = nlen +
			ndis, sym:Int;

		if (nlen > 286 || ndis > 30)
			throw new Exception(ERROR6, 6);
		for (_tmp_ in 0...ncode)
		{
			index = _tmp_;
			length[ORDER[index]] = bits(3);
		};
		while (index < 19)
		{
			length[ORDER[index]] = 0;
			++index;
		};

		err = construct(dlencode, length, 19);
		if (err != 0)
			throw new Exception(ERROR7, 7);
		index = 0;

		while (index < max)
		{
			sym = decode(dlencode);

			if (sym < 16)
			{
				length[index++] = sym;
			}
			else
			{
				len = 0;

				if (sym == 16)
				{
					if (index == 0)
						throw new Exception(ERROR8, 8);
					len = length[index - 1];
					sym = 3 + bits(2);
				}
				else if (sym == 17)
				{
					sym = 3 + bits(3);
				}
				else
				{
					sym = 11 + bits(7);
				}

				if ((index + sym) > max)
					throw new Exception(ERROR9, 9);
				while (sym-- != 0)
					length[index++] = len;
			}
		}

		err = construct(dlencode, length, nlen);
		if (err < 0 || (err > 0 && nlen - dlencode.count[0] != 1))
			throw new Exception(ERROR10, 10);

		err = construct(ddiscode, length.slice(nlen), ndis);
		if (err < 0 || (err > 0 && ndis - ddiscode.count[0] != 1))
			throw new Exception(ERROR11, 11);

		return codes(dlencode, ddiscode);
	}

	static inline final ERROR1 = "Invalid block type.";
	static inline final ERROR2 = "Available inflate data did not terminate.";
	static inline final ERROR3 = "Invalid literal/length or distance code.";
	static inline final ERROR4 = "Distance is too far back.";
	static inline final ERROR5 = "Stored block length did not match one's complement.";
	static inline final ERROR6 = "Too many length or distance codes.";
	static inline final ERROR7 = "Code lengths codes incomplete.";
	static inline final ERROR8 = "Repeat lengths with no first length.";
	static inline final ERROR9 = "Repeat more than specified lengths.";
	static inline final ERROR10 = "Invalid literal/length code lengths.";
	static inline final ERROR11 = "Invalid distance code lengths.";
	static final LENG:Vector<Int> = Vector.ofArray([
		3, 4, 5, 6, 7, 8, 9, 10, 11, 13, 15, 17, 19, 23, 27, 31, 35, 43, 51, 59, 67, 83, 99, 115, 131, 163, 195, 227, 258
	]);
	static final LEXT:Vector<Int> = Vector.ofArray([
		0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5, 0
	]);
	static final DIST:Vector<Int> = Vector.ofArray([
		1, 2, 3, 4, 5, 7, 9, 13, 17, 25, 33, 49, 65, 97, 129, 193, 257, 385, 513, 769, 1025, 1537, 2049, 3073, 4097, 6145, 8193, 12289, 16385, 24577
	]);
	static final DEXT:Vector<Int> = Vector.ofArray([
		0, 0, 0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 9, 10, 10, 11, 11, 12, 12, 13, 13
	]);
	static final ORDER:Vector<Int> = Vector.ofArray([16, 17, 18, 0, 8, 7, 9, 6, 10, 5, 11, 4, 12, 3, 13, 2, 14, 1, 15]);
}
