/*
	Flod 4.1
	2012/04/30
	Christian Corti
	Neoart Costa Rica

	Last Update: Flod 4.1 - 2012/04/13

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
	OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
	LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR
	IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

	This work is licensed under the Creative Commons Attribution-Noncommercial-Share Alike 3.0 Unported License.
	To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/3.0/ or send a letter to
	Creative Commons, 171 Second Street, Suite 300, San Francisco, California, 94105, USA.
 */
package neoart.flod.trackers;

import flash.utils.*;
import neoart.flod.core.*;
import flash.Vector;

final class STPlayer extends AmigaPlayer
{
	var track:Vector<Int>;
	var patterns:Vector<AmigaRow>;
	var samples:Vector<AmigaSample>;
	var length:Int = 0;
	var voices:Vector<STVoice>;
	var trackPos:Int = 0;
	var patternPos:Int = 0;
	var jumpFlag:Int = 0;

	public function new(amiga:Amiga = null)
	{
		super(amiga);
		PERIODS.fixed = true;

		track = new Vector<Int>(128, true);
		samples = new Vector<AmigaSample>(16, true);
		voices = new Vector<STVoice>(4, true);

		voices[0] = new STVoice(0);
		voices[0].next = voices[1] = new STVoice(1);
		voices[1].next = voices[2] = new STVoice(2);
		voices[2].next = voices[3] = new STVoice(3);
	}

	override function set_force(value:Int):Int
	{
		if (value < ULTIMATE_SOUNDTRACKER)
		{
			value = ULTIMATE_SOUNDTRACKER;
		}
		else if (value > DOC_SOUNDTRACKER_20)
		{
			value = DOC_SOUNDTRACKER_20;
		}

		return version = value;
	}

	override function set_ntsc(value:Int):Int
	{
		super.ntsc = value;

		if (version < DOC_SOUNDTRACKER_9)
			amiga.samplesTick = Std.int((240 - tempo) * (value != 0 ? 7.5152005551 : 7.58437970472));
		return value;
	}

	override public function process()
	{
		var chan:AmigaChannel, row:AmigaRow, sample:AmigaSample, value:Int, voice = voices[0];

		if (tick == 0)
		{
			value = track[trackPos] + patternPos;

			while (voice != null)
			{
				chan = voice.channel;
				voice.enabled = 0;

				row = patterns[value + voice.index];
				voice.period = row.note;
				voice.effect = row.effect;
				voice.param = row.param;

				if (row.sample != 0)
				{
					sample = voice.sample = samples[row.sample];

					if (((version & 2) == 2) && voice.effect == 12)
					{
						chan.volume = voice.param;
					}
					else
					{
						chan.volume = sample.volume;
					}
				}
				else
				{
					sample = voice.sample;
				}

				if (voice.period != 0)
				{
					voice.enabled = 1;

					chan.enabled = 0;
					chan.pointer = sample.pointer;
					chan.length = sample.length;
					chan.period = voice.last = voice.period;
				}

				if (voice.enabled != 0)
					chan.enabled = 1;
				chan.pointer = sample.loopPtr;
				chan.length = sample.repeat;

				if (version < DOC_SOUNDTRACKER_20)
				{
					voice = voice.next;
					continue;
				}

				switch (voice.effect)
				{
					case 11: // position jump
						trackPos = voice.param - 1;
						jumpFlag ^= 1;

					case 12: // set volume
						chan.volume = voice.param;

					case 13: // pattern break
						jumpFlag ^= 1;

					case 14: // set filter
						amiga.filter.active = voice.param ^ 1;

					case 15 if (voice.param != 0): // set speed
						//FIX Haxe doesn't support switch/break
						//if (voice.param == 0)
							//break;
						speed = voice.param & 0x0f;
						tick = 0;
				}
				voice = voice.next;
			}
		}
		else
		{
			while (voice != null)
			{
				if (voice.param == 0)
				{
					voice = voice.next;
					continue;
				}
				chan = voice.channel;

				if (version == ULTIMATE_SOUNDTRACKER)
				{
					if (voice.effect == 1)
					{
						arpeggio(voice);
					}
					else if (voice.effect == 2)
					{
						value = voice.param >> 4;

						if (value != 0)
						{
							voice.period += value;
						}
						else
						{
							voice.period -= (voice.param & 0x0f);
						}

						chan.period = voice.period;
					}
				}
				else
				{
					switch (voice.effect)
					{
						case 0: // arpeggio
							arpeggio(voice);

						case 1: // portamento up
							voice.last -= voice.param & 0x0f;
							if (voice.last < 113)
								voice.last = 113;
							chan.period = voice.last;

						case 2: // portamento down
							voice.last += voice.param & 0x0f;
							if (voice.last > 856)
								voice.last = 856;
							chan.period = voice.last;
					}

					if ((version & 2) != 2)
					{
						voice = voice.next;
						continue;
					}

					switch (voice.effect)
					{
						case 12: // set volume
							chan.volume = voice.param;

						case 14: // set filter
							amiga.filter.active = 0;

						case 15: // set speed
							speed = voice.param & 0x0f;
					}
				}
				voice = voice.next;
			}
		}

		if (++tick == speed)
		{
			tick = 0;
			patternPos += 4;

			if (patternPos == 256 || jumpFlag != 0)
			{
				patternPos = jumpFlag = 0;

				if (++trackPos == length)
				{
					trackPos = 0;
					amiga.complete = 1;
				}
			}
		}
	}

