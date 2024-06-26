/*
	Flod 4.1
	2012/04/30
	Christian Corti
	Neoart Costa Rica

	Last Update: Flod 4.1 - 2012/04/14

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
	OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
	LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR
	IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

	This work is licensed under the Creative Commons Attribution-Noncommercial-Share Alike 3.0 Unported License.
	To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/3.0/ or send a letter to
	Creative Commons, 171 Second Street, Suite 300, San Francisco, California, 94105, USA.
 */
package neoart.flod.soundfx;

import flash.utils.*;
import neoart.flod.core.*;
import flash.Vector;

final class FXPlayer extends AmigaPlayer
{
	var track:Vector<Int>;
	var patterns:Vector<AmigaRow>;
	var samples:Vector<AmigaSample>;
	var length:Int = 0;
	var voices:Vector<FXVoice>;
	var trackPos:Int = 0;
	var patternPos:Int = 0;
	var jumpFlag:Int = 0;
	var delphine:Int = 0;

	public function new(amiga:Amiga = null)
	{
		super(amiga);
		PERIODS.fixed = true;

		track = new Vector<Int>(128, true);
		voices = new Vector<FXVoice>(4, true);

		voices[0] = new FXVoice(0);
		voices[0].next = voices[1] = new FXVoice(1);
		voices[1].next = voices[2] = new FXVoice(2);
		voices[2].next = voices[3] = new FXVoice(3);
	}

	override function set_force(value:Int):Int
	{
		if (value < SOUNDFX_10)
		{
			value = SOUNDFX_10;
		}
		else if (value > SOUNDFX_20)
		{
			value = SOUNDFX_20;
		}

		return version = value;
	}

	override function set_ntsc(value:Int):Int
	{
		super.ntsc = value;

		amiga.samplesTick = Std.int((tempo / 122) * (value != 0 ? 7.5152005551 : 7.58437970472));
		return value;
	}

