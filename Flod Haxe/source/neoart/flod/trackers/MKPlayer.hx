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

final class MKPlayer extends AmigaPlayer
{
	var track:Vector<Int>;
	var patterns:Vector<AmigaRow>;
	var samples:Vector<AmigaSample>;
	var length:Int = 0;
	var restart:Int = 0;
	var voices:Vector<MKVoice>;
	var trackPos:Int = 0;
	var patternPos:Int = 0;
	var jumpFlag:Int = 0;
	var vibratoDepth:Int = 0;
	var restartSave:Int = 0;

	public function new(amiga:Amiga = null)
	{
		super(amiga);
		PERIODS.fixed = true;
		VIBRATO.fixed = true;

		track = new Vector<Int>(128, true);
		samples = new Vector<AmigaSample>(32, true);
		voices = new Vector<MKVoice>(4, true);

		voices[0] = new MKVoice(0);
		voices[0].next = voices[1] = new MKVoice(1);
		voices[1].next = voices[2] = new MKVoice(2);
		voices[2].next = voices[3] = new MKVoice(3);
	}

	override function set_force(value:Int):Int
	{
		if (value < SOUNDTRACKER_23)
		{
			value = SOUNDTRACKER_23;
		}
		else if (value > NOISETRACKER_20)
		{
			value = NOISETRACKER_20;
		}

		version = value;

		if (value == NOISETRACKER_20)
		{
			vibratoDepth = 6;
		}
		else
		{
			vibratoDepth = 7;
		}

		if (value == NOISETRACKER_10)
		{
			restartSave = restart;
			restart = 0;
		}
		else
		{
			restart = restartSave;
			restartSave = 0;
		}
		return value;
	}

	override public function process()
	{
		var chan:AmigaChannel, i:Int, len:Int, pattern:Int, period:Int, row:AmigaRow, sample:AmigaSample, slide = 0, value:Int, voice = voices[0];

		if (tick == 0)
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
					chan.volume = voice.volume = sample.volume;
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
						voice.enabled = 1;
						voice.vibratoPos = 0;

						chan.enabled = 0;
						chan.pointer = sample.pointer;
						chan.length = sample.length;
						chan.period = voice.period = row.note;
					}
				}

				switch (voice.effect)
				{
					case 11: // position jump
						trackPos = voice.param - 1;
						jumpFlag ^= 1;

					case 12: // set volume
						chan.volume = voice.param;

						if (version == NOISETRACKER_20)
							voice.volume = voice.param;

					case 13: // pattern break
						jumpFlag ^= 1;

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
				chan = voice.channel;

				if (voice.effect == 0 && voice.param == 0)
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

						period = voice.period & 0x0fff;
						len = 37 - value;

						for (_tmp_ in 0...len)
						{
							i = _tmp_;
							if (period >= PERIODS[i])
							{
								chan.period = PERIODS[i + value];
								break;
							}
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
						}
						chan.period = voice.period;

					case 4 // vibrato
						| 6: // vibrato + volume slide
						if (voice.effect == 6)
						{
							slide = 1;
						}
						else if (voice.param != 0)
						{
							voice.vibratoSpeed = voice.param;
						}

						value = (voice.vibratoPos >> 2) & 31;
						value = ((voice.vibratoSpeed & 0x0f) * VIBRATO[value]) >> vibratoDepth;

						if (voice.vibratoPos > 127)
						{
							chan.period = voice.period - value;
						}
						else
						{
							chan.period = voice.period + value;
						}

						value = (voice.vibratoSpeed >> 2) & 60;
						voice.vibratoPos = (voice.vibratoPos + value) & 255;

					case 10: // volume slide
						slide = 1;
				}

				if (slide != 0)
				{
					value = voice.param >> 4;
					slide = 0;

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
		force = version;

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
		var higher = 0, i:Int, id:String, j:Int, row:AmigaRow, sample:AmigaSample, size = 0, value:Int;
		trace(stream.length);
		if (stream.length < 2106)
			return;

		stream.position = 1080;
		id = stream.readMultiByte(4, CorePlayer.ENCODING);
		trace(id);
		if (id != "M.K." && id != "FLT4")
			return;

		stream.position = 0;
		title = stream.readMultiByte(20, CorePlayer.ENCODING);
		version = SOUNDTRACKER_23;
		stream.position += 22;

		for (i in 1...32)
		{
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
			sample.loop = stream.readUnsignedShort() << 1;
			sample.repeat = stream.readUnsignedShort() << 1;

			stream.position += 22;
			sample.pointer = size;
			size += sample.length;
			samples[i] = sample;

			if (sample.length > 32768)
				version = SOUNDTRACKER_24;
		}

		trace(samples);

		stream.position = 950;
		length = stream.readUnsignedByte();
		value = stream.readUnsignedByte();
		restart = value < length ? value : 0;

		for (i in 0...128)
		{
			value = stream.readUnsignedByte() << 8;
			track[i] = value;
			if (value > higher)
				higher = value;
		}

		stream.position = 1084;
		higher += 256;
		patterns = new Vector<AmigaRow>(higher, true);

		for (i in 0...higher)
		{
			row = new AmigaRow();
			value = stream.readUnsignedInt();

			row.note = (value >> 16) & 0x0fff;
			row.effect = (value >> 8) & 0x0f;
			row.sample = (value >> 24) & 0xf0 | (value >> 12) & 0x0f;
			row.param = value & 0xff;

			patterns[i] = row;

			if (row.sample > 31 || samples[row.sample] == null)
				row.sample = 0;

			if (row.effect == 3 || row.effect == 4)
				version = NOISETRACKER_10;

			if (row.effect == 5 || row.effect == 6)
				version = NOISETRACKER_20;

			if (row.effect > 6 && row.effect < 10)
			{
				version = 0;
				return;
			}
		}

		amiga.store(stream, size);

		for (i in 1...32)
		{
			sample = samples[i];
			if (sample == null)
				continue;

			if (sample.name.indexOf("2.0") > -1)
				version = NOISETRACKER_20;

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
			for (j in sample.pointer...size)
			{
				amiga.memory[j] = 0;
			};
		}

		sample = new AmigaSample();
		sample.pointer = sample.loopPtr = amiga.memory.length;
		sample.length = sample.repeat = 2;
		samples[0] = sample;

		if (version < NOISETRACKER_20 && restart != 127)
			version = NOISETRACKER_11;
	}

	public static inline final SOUNDTRACKER_23:Int = 1;
	public static inline final SOUNDTRACKER_24:Int = 2;
	public static inline final NOISETRACKER_10:Int = 3;
	public static inline final NOISETRACKER_11:Int = 4;
	public static inline final NOISETRACKER_20:Int = 5;

	final PERIODS:Vector<Int> = Vector.ofArray([
		856, 808, 762, 720, 678, 640, 604, 570, 538, 508, 480, 453, 428, 404, 381, 360, 339, 320, 302, 285, 269, 254, 240, 226, 214, 202, 190, 180, 170, 160,
		151, 143, 135, 127, 120, 113, 0
	]);
	final VIBRATO:Vector<Int> = Vector.ofArray([
		0, 24, 49, 74, 97, 120, 141, 161, 180, 197, 212, 224, 235, 244, 250, 253, 255, 253, 250, 244, 235, 224, 212, 197, 180, 161, 141, 120, 97, 74, 49, 24
	]);
}