	override function initialize()
	{
		var voice = voices[0];
		super.initialize();
		ntsc = standard;

		speed = 6;
		trackPos = 0;
		patternPos = 0;
		jumpFlag = 0;

		while (voice != null)
		{
			voice.initialize();
			voice.channel = amiga.channels[voice.index];
			voice.sample = samples[0];
			voice = voice.next;
		}
	}

	override function loader(stream:ByteArray)
	{
		var higher = 0, i:Int, j:Int, row:AmigaRow, sample:AmigaSample, score = 0, size = 0, value:Int;
		if (stream.length < 1626)
			return;

		title = stream.readMultiByte(20, CorePlayer.ENCODING);
		score += isLegal(title);

		version = ULTIMATE_SOUNDTRACKER;
		stream.position = 42;

		for (_tmp_ in 1...16)
		{
			i = _tmp_;
			value = stream.readUnsignedShort();

			if (value == 0)
			{
				samples[i] = null;
				stream.position += 28;
				continue;
			}

			sample = new AmigaSample();
			stream.position -= 24;

			sample.name = stream.readMultiByte(22, CorePlayer.ENCODING);
			sample.length = value << 1;
			stream.position += 3;

			sample.volume = stream.readUnsignedByte();
			sample.loop = stream.readUnsignedShort();
			sample.repeat = stream.readUnsignedShort() << 1;

			stream.position += 22;
			sample.pointer = size;
			size += sample.length;
			samples[i] = sample;

			score += isLegal(sample.name);
			if (sample.length > 9999)
				version = MASTER_SOUNDTRACKER;
		}

		stream.position = 470;
		length = stream.readUnsignedByte();
		tempo = stream.readUnsignedByte();

		for (_tmp_ in 0...128)
		{
			i = _tmp_;
			value = stream.readUnsignedByte() << 8;
			if (value > 16384)
				score--;
			track[i] = value;
			if (value > higher)
				higher = value;
		}

		stream.position = 600;
		higher += 256;
		patterns = new Vector<AmigaRow>(higher, true);

		i = (stream.length - size - 600) >> 2;
		if (higher > i)
			higher = i;

		for (_tmp_ in 0...higher)
		{
			i = _tmp_;
			row = new AmigaRow();

			row.note = stream.readUnsignedShort();
			value = stream.readUnsignedByte();
			row.param = stream.readUnsignedByte();
			row.effect = value & 0x0f;
			row.sample = value >> 4;

			patterns[i] = row;

			if (row.effect > 2 && row.effect < 11)
				score--;
			if (row.note != 0)
			{
				if (row.note < 113 || row.note > 856)
					score--;
			}

			if (row.sample != 0)
				if (row.sample > 15 || samples[row.sample] == null)
				{
					if (row.sample > 15)
						score--;
					row.sample = 0;
				}

			if (row.effect > 2 || (row.effect == 0 && row.param != 0))
				version = DOC_SOUNDTRACKER_9;

			if (row.effect == 11 || row.effect == 13)
				version = DOC_SOUNDTRACKER_20;
		}

		amiga.store(stream, size);

		for (_tmp_ in 1...16)
		{
			i = _tmp_;
			sample = samples[i];
			if (sample == null)
				continue;

			if (sample.loop != 0)
			{
				sample.loopPtr = sample.pointer + sample.loop;
				sample.pointer = sample.loopPtr;
				sample.length = sample.repeat;
			}
			else
			{
				sample.loopPtr = amiga.memory.length;
				sample.repeat = 2;
			}

			size = sample.pointer + 4;
			for (_tmp_ in sample.pointer...size)
			{
				j = _tmp_;
				amiga.memory[j] = 0;
			};
		}

		sample = new AmigaSample();
		sample.pointer = sample.loopPtr = amiga.memory.length;
		sample.length = sample.repeat = 2;
		samples[0] = sample;

		if (score < 1)
			version = 0;
	}

	function arpeggio(voice:STVoice)
	{
		var chan = voice.channel, i = 0, param = tick % 3;

		if (param == 0)
		{
			chan.period = voice.last;
			return;
		}

		if (param == 1)
		{
			param = voice.param >> 4;
		}
		else
		{
			param = voice.param & 0x0f;
		}

		while (voice.last != PERIODS[i])
			i++;
		chan.period = PERIODS[i + param];
	}

	function isLegal(text:String):Int
	{
		var ascii:Int, i = 0, len = text.length;
		if (len == 0)
			return 0;

		while (i < len)
		{
			ascii = text.charCodeAt(i);
			if (ascii != 0 && (ascii < 32 || ascii > 127))
				return 0;
			++i;
		}
		return 1;
	}

	public static inline final ULTIMATE_SOUNDTRACKER = 1;
	public static inline final DOC_SOUNDTRACKER_9 = 2;
	public static inline final MASTER_SOUNDTRACKER = 3;
	public static inline final DOC_SOUNDTRACKER_20 = 4;

	final PERIODS:Vector<Int> = Vector.ofArray([
		856, 808, 762, 720, 678, 640, 604, 570, 538, 508, 480, 453, 428, 404, 381, 360, 339, 320, 302, 285, 269, 254, 240, 226, 214, 202, 190, 180, 170, 160,
		151, 143, 135, 127, 120, 113, 0, 0, 0
	]);
}
