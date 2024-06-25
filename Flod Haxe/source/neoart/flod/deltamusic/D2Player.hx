/*
	Flod 4.1
	2012/04/30
	Christian Corti
	Neoart Costa Rica

	Last Update: Flod 4.0 - 2012/03/30

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
	OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
	LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR
	IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

	This work is licensed under the Creative Commons Attribution-Noncommercial-Share Alike 3.0 Unported License.
	To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/3.0/ or send a letter to
	Creative Commons, 171 Second Street, Suite 300, San Francisco, California, 94105, USA.
 */
package neoart.flod.deltamusic;

import flash.utils.*;
import neoart.flod.core.*;
import flash.Vector;

final class D2Player extends AmigaPlayer
{
	var tracks:Vector<AmigaStep>;
	var patterns:Vector<AmigaRow>;
	var samples:Vector<D2Sample>;
	var data:Vector<Int>;
	var arpeggios:Vector<Int>;
	var voices:Vector<D2Voice>;
	var noise:UInt = 0;

	public function new(amiga:Amiga = null)
	{
		super(amiga);
		PERIODS.fixed = true;

		arpeggios = new Vector<Int>(1024, true);
		voices = new Vector<D2Voice>(4, true);

		voices[0] = new D2Voice(0);
		voices[0].next = voices[1] = new D2Voice(1);
		voices[1].next = voices[2] = new D2Voice(2);
		voices[2].next = voices[3] = new D2Voice(3);
	}

