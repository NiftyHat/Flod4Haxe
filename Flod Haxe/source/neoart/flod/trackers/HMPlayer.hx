/*
	Flod 4.1
	2012/04/30
	Christian Corti
	Neoart Costa Rica

	Last Update: Flod 4.1 - 2012/04/17

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

final class HMPlayer extends AmigaPlayer
{
	var track:Vector<Int>;
	var patterns:Vector<AmigaRow>;
	var samples:Vector<HMSample>;
	var length:Int = 0;
	var restart:Int = 0;
	var voices:Vector<HMVoice>;
	var trackPos:Int = 0;
	var patternPos:Int = 0;
	var jumpFlag:Int = 0;

	public function new(amiga:Amiga = null)
	{
		super(amiga);
		MEGARPEGGIO.fixed = true;
		PERIODS.fixed = true;
		VIBRATO.fixed = true;

		track = new Vector<Int>(128, true);
		samples = new Vector<HMSample>(32, true);
		voices = new Vector<HMVoice>(4, true);

		voices[0] = new HMVoice(0);
		voices[0].next = voices[1] = new HMVoice(1);
		voices[1].next = voices[2] = new HMVoice(2);
		voices[2].next = voices[3] = new HMVoice(3);
	}

	override public function process()
	{
		var chan:AmigaChannel, pattern:Int, row:AmigaRow, sample:HMSample, value:Int, voice = voices[0];

		if (this.tick == 0)
		{
			pattern = track[trackPos] + patternPos;

			while (voice != null)
			{
				chan = voice.channel;
				voice.enabled = 0;

				row = patterns[pattern + voice.index];
				voice.effect = row.effect;
				voice.param = row.param;

				if (row.sample != 0)
				{
					sample = voice.sample = samples[row.sample];
					voice.volume2 = sample.volume;

					if (sample.name == "Mupp")
					{
						sample.loopPtr = sample.pointer + sample.waves[0];
						voice.handler = 1;
						voice.volume1 = sample.volumes[0];
					}
					else
					{
						voice.handler = 0;
						voice.volume1 = 64;
					}
				}
				else
				{
					sample = voice.sample;
				}

				if (row.note != 0)
				{
					if (voice.effect == 3 || voice.effect == 5)
					{
						if (row.note < voice.period)
						{
							voice.portaDir = 1;
							voice.portaPeriod = row.note;
						}
						else if (row.note > voice.period)
						{
							voice.portaDir = 0;
							voice.portaPeriod = row.note;
						}
						else
						{
							voice.portaPeriod = 0;
						}
					}
					else
					{
						voice.period = row.note;
						voice.vibratoPos = 0;
						voice.wavePos = 0;
						voice.enabled = 1;

						chan.enabled = 0;
						value = (voice.period * sample.finetune) >> 8;
						chan.period = voice.period + value;

						if (voice.handler != 0)
						{
							chan.pointer = sample.loopPtr;
							chan.length = sample.repeat;
						}
						else
						{
							chan.pointer = sample.pointer;
							chan.length = sample.length;
						}
					}
				}

				switch (voice.effect)
				{
					case 11: // position jump
						trackPos = voice.param - 1;
						jumpFlag = 1;

					case 12: // set volume
						voice.volume2 = voice.param;
						if (voice.volume2 > 64)
							voice.volume2 = 64;

					case 13: // pattern break
						jumpFlag = 1;

					case 14: // set filter
						amiga.filter.active = voice.param ^ 1;

					case 15: // set speed
						value = voice.param;

						if (value < 1)
						{
							value = 1;
						}
						else if (value > 31)
						{
							value = 31;
						}

						speed = value;
						tick = 0;
				}

				if (row.note == 0)
					effects(voice);
				handler(voice);

				if (voice.enabled != 0)
					chan.enabled = 1;
				chan.pointer = sample.loopPtr;
				chan.length = sample.repeat;

				voice = voice.next;
			}
		}
		else
		{
			while (voice != null)
			{
				effects(voice);
				handler(voice);

				sample = voice.sample;
				voice.channel.pointer = sample.loopPtr;
				voice.channel.length = sample.repeat;

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
				trackPos = (++trackPos & 127);

				if (trackPos == length)
				{
					trackPos = restart;
					amiga.complete = 1;
				}
			}
		}
	}

	override function initialize()
	{
		var voice = voices[0];
		super.initialize();

		speed = 6;
		trackPos = 0;
		patternPos = 0;
		jumpFlag = 0;

		amiga.samplesTick = 884;

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
		var count:Int, higher = 0, i:Int, id:String, j:Int, mupp = 0, position:Int, row:AmigaRow, sample:HMSample, size = 0, value:Int;
		if (stream.length < 2106)
			return;

		stream.position = 1080;
		id = stream.readMultiByte(4, CorePlayer.ENCODING);
		if (id != "FEST")
			return;

		stream.position = 950;
		length = stream.readUnsignedByte();
		restart = stream.readUnsignedByte();

		for (_tmp_ in 0...128)
		{
			i = _tmp_;
			track[i] = stream.readUnsignedByte();
		};

		stream.position = 0;
		title = stream.readMultiByte(20, CorePlayer.ENCODING);
		version = 1;

		for (_tmp_ in 1...32)
		{
			i = _tmp_;
			samples[i] = null;
			id = stream.readMultiByte(4, CorePlayer.ENCODING);

			if (id == "Mupp")
			{
				value = stream.readUnsignedByte();
				count = value - higher++;
				for (_tmp_ in 0...128)
				{
					j = _tmp_;
					if (track[j] != 0 && track[j] >= count)
						track[j]--;
				};

				sample = new HMSample();
				sample.name = id;
				sample.length = sample.repeat = 32;
				sample.restart = stream.readUnsignedByte();
				sample.waveLen = stream.readUnsignedByte();
				stream.position += 17;
				sample.finetune = stream.readByte();
				sample.volume = stream.readUnsignedByte();

				position = stream.position + 4;
				value = 1084 + (value << 10);
				stream.position = value;

				sample.pointer = amiga.memory.length;
				sample.waves = new Vector<Int>(64, true);
				sample.volumes = new Vector<Int>(64, true);
				amiga.store(stream, 896);

				for (_tmp_ in 0...64)
				{
					j = _tmp_;
					sample.waves[j] = stream.readUnsignedByte() << 5;
				};
				for (_tmp_ in 0...64)
				{
					j = _tmp_;
					sample.volumes[j] = stream.readUnsignedByte() & 127;
				};

				stream.position = value;
				stream.writeInt(0x666c6f64);
				stream.position = position;
				mupp += 896;
			}
			else
			{
				id = id.substr(0, 2);
				if (id == "El")
				{
					stream.position += 18;
				}
				else
				{
					stream.position -= 4;
					id = stream.readMultiByte(22, CorePlayer.ENCODING);
				}

				value = stream.readUnsignedShort();
				if (value == 0)
				{
					stream.position += 6;
					continue;
				}

				sample = new HMSample();
				sample.name = id;
				sample.pointer = size;
				sample.length = value << 1;
				sample.finetune = stream.readByte();
				sample.volume = stream.readUnsignedByte();
				sample.loop = stream.readUnsignedShort() << 1;
				sample.repeat = stream.readUnsignedShort() << 1;
				size += sample.length;
			}
			samples[i] = sample;
		}

		for (_tmp_ in 0...128)
		{
			i = _tmp_;
			value = track[i] << 8;
			track[i] = value;
			if (value > higher)
				higher = value;
		}

		stream.position = 1084;
		higher += 256;
		patterns = new Vector<AmigaRow>(higher, true);

		for (_tmp_ in 0...higher)
		{
			i = _tmp_;
			value = stream.readUnsignedInt();
			while (value == 0x666c6f64)
			{
				stream.position += 1020;
				value = stream.readUnsignedInt();
			}

			row = new AmigaRow();
			row.note = (value >> 16) & 0x0fff;
			row.sample = (value >> 24) & 0xf0 | (value >> 12) & 0x0f;
			row.effect = (value >> 8) & 0x0f;
			row.param = value & 0xff;

			if (row.sample > 31 || samples[row.sample] == null)
				row.sample = 0;

			patterns[i] = row;
		}

		amiga.store(stream, size);

		for (_tmp_ in 1...32)
		{
			i = _tmp_;
			sample = samples[i];
			if (sample == null || sample.name == "Mupp")
				continue;
			sample.pointer += mupp;

			if (sample.loop != 0)
			{
				sample.loopPtr = sample.pointer + sample.loop;
				sample.length = sample.loop + sample.repeat;
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

		sample = new HMSample();
		sample.pointer = sample.loopPtr = amiga.memory.length;
		sample.length = sample.repeat = 2;
		samples[0] = sample;
	}

	function effects(voice:HMVoice)
	{
		var chan = voice.channel, i = 0, len:Int, period = voice.period & 0x0fff, slide = 0, value:Int;

		if (voice.effect != 0 || voice.param != 0)
		{
			switch (voice.effect)
			{
				case 0: // arpeggio
					value = tick % 3;
					// haxe doesn't support break so replace it with conditional logic.
					if (value > 0)
					{
						if (value == 1)
						{
							value = voice.param >> 4;
						}
						else
						{
							value = voice.param & 0x0f;
						}

						len = 37 - value;

						for (_tmp_ in 0...len)
						{
							i = _tmp_;
							if (period >= PERIODS[i])
							{
								period = PERIODS[i + value];
								break;
							}
						}
					}
				case 1: // portamento up
					voice.period -= voice.param;
					if (voice.period < 113)
						voice.period = 113;
					period = voice.period;

				case 2: // portamento down
					voice.period += voice.param;
					if (voice.period > 856)
						voice.period = 856;
					period = voice.period;

				case 3 // tone portamento
					| 5: // tone portamento + volume slide
					if (voice.effect == 5)
					{
						slide = 1;
					}
					else if (voice.param != 0)
					{
						voice.portaSpeed = voice.param;
						voice.param = 0;
					}

					if (voice.portaPeriod != 0)
					{
						if (voice.portaDir != 0)
						{
							voice.period -= voice.portaSpeed;
							if (voice.period < voice.portaPeriod)
							{
								voice.period = voice.portaPeriod;
								voice.portaPeriod = 0;
							}
						}
						else
						{
							voice.period += voice.portaSpeed;
							if (voice.period > voice.portaPeriod)
							{
								voice.period = voice.portaPeriod;
								voice.portaPeriod = 0;
							}
						}
					}
					period = voice.period;

				case 4 | 6: // vibrato | vibrato + volume slide;
					if (voice.effect == 6)
					{
						slide = 1;
					}
					else if (voice.param != 0)
					{
						voice.vibratoSpeed = voice.param;
					}

					value = VIBRATO[(voice.vibratoPos >> 2) & 31];
					value = ((voice.vibratoSpeed & 0x0f) * value) >> 7;

					if (voice.vibratoPos > 127)
					{
						period -= value;
					}
					else
					{
						period += value;
					}

					value = (voice.vibratoSpeed >> 2) & 60;
					voice.vibratoPos = (voice.vibratoPos + value) & 255;

				case 7: // mega arpeggio
					value = MEGARPEGGIO[(voice.vibratoPos & 0x0f) + ((voice.param & 0x0f) << 4)];
					voice.vibratoPos++;
					for (_tmp_ in 0...37)
					{
						i = _tmp_;
						if (period >= PERIODS[i])
							break;
					};

					value += i;
					if (value > 35)
						value -= 12;
					period = PERIODS[value];

				case 10: // volume slide
					slide = 1;
			}
		}

		chan.period = period + ((period * voice.sample.finetune) >> 8);

		if (slide != 0)
		{
			value = voice.param >> 4;

			if (value != 0)
			{
				voice.volume2 += value;
			}
			else
			{
				voice.volume2 -= voice.param & 0x0f;
			}

			if (voice.volume2 > 64)
			{
				voice.volume2 = 64;
			}
			else if (voice.volume2 < 0)
			{
				voice.volume2 = 0;
			}
		}
	}

	function handler(voice:HMVoice)
	{
		var sample:HMSample;

		if (voice.handler != 0)
		{
			sample = voice.sample;
			sample.loopPtr = sample.pointer + sample.waves[voice.wavePos];

			voice.volume1 = sample.volumes[voice.wavePos];

			if (++voice.wavePos > sample.waveLen)
				voice.wavePos = sample.restart;
		}
		voice.channel.volume = (voice.volume1 * voice.volume2) >> 6;
	}

	final MEGARPEGGIO:Vector<Int> = Vector.ofArray([
		0, 3, 7, 12, 15, 12, 7, 3, 0, 3, 7, 12, 15, 12, 7, 3, 0, 4, 7, 12, 16, 12, 7, 4, 0, 4, 7, 12, 16, 12, 7, 4, 0, 3, 8, 12, 15, 12, 8, 3, 0, 3, 8, 12, 15,
		12, 8, 3, 0, 4, 8, 12, 16, 12, 8, 4, 0, 4, 8, 12, 16, 12, 8, 4, 0, 5, 8, 12, 17, 12, 8, 5, 0, 5, 8, 12, 17, 12, 8, 5, 0, 5, 9, 12, 17, 12, 9, 5, 0, 5,
		9, 12, 17, 12, 9, 5, 12, 0, 7, 0, 3, 0, 7, 0, 12, 0, 7, 0, 3, 0, 7, 0, 12, 0, 7, 0, 4, 0, 7, 0, 12, 0, 7, 0, 4, 0, 7, 0, 0, 3, 7, 3, 7, 12, 7, 12, 15,
		12, 7, 12, 7, 3, 7, 3, 0, 4, 7, 4, 7, 12, 7, 12, 16, 12, 7, 12, 7, 4, 7, 4, 31, 27, 24, 19, 15, 12, 7, 3, 0, 3, 7, 12, 15, 19, 24, 27, 31, 28, 24, 19,
		16, 12, 7, 4, 0, 4, 7, 12, 16, 19, 24, 28, 0, 12, 0, 12, 0, 12, 0, 12, 0, 12, 0, 12, 0, 12, 0, 12, 0, 12, 24, 12, 0, 12, 24, 12, 0, 12, 24, 12, 0, 12,
		24, 12, 0, 3, 0, 3, 0, 3, 0, 3, 0, 3, 0, 3, 0, 3, 0, 3, 0, 4, 0, 4, 0, 4, 0, 4, 0, 4, 0, 4, 0, 4, 0, 4
	]);
	final PERIODS:Vector<Int> = Vector.ofArray([
		856, 808, 762, 720, 678, 640, 604, 570, 538, 508, 480, 453, 428, 404, 381, 360, 339, 320, 302, 285, 269, 254, 240, 226, 214, 202, 190, 180, 170, 160,
		151, 143, 135, 127, 120, 113, 0
	]);
	final VIBRATO:Vector<Int> = Vector.ofArray([
		0, 24, 49, 74, 97, 120, 141, 161, 180, 197, 212, 224, 235, 244, 250, 253, 255, 253, 250, 244, 235, 224, 212, 197, 180, 161, 141, 120, 97, 74, 49, 24
	]);
}