	override public function process()
	{
		var chan:AmigaChannel, index:Int, period:Int, row:AmigaRow, sample:AmigaSample, value:Int, voice = voices[0];

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

				if (row.note == -3)
				{
					voice.effect = 0;
					voice = voice.next;
					continue;
				}

				if (row.sample != 0)
				{
					sample = voice.sample = samples[row.sample];
					voice.volume = sample.volume;

					if (voice.effect == 5)
					{
						voice.volume += voice.param;
					}
					else if (voice.effect == 6)
					{
						voice.volume -= voice.param;

						chan.volume = voice.volume;
					}
				}
				else
				{
					sample = voice.sample;
				}

				if (voice.period != 0)
				{
					voice.last = voice.period;
					voice.slideSpeed = 0;
					voice.stepSpeed = 0;

					voice.enabled = 1;
					chan.enabled = 0;

					switch (voice.period)
					{
						case -2:
							chan.volume = 0;

						case -4:
							this.jumpFlag = 1;

						case -5:

						default:
							chan.pointer = sample.pointer;
							chan.length = sample.length;

							if (delphine != 0)
							{
								chan.period = voice.period << 1;
							}
							else
							{
								chan.period = voice.period;
							}
					}

					if (voice.enabled != 0)
						chan.enabled = 1;
					chan.pointer = sample.loopPtr;
					chan.length = sample.repeat;
				}
				voice = voice.next;
			}
		}
		else
		{
			while (voice != null)
			{
				chan = voice.channel;

				if (version == SOUNDFX_18 && voice.period == -3)
				{
					voice = voice.next;
					continue;
				}

				if (voice.stepSpeed != 0)
				{
					voice.stepPeriod += voice.stepSpeed;

					if (voice.stepSpeed < 0)
					{
						if (voice.stepPeriod < voice.stepWanted)
						{
							voice.stepPeriod = voice.stepWanted;
							if (version > SOUNDFX_18)
								voice.stepSpeed = 0;
						}
					}
					else
					{
						if (voice.stepPeriod > voice.stepWanted)
						{
							voice.stepPeriod = voice.stepWanted;
							if (version > SOUNDFX_18)
								voice.stepSpeed = 0;
						}
					}

					if (version > SOUNDFX_18)
						voice.last = voice.stepPeriod;
					chan.period = voice.stepPeriod;
				}
				else
				{
					if (voice.slideSpeed != 0)
					{
						value = voice.slideParam & 0x0f;

						if (value != 0)
						{
							if (++voice.slideCtr == value)
							{
								voice.slideCtr = 0;
								value = (voice.slideParam << 4) << 3;

								if (voice.slideDir == 0)
								{
									voice.slidePeriod += 8;
									chan.period = voice.slidePeriod;
									value += voice.slideSpeed;
									if (value == voice.slidePeriod)
										voice.slideDir = 1;
								}
								else
								{
									voice.slidePeriod -= 8;
									chan.period = voice.slidePeriod;
									value -= voice.slideSpeed;
									if (value == voice.slidePeriod)
										voice.slideDir = 0;
								}
							}
							else
							{
								voice = voice.next;
								continue;
							}
						}
					}

					value = 0;

					switch (voice.effect)
					{
						case 0:

						case 1: // arpeggio
							value = tick % 3;
							index = 0;

							if (value == 2)
							{
								chan.period = voice.last;
								voice = voice.next;
								continue;
							}

							if (value == 1)
							{
								value = voice.param & 0x0f;
							}
							else
							{
								value = voice.param >> 4;
							}

							while (voice.last != PERIODS[index])
								index++;
							chan.period = PERIODS[index + value];

						case 2: // pitchbend
							value = voice.param >> 4;
							if (value != 0)
							{
								voice.period += value;
							}
							else
							{
								voice.period -= voice.param & 0x0f;
							}
							chan.period = voice.period;

						case 3: // filter on
							amiga.filter.active = 1;

						case 4: // filter off
							amiga.filter.active = 0;
						
						//FIX AS3 fallthrough case.
						//case 8: // step down
						//	value = -1;
						case 8: // step down
						case 7: // step up
							if (voice.effect == 8){
								value = -1;
							}
							voice.stepSpeed = voice.param & 0x0f;
							voice.stepPeriod = version > SOUNDFX_18 ? voice.last : voice.period;
							if (value < 0)
								voice.stepSpeed = -voice.stepSpeed;
							index = 0;

							while (true)
							{
								period = PERIODS[index];
								if (period == voice.stepPeriod)
									break;
								if (period < 0)
								{
									index = -1;
									break;
								}
								else
									index++;
							}

							if (index > -1)
							{
								period = voice.param >> 4;
								if (value > -1)
									period = -period;
								index += period;
								if (index < 0)
									index = 0;
								voice.stepWanted = PERIODS[index];
							}
							else
								voice.stepWanted = voice.period;

						case 9: // auto slide
							voice.slideSpeed = voice.slidePeriod = voice.period;
							voice.slideParam = voice.param;
							voice.slideDir = 0;
							voice.slideCtr = 0;
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
		var higher = 0, i:Int, id:String, j:Int, len:Int, offset:Int, row:AmigaRow, sample:AmigaSample, size = 0, value:Int;
		if (stream.length < 1686)
			return;

		stream.position = 60;
		id = stream.readMultiByte(4, CorePlayer.ENCODING);

		if (id != "SONG")
		{
			stream.position = 124;
			id = stream.readMultiByte(4, CorePlayer.ENCODING);
			if (id != "SO31")
				return;
			if (stream.length < 2350)
				return;

			offset = 544;
			len = 32;
			version = SOUNDFX_20;
		}
		else
		{
			offset = 0;
			len = 16;
			version = SOUNDFX_10;
		}

		samples = new Vector<AmigaSample>(len, true);
		tempo = stream.readUnsignedShort();
		stream.position = 0;

		for (_tmp_ in 1...len)
		{
			i = _tmp_;
			value = stream.readUnsignedInt();

			if (value != 0)
			{
				sample = new AmigaSample();
				sample.pointer = size;
				size += value;
				samples[i] = sample;
			}
			else
				samples[i] = null;
		}
		stream.position += 20;

		for (_tmp_ in 1...len)
		{
			i = _tmp_;
			sample = samples[i];
			if (sample == null)
			{
				stream.position += 30;
				continue;
			}

			sample.name = stream.readMultiByte(22, CorePlayer.ENCODING);
			sample.length = stream.readUnsignedShort() << 1;
			sample.volume = stream.readUnsignedShort();
			sample.loop = stream.readUnsignedShort();
			sample.repeat = stream.readUnsignedShort() << 1;
		}

		stream.position = 530 + offset;
		length = len = stream.readUnsignedByte();
		stream.position++;

		for (_tmp_ in 0...len)
		{
			i = _tmp_;
			value = stream.readUnsignedByte() << 8;
			track[i] = value;
			if (value > higher)
				higher = value;
		}

		if (offset != 0)
			offset += 4;
		stream.position = 660 + offset;
		higher += 256;
		patterns = new Vector<AmigaRow>(higher, true);

		len = samples.length;

		for (_tmp_ in 0...higher)
		{
			i = _tmp_;
			row = new AmigaRow();
			row.note = stream.readShort();
			value = stream.readUnsignedByte();
			row.param = stream.readUnsignedByte();
			row.effect = value & 0x0f;
			row.sample = value >> 4;

			patterns[i] = row;

			if (version == SOUNDFX_20)
			{
				if ((row.note & 0x1000) != 0)
				{
					row.sample += 16;
					if (row.note > 0)
						row.note &= 0xefff;
				}
			}
			else
			{
				if (row.effect == 9 || row.note > 856)
					version = SOUNDFX_18;

				if (row.note < -3)
					version = SOUNDFX_19;
			}
			if (row.sample >= len || samples[row.sample] == null)
				row.sample = 0;
		}

		amiga.store(stream, size);

		for (_tmp_ in 1...len)
		{
			i = _tmp_;
			sample = samples[i];
			if (sample == null)
				continue;

			if (sample.loop != 0)
			{
				sample.loopPtr = sample.pointer + sample.loop;
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

		stream.position = higher = delphine = 0;
		for (_tmp_ in 0...265)
		{
			i = _tmp_;
			higher += stream.readUnsignedShort();
		};

		switch (higher)
		{
			case 172662 | 1391423 | 1458300 | 1706977 | 1920077 | 1920694 | 1677853 | 1931956 | 1926836 | 1385071 | 1720635 | 1714491 | 1731874 | 1437490:
				delphine = 1;
		}
	}

	public static inline final SOUNDFX_10 = 1;
	public static inline final SOUNDFX_18 = 2;
	public static inline final SOUNDFX_19 = 3;
	public static inline final SOUNDFX_20 = 4;

	final PERIODS:Vector<Int> = Vector.ofArray([
		1076, 1016, 960, 906, 856, 808, 762, 720, 678, 640, 604, 570, 538, 508, 480, 453, 428, 404, 381, 360, 339, 320, 302, 285, 269, 254, 240, 226, 214, 202,
		190, 180, 170, 160, 151, 143, 135, 127, 120, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113,
		113, 113, 113, 113, 113, 113, -1
	]);
}