	override public function process()
	{
		var chan:AmigaChannel, i = 0, level:Int, row:AmigaRow, sample:D2Sample, value:Int, voice = voices[0];

		while (i < 64)
		{
			this.noise = (this.noise << 7) | (this.noise >>> 25);
			this.noise += 0x6eca756d;
			this.noise ^= 0x9e59a92b;

			value = (this.noise >>> 24) & 255;
			if (value > 127)
				value |= -256;
			amiga.memory[i++] = value;

			value = (this.noise >>> 16) & 255;
			if (value > 127)
				value |= -256;
			amiga.memory[i++] = value;

			value = (this.noise >>> 8) & 255;
			if (value > 127)
				value |= -256;
			amiga.memory[i++] = value;

			value = this.noise & 255;
			if (value > 127)
				value |= -256;
			amiga.memory[i++] = value;
		}

		if (--this.tick < 0)
			this.tick = this.speed;

		while (voice != null)
		{
			if (voice.trackLen < 1)
			{
				voice = voice.next;
				continue;
			}

			chan = voice.channel;
			sample = voice.sample;

			if (sample.synth != 0)
			{
				chan.pointer = sample.loopPtr;
				chan.length = sample.repeat;
			}

			if (this.tick == 0)
			{
				if (voice.patternPos == 0)
				{
					voice.step = tracks[voice.trackPtr + voice.trackPos];

					if (++voice.trackPos == voice.trackLen)
						voice.trackPos = voice.restart;
				}
				row = voice.row = patterns[voice.step.pattern + voice.patternPos];

				if (row.note != 0)
				{
					chan.enabled = 0;
					voice.note = row.note;
					voice.period = PERIODS[row.note + voice.step.transpose];

					sample = voice.sample = samples[row.sample];

					if (sample.synth < 0)
					{
						chan.pointer = sample.pointer;
						chan.length = sample.length;
					}

					voice.arpeggioPos = 0;
					voice.tableCtr = 0;
					voice.tablePos = 0;
					voice.vibratoCtr = sample.vibratos[1];
					voice.vibratoPos = 0;
					voice.vibratoDir = 0;
					voice.vibratoPeriod = 0;
					voice.vibratoSustain = sample.vibratos[2];
					voice.volume = 0;
					voice.volumePos = 0;
					voice.volumeSustain = 0;
				}

				switch (row.effect)
				{
					case -1:

					case 0:
						speed = row.param & 15;

					case 1:
						amiga.filter.active = row.param;

					case 2:
						voice.pitchBend = ~(row.param & 255) + 1;

					case 3:
						voice.pitchBend = row.param & 255;

					case 4:
						voice.portamento = row.param;

					case 5:
						voice.volumeMax = row.param & 63;

					case 6:
						amiga.volume = row.param;

					case 7:
						voice.arpeggioPtr = (row.param & 63) << 4;
				}
				voice.patternPos = ++voice.patternPos & 15;
			}
			sample = voice.sample;

			if (sample.synth >= 0)
			{
				if (voice.tableCtr != 0)
				{
					voice.tableCtr--;
				}
				else
				{
					voice.tableCtr = sample.index;
					value = sample.table[voice.tablePos];

					if (value == 0xff)
					{
						value = sample.table[++voice.tablePos];
						if (value != 0xff)
						{
							voice.tablePos = value;
							value = sample.table[voice.tablePos];
						}
					}

					if (value != 0xff)
					{
						chan.pointer = value << 8;
						chan.length = sample.length;
						if (++voice.tablePos > 47)
							voice.tablePos = 0;
					}
				}
			}
			value = sample.vibratos[voice.vibratoPos];

			if (voice.vibratoDir != 0)
			{
				voice.vibratoPeriod -= value;
			}
			else
			{
				voice.vibratoPeriod += value;
			}

			if (--voice.vibratoCtr == 0)
			{
				voice.vibratoCtr = sample.vibratos[voice.vibratoPos + 1];
				voice.vibratoDir = ~voice.vibratoDir;
			}

			if (voice.vibratoSustain != 0)
			{
				voice.vibratoSustain--;
			}
			else
			{
				voice.vibratoPos += 3;
				if (voice.vibratoPos == 15)
					voice.vibratoPos = 12;
				voice.vibratoSustain = sample.vibratos[voice.vibratoPos + 2];
			}

			if (voice.volumeSustain != 0)
			{
				voice.volumeSustain--;
			}
			else
			{
				value = sample.volumes[voice.volumePos];
				level = sample.volumes[voice.volumePos + 1];

				if (level < voice.volume)
				{
					voice.volume -= value;
					if (voice.volume < level)
					{
						voice.volume = level;
						voice.volumePos += 3;
						voice.volumeSustain = sample.volumes[voice.volumePos - 1];
					}
				}
				else
				{
					voice.volume += value;
					if (voice.volume > level)
					{
						voice.volume = level;
						voice.volumePos += 3;
						if (voice.volumePos == 15)
							voice.volumePos = 12;
						voice.volumeSustain = sample.volumes[voice.volumePos - 1];
					}
				}
			}

			if (voice.portamento != 0)
			{
				if (voice.period < voice.finalPeriod)
				{
					voice.finalPeriod -= voice.portamento;
					if (voice.finalPeriod < voice.period)
						voice.finalPeriod = voice.period;
				}
				else
				{
					voice.finalPeriod += voice.portamento;
					if (voice.finalPeriod > voice.period)
						voice.finalPeriod = voice.period;
				}
			}
			value = arpeggios[voice.arpeggioPtr + voice.arpeggioPos];

			if (value == -128)
			{
				voice.arpeggioPos = 0;
				value = arpeggios[voice.arpeggioPtr];
			}
			voice.arpeggioPos = ++voice.arpeggioPos & 15;

			if (voice.portamento == 0)
			{
				value = voice.note + voice.step.transpose + value;
				if (value < 0)
					value = 0;
				voice.finalPeriod = PERIODS[value];
			}

			voice.vibratoPeriod -= (sample.pitchBend - voice.pitchBend);
			chan.period = voice.finalPeriod + voice.vibratoPeriod;

			value = (voice.volume >> 2) & 63;
			if (value > voice.volumeMax)
				value = voice.volumeMax;
			chan.volume = value;
			chan.enabled = 1;

			voice = voice.next;
		}
	}

	override function initialize()
	{
		var voice = voices[0];
		super.initialize();

		speed = 5;
		tick = 1;
		noise = 0;

		while (voice != null)
		{
			voice.initialize();
			voice.channel = amiga.channels[voice.index];
			voice.sample = samples[samples.length - 1];

			voice.trackPtr = data[voice.index];
			voice.restart = data[voice.index + 4];
			voice.trackLen = data[voice.index + 8];

			voice = voice.next;
		}
	}

