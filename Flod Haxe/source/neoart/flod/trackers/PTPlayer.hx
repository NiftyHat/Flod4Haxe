/*
	Flod 4.1
	2012/04/30
	Christian Corti
	Neoart Costa Rica

	Last Update: Flod 4.1 - 2012/04/16

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

final class PTPlayer extends AmigaPlayer
{
	var track:Vector<Int>;
	var patterns:Vector<PTRow>;
	var samples:Vector<PTSample>;
	var length:Int = 0;
	var voices:Vector<PTVoice>;
	var trackPos:Int = 0;
	var patternPos:Int = 0;
	var patternBreak:Int = 0;
	var patternDelay:Int = 0;
	var breakPos:Int = 0;
	var jumpFlag:Int = 0;
	var vibratoDepth:Int = 0;

	public function new(amiga:Amiga = null)
	{
		super(amiga);
		PERIODS.fixed = true;
		VIBRATO.fixed = true;
		FUNKREP.fixed = true;

		track = new Vector<Int>(128, true);
		samples = new Vector<PTSample>(32, true);
		voices = new Vector<PTVoice>(4, true);

		voices[0] = new PTVoice(0);
		voices[0].next = voices[1] = new PTVoice(1);
		voices[1].next = voices[2] = new PTVoice(2);
		voices[2].next = voices[3] = new PTVoice(3);
	}

	override function set_force(value:Int):Int
	{
		if (value < PROTRACKER_10)
		{
			value = PROTRACKER_10;
		}
		else if (value > PROTRACKER_12)
		{
			value = PROTRACKER_12;
		}

		version = value;

		if (value < PROTRACKER_11)
		{
			vibratoDepth = 6;
		}
		else
		{
			vibratoDepth = 7;
		}
		return value;
	}

	override public function process()
	{
		var chan:AmigaChannel, i = 0, pattern:Int, row:PTRow, sample:PTSample, value:Int, voice = voices[0];

		if (tick == 0)
		{
			if (patternDelay != 0)
			{
				effects();
			}
			else
			{
				pattern = track[trackPos] + patternPos;

				while (voice != null)
				{
					chan = voice.channel;
					voice.enabled = 0;

					if (voice.step == 0)
						chan.period = voice.period;

					row = patterns[pattern + voice.index];
					voice.step = row.step;
					voice.effect = row.effect;
					voice.param = row.param;

					if (row.sample != 0)
					{
						sample = voice.sample = samples[row.sample];

						voice.pointer = sample.pointer;
						voice.length = sample.length;
						voice.loopPtr = voice.funkWave = sample.loopPtr;
						voice.repeat = sample.repeat;
						voice.finetune = sample.finetune;

						chan.volume = voice.volume = sample.volume;
					}
					else
					{
						sample = voice.sample;
					}

					if (row.note == 0)
					{
						moreEffects(voice);
						voice = voice.next;
						continue;
					}
					else
					{
						if ((voice.step & 0x0ff0) == 0x0e50)
						{
							voice.finetune = (voice.param & 0x0f) * 37;
						}
						else if (voice.effect == 3 || voice.effect == 5)
						{
							if (row.note == voice.period)
							{
								voice.portaPeriod = 0;
							}
							else
							{
								i = voice.finetune;
								value = i + 37;

								i;
								while (i < value)
								{
									if (row.note >= PERIODS[i])
										break;
									++i;
								};

								if (i == value)
									value--;

								if (i > 0)
								{
									value = Std.int(voice.finetune / 37) & 8;
									if (value != 0)
										i--;
								}

								voice.portaPeriod = PERIODS[i];
								voice.portaDir = row.note > voice.portaPeriod ? 0 : 1;
							}
						}
						else if (voice.effect == 9)
						{
							moreEffects(voice);
						}
					}

					for (_tmp_ in 0...37)
					{
						i = _tmp_;
						if (row.note >= PERIODS[i])
							break;
					};

					voice.period = PERIODS[voice.finetune + i];

					if ((voice.step & 0x0ff0) == 0x0ed0)
					{
						if (voice.funkSpeed != 0)
							updateFunk(voice);
						extended(voice);
						voice = voice.next;
						continue;
					}

					if (voice.vibratoWave < 4)
						voice.vibratoPos = 0;
					if (voice.tremoloWave < 4)
						voice.tremoloPos = 0;

					chan.enabled = 0;
					chan.pointer = voice.pointer;
					chan.length = voice.length;
					chan.period = voice.period;

					voice.enabled = 1;
					moreEffects(voice);
					voice = voice.next;
				}
				voice = voices[0];

				while (voice != null)
				{
					chan = voice.channel;
					if (voice.enabled != 0)
						chan.enabled = 1;

					chan.pointer = voice.loopPtr;
					chan.length = voice.repeat;

					voice = voice.next;
				}
			}
		}
		else
		{
			effects();
		}

		if (++tick == speed)
		{
			tick = 0;
			patternPos += 4;

			if (patternDelay != 0)
				if (--patternDelay != 0)
					patternPos -= 4;

			if (patternBreak != 0)
			{
				patternBreak = 0;
				patternPos = breakPos;
				breakPos = 0;
			}

			if (patternPos == 256 || jumpFlag != 0)
			{
				patternPos = breakPos;
				breakPos = 0;
				jumpFlag = 0;

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

		tempo = 125;
		speed = 6;
		trackPos = 0;
		patternPos = 0;
		patternBreak = 0;
		patternDelay = 0;
		breakPos = 0;
		jumpFlag = 0;

		super.initialize();
		force = version;

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
		var higher = 0, i:Int, id:String, j:Int, row:PTRow, sample:PTSample, size = 0, value:Int;
		if (stream.length < 2106)
			return;

		stream.position = 1080;
		id = stream.readMultiByte(4, CorePlayer.ENCODING);
		if (id != "M.K." && id != "M!K!")
			return;

		stream.position = 0;
		title = stream.readMultiByte(20, CorePlayer.ENCODING);
		version = PROTRACKER_10;
		stream.position += 22;

		for (_tmp_ in 1...32)
		{
			i = _tmp_;
			value = stream.readUnsignedShort();

			if (value == 0)
			{
				samples[i] = null;
				stream.position += 28;
				continue;
			}

			sample = new PTSample();
			stream.position -= 24;

			sample.name = stream.readMultiByte(22, CorePlayer.ENCODING);
			sample.length = sample.realLen = value << 1;
			stream.position += 2;

			sample.finetune = stream.readUnsignedByte() * 37;
			sample.volume = stream.readUnsignedByte();
			sample.loop = stream.readUnsignedShort() << 1;
			sample.repeat = stream.readUnsignedShort() << 1;

			stream.position += 22;
			sample.pointer = size;
			size += sample.length;
			samples[i] = sample;
		}

		stream.position = 950;
		length = stream.readUnsignedByte();
		stream.position++;

		for (_tmp_ in 0...128)
		{
			i = _tmp_;
			value = stream.readUnsignedByte() << 8;
			track[i] = value;
			if (value > higher)
				higher = value;
		}

		stream.position = 1084;
		higher += 256;
		patterns = new Vector<PTRow>(higher, true);

		for (_tmp_ in 0...higher)
		{
			i = _tmp_;
			row = new PTRow();
			row.step = value = stream.readUnsignedInt();

			row.note = (value >> 16) & 0x0fff;
			row.effect = (value >> 8) & 0x0f;
			row.sample = (value >> 24) & 0xf0 | (value >> 12) & 0x0f;
			row.param = value & 0xff;

			patterns[i] = row;

			if (row.sample > 31 || samples[row.sample] == null)
				row.sample = 0;

			if (row.effect == 15 && row.param > 31)
				version = PROTRACKER_11;

			if (row.effect == 8)
				version = PROTRACKER_12;
		}

		amiga.store(stream, size);

		for (_tmp_ in 1...32)
		{
			i = _tmp_;
			sample = samples[i];
			if (sample == null)
				continue;

			if (sample.loop != 0 || sample.repeat > 4)
			{
				sample.loopPtr = sample.pointer + sample.loop;
				sample.length = sample.loop + sample.repeat;
			}
			else
			{
				sample.loopPtr = amiga.memory.length;
				sample.repeat = 2;
			}

			size = sample.pointer + 2;
			for (_tmp_ in sample.pointer...size)
			{
				j = _tmp_;
				amiga.memory[j] = 0;
			};
		}

		sample = new PTSample();
		sample.pointer = sample.loopPtr = amiga.memory.length;
		sample.length = sample.repeat = 2;
		samples[0] = sample;
	}

	function effects()
	{
		var chan:AmigaChannel, i:Int, position:Int, slide = 0, value:Int, voice = voices[0], wave:Int;

		while (voice != null)
		{
			chan = voice.channel;
			if (voice.funkSpeed != 0)
				updateFunk(voice);

			if ((voice.step & 0x0fff) == 0)
			{
				chan.period = voice.period;
				voice = voice.next;
				continue;
			}

			switch (voice.effect)
			{
				case 0: // arpeggio
					value = tick % 3;

					if (value == 0)
					{
						chan.period = voice.period;
						voice = voice.next;
						continue;
					}

					if (value == 1)
					{
						value = voice.param >> 4;
					}
					else
					{
						value = voice.param & 0x0f;
					}

					i = voice.finetune;
					position = i + 37;

					i;
					while (i < position)
					{
						if (voice.period >= PERIODS[i])
						{
							chan.period = PERIODS[i + value];
							break;
						};

						++i;
					}
				case 1: // portamento up
					voice.period -= voice.param;
					if (voice.period < 113)
						voice.period = 113;
					chan.period = voice.period;

				case 2: // portamento down
					voice.period += voice.param;
					if (voice.period > 856)
						voice.period = 856;
					chan.period = voice.period;

				case 3 // tone portamento
					| 5: // tone portamento + volume slide
					if (voice.effect == 5)
					{
						slide = 1;
					}
					else
					{
						voice.portaSpeed = voice.param;
						voice.param = 0;
					}

					if (voice.portaPeriod != 0)
					{
						if (voice.portaDir != 0)
						{
							voice.period -= voice.portaSpeed;

							if (voice.period <= voice.portaPeriod)
							{
								voice.period = voice.portaPeriod;
								voice.portaPeriod = 0;
							}
						}
						else
						{
							voice.period += voice.portaSpeed;

							if (voice.period >= voice.portaPeriod)
							{
								voice.period = voice.portaPeriod;
								voice.portaPeriod = 0;
							}
						}

						if (voice.glissando != 0)
						{
							i = voice.finetune;
							value = i + 37;

							i;
							while (i < value)
							{
								if (voice.period >= PERIODS[i])
									break;
								++i;
							};

							if (i == value)
								i--;
							chan.period = PERIODS[i];
						}
						else
						{
							chan.period = voice.period;
						}
					}

				case 4 // vibrato
					| 6: // vibrato + volume slide
					if (voice.effect == 6)
					{
						slide = 1;
					}
					else if (voice.param != 0)
					{
						value = voice.param & 0x0f;
						if (value != 0)
							voice.vibratoParam = (voice.vibratoParam & 0xf0) | value;
						value = voice.param & 0xf0;
						if (value != 0)
							voice.vibratoParam = (voice.vibratoParam & 0x0f) | value;
					}

					position = (voice.vibratoPos >> 2) & 31;
					wave = voice.vibratoWave & 3;

					if (wave != 0)
					{
						value = 255;
						position <<= 3;

						if (wave == 1)
						{
							if (voice.vibratoPos > 127)
							{
								value -= position;
							}
							else
							{
								value = position;
							}
						}
					}
					else
					{
						value = VIBRATO[position];
					}

					value = ((voice.vibratoParam & 0x0f) * value) >> vibratoDepth;

					if (voice.vibratoPos > 127)
					{
						chan.period = voice.period - value;
					}
					else
					{
						chan.period = voice.period + value;
					}

					value = (voice.vibratoParam >> 2) & 60;
					voice.vibratoPos = (voice.vibratoPos + value) & 255;

				case 7: // tremolo
					chan.period = voice.period;

					if (voice.param != 0)
					{
						value = voice.param & 0x0f;
						if (value != 0)
							voice.tremoloParam = (voice.tremoloParam & 0xf0) | value;
						value = voice.param & 0xf0;
						if (value != 0)
							voice.tremoloParam = (voice.tremoloParam & 0x0f) | value;
					}

					position = (voice.tremoloPos >> 2) & 31;
					wave = voice.tremoloWave & 3;

					if (wave != 0)
					{
						value = 255;
						position <<= 3;

						if (wave == 1)
						{
							if (voice.tremoloPos > 127)
							{
								value -= position;
							}
							else
							{
								value = position;
							}
						}
					}
					else
					{
						value = VIBRATO[position];
					}

					value = ((voice.tremoloParam & 0x0f) * value) >> 6;

					if (voice.tremoloPos > 127)
					{
						chan.volume = voice.volume - value;
					}
					else
					{
						chan.volume = voice.volume + value;
					}

					value = (voice.tremoloParam >> 2) & 60;
					voice.tremoloPos = (voice.tremoloPos + value) & 255;

				case 10: // volume slide
					slide = 1;

				case 14: // extended effects
					extended(voice);
			}

			if (slide != 0)
			{
				slide = 0;
				value = voice.param >> 4;

				if (value != 0)
				{
					voice.volume += value;
				}
				else
				{
					voice.volume -= voice.param & 0x0f;
				}

				if (voice.volume < 0)
				{
					voice.volume = 0;
				}
				else if (voice.volume > 64)
				{
					voice.volume = 64;
				}

				chan.volume = voice.volume;
			}
			voice = voice.next;
		}
	}

	function moreEffects(voice:PTVoice)
	{
		var chan = voice.channel, value:Int;
		if (voice.funkSpeed != 0)
			updateFunk(voice);

		switch (voice.effect)
		{
			case 9: // sample offset
				if (voice.param != 0)
					voice.offset = voice.param;
				value = voice.offset << 8;

				if (value >= voice.length)
				{
					voice.length = 2;
				}
				else
				{
					voice.pointer += value;
					voice.length -= value;
				}

			case 11: // position jump
				trackPos = voice.param - 1;
				breakPos = 0;
				jumpFlag = 1;

			case 12: // set volume
				voice.volume = voice.param;
				if (voice.volume > 64)
					voice.volume = 64;
				chan.volume = voice.volume;

			case 13: // pattern break
				breakPos = ((voice.param >> 4) * 10) + (voice.param & 0x0f);

				if (breakPos > 63)
				{
					breakPos = 0;
				}
				else
				{
					breakPos <<= 2;
				}

				jumpFlag = 1;

			case 14: // extended effects
				extended(voice);

			case 15: // set speed
				if (voice.param == 0)
					return;

				if (voice.param < 32)
				{
					speed = voice.param;
				}
				else
				{
					amiga.samplesTick = Std.int(110250 / voice.param);
				}

				tick = 0;
		}
	}

	function extended(voice:PTVoice)
	{
		var chan = voice.channel, effect = voice.param >> 4, i:Int, len:Int, memory:Vector<Int>, param = voice.param & 0x0f;

		switch (effect)
		{
			case 0: // set filter
				amiga.filter.active = param;

			case 1: // fine portamento up
				if (tick != 0)
					return;
				voice.period -= param;
				if (voice.period < 113)
					voice.period = 113;
				chan.period = voice.period;

			case 2: // fine portamento down
				if (tick != 0)
					return;
				voice.period += param;
				if (voice.period > 856)
					voice.period = 856;
				chan.period = voice.period;

			case 3: // glissando control
				voice.glissando = param;

			case 4: // vibrato control
				voice.vibratoWave = param;

			case 5: // set finetune
				voice.finetune = param * 37;

			case 6: // pattern loop
				if (tick != 0)
					return;

				if (param != 0)
				{
					if (voice.loopCtr != 0)
					{
						voice.loopCtr--;
					}
					else
					{
						voice.loopCtr = param;
					}

					if (voice.loopCtr != 0)
					{
						breakPos = voice.loopPos << 2;
						patternBreak = 1;
					}
				}
				else
				{
					voice.loopPos = patternPos >> 2;
				}

			case 7: // tremolo control
				voice.tremoloWave = param;

			case 8: // karplus strong
				len = voice.length - 2;
				memory = amiga.memory;

				i = voice.loopPtr;
				while (i < len)
					memory[i] = Std.int((memory[i] + memory[++i]) * 0.5);

				memory[++i] = Std.int((memory[i] + memory[0]) * 0.5);

			case 9: // retrig note
				if (tick != 0 || param == 0 || voice.period == 0)
					return;
				if (tick % param != 0)
					return;

				chan.enabled = 0;
				chan.pointer = voice.pointer;
				chan.length = voice.length;
				chan.delay = 30;

				chan.enabled = 1;
				chan.pointer = voice.loopPtr;
				chan.length = voice.repeat;
				chan.period = voice.period;

			case 10: // fine volume up
				if (tick != 0)
					return;
				voice.volume += param;
				if (voice.volume > 64)
					voice.volume = 64;
				chan.volume = voice.volume;

			case 11: // fine volume down
				if (tick != 0)
					return;
				voice.volume -= param;
				if (voice.volume < 0)
					voice.volume = 0;
				chan.volume = voice.volume;

			case 12: // note cut
				if (tick == param)
					chan.volume = voice.volume = 0;

			case 13: // note delay
				if (tick != param || voice.period == 0)
					return;

				chan.enabled = 0;
				chan.pointer = voice.pointer;
				chan.length = voice.length;
				chan.delay = 30;

				chan.enabled = 1;
				chan.pointer = voice.loopPtr;
				chan.length = voice.repeat;
				chan.period = voice.period;

			case 14: // pattern delay
				if (tick != 0 || patternDelay != 0)
					return;
				patternDelay = ++param;

			case 15: // funk repeat or invert loop
				if (tick != 0)
					return;
				voice.funkSpeed = param;
				if (param != 0)
					updateFunk(voice);
		}
	}

	function updateFunk(voice:PTVoice)
	{
		var chan = voice.channel, p1:Int, p2:Int, value = FUNKREP[voice.funkSpeed];

		voice.funkPos += value;
		if (voice.funkPos < 128)
			return;
		voice.funkPos = 0;

		if (version == PROTRACKER_10)
		{
			p1 = voice.pointer + voice.sample.realLen - voice.repeat;
			p2 = voice.funkWave + voice.repeat;

			if (p2 > p1)
			{
				p2 = voice.loopPtr;
				chan.length = voice.repeat;
			}
			chan.pointer = voice.funkWave = p2;
		}
		else
		{
			p1 = voice.loopPtr + voice.repeat;
			p2 = voice.funkWave + 1;

			if (p2 >= p1)
				p2 = voice.loopPtr;

			amiga.memory[p2] = -amiga.memory[p2];
		}
	}

	public static inline final PROTRACKER_10 = 1;
	public static inline final PROTRACKER_11 = 2;
	public static inline final PROTRACKER_12 = 3;

	final PERIODS:Vector<Int> = Vector.ofArray([
		856, 808, 762, 720, 678, 640, 604, 570, 538, 508, 480, 453, 428, 404, 381, 360, 339, 320, 302, 285, 269, 254, 240, 226, 214, 202, 190, 180, 170, 160,
		151, 143, 135, 127, 120, 113, 0, 850, 802, 757, 715, 674, 637, 601, 567, 535, 505, 477, 450, 425, 401, 379, 357, 337, 318, 300, 284, 268, 253, 239,
		225, 213, 201, 189, 179, 169, 159, 150, 142, 134, 126, 119, 113, 0, 844, 796, 752, 709, 670, 632, 597, 563, 532, 502, 474, 447, 422, 398, 376, 355,
		335, 316, 298, 282, 266, 251, 237, 224, 211, 199, 188, 177, 167, 158, 149, 141, 133, 125, 118, 112, 0, 838, 791, 746, 704, 665, 628, 592, 559, 528,
		498, 470, 444, 419, 395, 373, 352, 332, 314, 296, 280, 264, 249, 235, 222, 209, 198, 187, 176, 166, 157, 148, 140, 132, 125, 118, 111, 0, 832, 785,
		741, 699, 660, 623, 588, 555, 524, 495, 467, 441, 416, 392, 370, 350, 330, 312, 294, 278, 262, 247, 233, 220, 208, 196, 185, 175, 165, 156, 147, 139,
		131, 124, 117, 110, 0, 826, 779, 736, 694, 655, 619, 584, 551, 520, 491, 463, 437, 413, 390, 368, 347, 328, 309, 292, 276, 260, 245, 232, 219, 206,
		195, 184, 174, 164, 155, 146, 138, 130, 123, 116, 109, 0, 820, 774, 730, 689, 651, 614, 580, 547, 516, 487, 460, 434, 410, 387, 365, 345, 325, 307,
		290, 274, 258, 244, 230, 217, 205, 193, 183, 172, 163, 154, 145, 137, 129, 122, 115, 109, 0, 814, 768, 725, 684, 646, 610, 575, 543, 513, 484, 457,
		431, 407, 384, 363, 342, 323, 305, 288, 272, 256, 242, 228, 216, 204, 192, 181, 171, 161, 152, 144, 136, 128, 121, 114, 108, 0, 907, 856, 808, 762,
		720, 678, 640, 604, 570, 538, 508, 480, 453, 428, 404, 381, 360, 339, 320, 302, 285, 269, 254, 240, 226, 214, 202, 190, 180, 170, 160, 151, 143, 135,
		127, 120, 0, 900, 850, 802, 757, 715, 675, 636, 601, 567, 535, 505, 477, 450, 425, 401, 379, 357, 337, 318, 300, 284, 268, 253, 238, 225, 212, 200,
		189, 179, 169, 159, 150, 142, 134, 126, 119, 0, 894, 844, 796, 752, 709, 670, 632, 597, 563, 532, 502, 474, 447, 422, 398, 376, 355, 335, 316, 298,
		282, 266, 251, 237, 223, 211, 199, 188, 177, 167, 158, 149, 141, 133, 125, 118, 0, 887, 838, 791, 746, 704, 665, 628, 592, 559, 528, 498, 470, 444,
		419, 395, 373, 352, 332, 314, 296, 280, 264, 249, 235, 222, 209, 198, 187, 176, 166, 157, 148, 140, 132, 125, 118, 0, 881, 832, 785, 741, 699, 660,
		623, 588, 555, 524, 494, 467, 441, 416, 392, 370, 350, 330, 312, 294, 278, 262, 247, 233, 220, 208, 196, 185, 175, 165, 156, 147, 139, 131, 123, 117,
		0, 875, 826, 779, 736, 694, 655, 619, 584, 551, 520, 491, 463, 437, 413, 390, 368, 347, 328, 309, 292, 276, 260, 245, 232, 219, 206, 195, 184, 174,
		164, 155, 146, 138, 130, 123, 116, 0, 868, 820, 774, 730, 689, 651, 614, 580, 547, 516, 487, 460, 434, 410, 387, 365, 345, 325, 307, 290, 274, 258,
		244, 230, 217, 205, 193, 183, 172, 163, 154, 145, 137, 129, 122, 115, 0, 862, 814, 768, 725, 684, 646, 610, 575, 543, 513, 484, 457, 431, 407, 384,
		363, 342, 323, 305, 288, 272, 256, 242, 228, 216, 203, 192, 181, 171, 161, 152, 144, 136, 128, 121, 114, 0
	]);
	final VIBRATO:Vector<Int> = Vector.ofArray([
		0, 24, 49, 74, 97, 120, 141, 161, 180, 197, 212, 224, 235, 244, 250, 253, 255, 253, 250, 244, 235, 224, 212, 197, 180, 161, 141, 120, 97, 74, 49, 24
	]);
	final FUNKREP:Vector<Int> = Vector.ofArray([0, 5, 6, 7, 8, 10, 11, 13, 16, 19, 22, 26, 32, 43, 64, 128]);
}
