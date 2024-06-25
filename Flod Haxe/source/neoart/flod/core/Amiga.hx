/*
	Flod 4.1
	2012/04/30
	Christian Corti
	Neoart Costa Rica

	Last Update: Flod 4.1 - 2012/04/09

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
	 	OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
	 	LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR
	IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

	This work is licensed under the Creative Commons Attribution-Noncommercial-Share Alike 3.0 Unported License.
	To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/3.0/ or send a letter to
	Creative Commons, 171 Second Street, Suite 300, San Francisco, California, 94105, USA.
 */
package neoart.flod.core;

import flash.events.*;
import flash.utils.*;
import flash.Vector;

final class Amiga extends CoreMixer
{
	public static inline final MODEL_A500 = 0;
	public static inline final MODEL_A1200 = 1;

	public var filter:AmigaFilter;
	public var model:Int = MODEL_A1200;
	public var memory:Vector<Int>;
	public var channels:Vector<AmigaChannel>;
	public var loopPtr:Int = 0;
	public var loopLen:Int = 4;

	@:allow(neoart.flod.core) var clock:Float = 0.0;
	@:allow(neoart.flod.core) var master:Float = 0.00390625;

	public function new()
	{
		super();
		bufferSize = 8192;
		filter = new AmigaFilter();
		channels = new Vector<AmigaChannel>(4, true);

		channels[0] = new AmigaChannel(0);
		channels[0].next = channels[1] = new AmigaChannel(1);
		channels[1].next = channels[2] = new AmigaChannel(2);
		channels[2].next = channels[3] = new AmigaChannel(3);
	}

	public var volume(never, set):Int;

	function set_volume(value:Int):Int
	{
		if (value > 0)
		{
			if (value > 64)
				value = 64;
			master = (value / 64) * 0.00390625;
		}
		else
		{
			master = 0.0;
		}
		return value;
	}

	public function store(stream:ByteArray, len:Int, pointer:Int = -1):Int
	{
		var add = 0, i:Int, pos:Int = stream.position, start = memory.length, total:Int;

		if (pointer > -1)
			stream.position = pointer;
		total = stream.position + len;

		if ((total : UInt) >= stream.length)
		{
			add = total - stream.length;
			len = stream.length - stream.position;
		}

		{
			i = start;
			len += start;
		}
		while (i < len)
		{
			memory[i] = stream.readByte();
			++i;
		};

		memory.length += add;
		if (pointer > -1)
			stream.position = pos;
		return start;
	}

	@:allow(neoart.flod.core)
	override function initialize()
	{
		super.initialize();
		wave.clear();
		filter.initialize();

		if (!memory.fixed)
		{
			loopPtr = memory.length;
			memory.length += loopLen;
			memory.fixed = true;
		}

		channels[0].initialize();
		channels[1].initialize();
		channels[2].initialize();
		channels[3].initialize();
	}

	@:allow(neoart.flod.core)
	// js function restore
	override function reset()
	{
		memory = new Vector<Int>();
	}

	@:allow(neoart.flod.core)
	override function fast(e:SampleDataEvent)
	{
		var chan:AmigaChannel, data = e
			.data, i:Int, lvol:Float, mixed = 0, mixLen:Int, mixPos = 0, rvol:Float, sample:Sample, size = bufferSize, speed:Float, toMix:Int, value:Float;

		if (completed != 0)
		{
			if (remains == 0)
				return;
			size = remains;
		}

		while (mixed < size)
		{
			if (samplesLeft == 0)
			{
				player.process();
				samplesLeft = samplesTick;

				if (completed != 0)
				{
					size = mixed + samplesTick;

					if (size > bufferSize)
					{
						remains = size - bufferSize;
						size = bufferSize;
					}
				}
			}

			toMix = samplesLeft;
			if ((mixed + toMix) >= size)
				toMix = size - mixed;
			mixLen = mixPos + toMix;
			chan = channels[0];

			while (chan != null)
			{
				sample = buffer[mixPos];

				if (chan.audena != 0 && chan.audper > 60)
				{
					if (chan.mute != 0)
					{
						chan.ldata = 0.0;
						chan.rdata = 0.0;
					}

					speed = chan.audper / clock;

					value = chan.audvol * master;
					lvol = value * (1 - chan.level);
					rvol = value * (1 + chan.level);

					for (_tmp_ in mixPos...mixLen)
					{
						i = _tmp_;
						if (chan.delay != 0)
						{
							chan.delay--;
						}
						else if (--chan.timer < 1.0)
						{
							if (chan.mute == 0)
							{
								value = memory[chan.audloc] * 0.0078125;
								chan.ldata = value * lvol;
								chan.rdata = value * rvol;
							}

							chan.audloc++;
							chan.timer += speed;

							if (chan.audloc >= chan.audcnt)
							{
								chan.audloc = chan.pointer;
								chan.audcnt = chan.pointer + chan.length;
							}
						}

						sample.l += chan.ldata;
						sample.r += chan.rdata;
						sample = sample.next;
					}
				}
				else
				{
					for (_tmp_ in mixPos...mixLen)
					{
						i = _tmp_;
						sample.l += chan.ldata;
						sample.r += chan.rdata;
						sample = sample.next;
					}
				}
				chan = chan.next;
			}

			mixPos = mixLen;
			mixed += toMix;
			samplesLeft -= toMix;
		}

		sample = buffer[0];

		if (player.record != 0)
		{
			for (_tmp_ in 0...size)
			{
				i = _tmp_;
				filter.process(model, sample);

				wave.writeShort(Std.int(sample.l * (sample.l < 0 ? 32768 : 32767)));
				wave.writeShort(Std.int(sample.r * (sample.r < 0 ? 32768 : 32767)));

				data.writeFloat(sample.l);
				data.writeFloat(sample.r);

				sample.l = sample.r = 0.0;
				sample = sample.next;
			}
		}
		else
		{
			for (_tmp_ in 0...size)
			{
				i = _tmp_;
				filter.process(model, sample);

				data.writeFloat(sample.l);
				data.writeFloat(sample.r);

				sample.l = sample.r = 0.0;
				sample = sample.next;
			}
		}
	}
}