	override function loader(stream:ByteArray)
	{
		var i:Int, id:String, j:Int, len = 0, offsets:Vector<Int>, position:Int, row:AmigaRow, sample:D2Sample, step:AmigaStep, value:Int;
		stream.position = 3014;
		id = stream.readMultiByte(4, CorePlayer.ENCODING);
		if (id != ".FNL")
			return;

		stream.position = 4042;
		data = new Vector<Int>(12, true);

		for (_tmp_ in 0...4)
		{
			i = _tmp_;
			data[i + 4] = stream.readUnsignedShort() >> 1;
			value = stream.readUnsignedShort() >> 1;
			data[i + 8] = value;
			len += value;
		}

		value = len;

		// reverse loop based on: for (i = 3; i > 0; --i)
		var total = 3;
		var i = total;
		while (i >= 0)
		{
			data[i] = (value -= data[i + 8]);
			i--;
		}
		tracks = new Vector<AmigaStep>(len, true);

		for (_tmp_ in 0...len)
		{
			i = _tmp_;
			step = new AmigaStep();
			step.pattern = stream.readUnsignedByte() << 4;
			step.transpose = stream.readByte();
			tracks[i] = step;
		}

		len = stream.readUnsignedInt() >> 2;
		patterns = new Vector<AmigaRow>(len, true);

		for (_tmp_ in 0...len)
		{
			i = _tmp_;
			row = new AmigaRow();
			row.note = stream.readUnsignedByte();
			row.sample = stream.readUnsignedByte();
			row.effect = stream.readUnsignedByte() - 1;
			row.param = stream.readUnsignedByte();
			patterns[i] = row;
		}

		stream.position += 254;
		value = stream.readUnsignedShort();
		position = stream.position;
		stream.position -= 256;

		len = 1;
		offsets = new Vector<Int>(128, true);

		for (_tmp_ in 0...128)
		{
			i = _tmp_;
			j = stream.readUnsignedShort();
			if (j != value)
				offsets[len++] = j;
		}

		samples = new Vector<D2Sample>(len);

		for (_tmp_ in 0...len)
		{
			i = _tmp_;
			stream.position = position + offsets[i];
			sample = new D2Sample();
			sample.length = stream.readUnsignedShort() << 1;
			sample.loop = stream.readUnsignedShort();
			sample.repeat = stream.readUnsignedShort() << 1;

			for (_tmp_ in 0...15)
			{
				j = _tmp_;
				sample.volumes[j] = stream.readUnsignedByte();
			};
			for (_tmp_ in 0...15)
			{
				j = _tmp_;
				sample.vibratos[j] = stream.readUnsignedByte();
			};

			sample.pitchBend = stream.readUnsignedShort();
			sample.synth = stream.readByte();
			sample.index = stream.readUnsignedByte();

			for (_tmp_ in 0...48)
			{
				j = _tmp_;
				sample.table[j] = stream.readUnsignedByte();
			};

			samples[i] = sample;
		}

		len = stream.readUnsignedInt();
		amiga.store(stream, len);

		stream.position += 64;
		for (_tmp_ in 0...8)
		{
			i = _tmp_;
			offsets[i] = stream.readUnsignedInt();
		};

		len = samples.length;
		position = stream.position;

		for (_tmp_ in 0...len)
		{
			i = _tmp_;
			sample = samples[i];
			if (sample.synth >= 0)
				continue;
			stream.position = position + offsets[sample.index];
			sample.pointer = amiga.store(stream, sample.length);
			sample.loopPtr = sample.pointer + sample.loop;
		}

		stream.position = 3018;
		for (_tmp_ in 0...1024)
		{
			i = _tmp_;
			arpeggios[i] = stream.readByte();
		};

		sample = new D2Sample();
		sample.pointer = sample.loopPtr = amiga.memory.length;
		sample.length = sample.repeat = 2;

		samples[len] = sample;
		samples.fixed = true;

		len = patterns.length;
		j = samples.length - 1;

		for (_tmp_ in 0...len)
		{
			i = _tmp_;
			row = patterns[i];
			if (row.sample > j)
				row.sample = 0;
		}

		version = 2;
	}

	final PERIODS:Vector<Int> = Vector.ofArray([
		0, 6848, 6464, 6096, 5760, 5424, 5120, 4832, 4560, 4304, 4064, 3840, 3616, 3424, 3232, 3048, 2880, 2712, 2560, 2416, 2280, 2152, 2032, 1920, 1808,
		1712, 1616, 1524, 1440, 1356, 1280, 1208, 1140, 1076, 1016, 960, 904, 856, 808, 762, 720, 678, 640, 604, 570, 538, 508, 480, 452, 428, 404, 381, 360,
		339, 320, 302, 285, 269, 254, 240, 226, 214, 202, 190, 180, 170, 160, 151, 143, 135, 127, 120, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113,
		113, 113
	]);
}
