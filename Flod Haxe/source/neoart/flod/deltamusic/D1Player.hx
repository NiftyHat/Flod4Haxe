/*
	Flod 4.1
	2012/04/30
	Christian Corti
	Neoart Costa Rica

	Last Update: Flod 3.0 - 2012/02/08

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

final class D1Player extends AmigaPlayer
{
	var pointers:Vector<Int>;
	var tracks:Vector<AmigaStep>;
	var patterns:Vector<AmigaRow>;
	var samples:Vector<D1Sample>;
	var voices:Vector<D1Voice>;

	public function new(amiga:Amiga = null)
	{
		super(amiga);
		PERIODS.fixed = true;

		samples = new Vector<D1Sample>(21, true);
		voices = new Vector<D1Voice>(4, true);

		voices[0] = new D1Voice(0);
		voices[0].next = voices[1] = new D1Voice(1);
		voices[1].next = voices[2] = new D1Voice(2);
		voices[2].next = voices[3] = new D1Voice(3);
	}

	override public function process()
	{
		var adsr:Int, chan:AmigaChannel, loop:Int, row:AmigaRow, sample:D1Sample, value:Int, voice = voices[0];

		while (voice != null)
		{
			chan = voice.channel;

			if (--voice.speed == 0)
			{
				voice.speed = speed;

				if (voice.patternPos == 0)
				{
					voice.step = tracks[pointers[voice.index] + voice.trackPos];

					if (voice.step.pattern < 0)
					{
						voice.trackPos = voice.step.transpose;
						voice.step = tracks[pointers[voice.index] + voice.trackPos];
					}
					voice.trackPos++;
				}

				row = patterns[voice.step.pattern + voice.patternPos];
				if (row.effect != 0)
					voice.row = row;

				if (row.note != 0)
				{
					chan.enabled = 0;
					voice.row = row;
					voice.note = row.note + voice.step.transpose;
					voice.arpeggioPos = voice.pitchBend = voice.status = 0;

					sample = voice.sample = samples[row.sample];
					if (sample.synth == 0)
						chan.pointer = sample.pointer;
					chan.length = sample.length;

					voice.tableCtr = voice.tablePos = 0;
					voice.vibratoCtr = sample.vibratoWait;
					voice.vibratoPos = sample.vibratoLen;
					voice.vibratoDir = sample.vibratoLen << 1;
					voice.volume = voice.attackCtr = voice.decayCtr = voice.releaseCtr = 0;
					voice.sustain = sample.sustain;
				}
				if (++voice.patternPos == 16)
					voice.patternPos = 0;
			}
			sample = voice.sample;

			if (sample.synth != 0)
			{
				if (voice.tableCtr == 0)
				{
					voice.tableCtr = sample.tableDelay;

					do
					{
						loop = 1;
						if (voice.tablePos >= 48)
							voice.tablePos = 0;
						value = sample.table[voice.tablePos];
						voice.tablePos++;

						if (value >= 0)
						{
							chan.pointer = sample.pointer + (value << 5);
							loop = 0;
						}
						else if (value != -1)
						{
							sample.tableDelay = value & 127;
						}
						else
						{
							voice.tablePos = sample.table[voice.tablePos];
						}
					}
					while (loop != 0);
				}
				else
					voice.tableCtr--;
			}

			if (sample.portamento != 0)
			{
				value = PERIODS[voice.note] + voice.pitchBend;

				if (voice.period != 0)
				{
					if (voice.period < value)
					{
						voice.period += sample.portamento;
						if (voice.period > value)
							voice.period = value;
					}
					else
					{
						voice.period -= sample.portamento;
						if (voice.period < value)
							voice.period = value;
					}
				}
				else
					voice.period = value;
			}

			if (voice.vibratoCtr == 0)
			{
				voice.vibratoPeriod = voice.vibratoPos * sample.vibratoStep;

				if ((voice.status & 1) == 0)
				{
					voice.vibratoPos++;
					if (voice.vibratoPos == voice.vibratoDir)
						voice.status ^= 1;
				}
				else
				{
					voice.vibratoPos--;
					if (voice.vibratoPos == 0)
						voice.status ^= 1;
				}
			}
			else
			{
				voice.vibratoCtr--;
			}

			if (sample.pitchBend < 0)
			{
				voice.pitchBend += sample.pitchBend;
			}
			else
			{
				voice.pitchBend -= sample.pitchBend;
			}

			if (voice.row != null)
			{
				row = voice.row;

				switch (row.effect)
				{
					case 0:

					case 1:
						value = row.param & 15;
						if (value != 0)
							speed = value;

					case 2:
						voice.pitchBend -= row.param;

					case 3:
						voice.pitchBend += row.param;

					case 4:
						amiga.filter.active = row.param;

					case 5:
						sample.vibratoWait = row.param;

					case 6:
						sample.vibratoStep = row.param;

					case 7:
						sample.vibratoLen = row.param;

					case 8:
						sample.pitchBend = row.param;

					case 9:
						sample.portamento = row.param;

					case 10:
						value = row.param;
						if (value > 64)
							value = 64;
						sample.volume = 64;

					case 11:
						sample.arpeggio[0] = row.param;

					case 12:
						sample.arpeggio[1] = row.param;

					case 13:
						sample.arpeggio[2] = row.param;

					case 14:
						sample.arpeggio[3] = row.param;

					case 15:
						sample.arpeggio[4] = row.param;

					case 16:
						sample.arpeggio[5] = row.param;

					case 17:
						sample.arpeggio[6] = row.param;

					case 18:
						sample.arpeggio[7] = row.param;

					case 19:
						sample.arpeggio[0] = sample.arpeggio[4] = row.param;

					case 20:
						sample.arpeggio[1] = sample.arpeggio[5] = row.param;

					case 21:
						sample.arpeggio[2] = sample.arpeggio[6] = row.param;

					case 22:
						sample.arpeggio[3] = sample.arpeggio[7] = row.param;

					case 23:
						value = row.param;
						if (value > 64)
							value = 64;
						sample.attackStep = value;

					case 24:
						sample.attackDelay = row.param;

					case 25:
						value = row.param;
						if (value > 64)
							value = 64;
						sample.decayStep = value;

					case 26:
						sample.decayDelay = row.param;

					case 27:
						sample.sustain = row.param & (sample.sustain & 255);

					case 28:
						sample.sustain = (sample.sustain & 65280) + row.param;

					case 29:
						value = row.param;
						if (value > 64)
							value = 64;
						sample.releaseStep = value;

					case 30:
						sample.releaseDelay = row.param;
				}
			}

			if (sample.portamento != 0)
			{
				value = voice.period;
			}
			else
			{
				value = PERIODS[voice.note + sample.arpeggio[voice.arpeggioPos]];
				voice.arpeggioPos = ++voice.arpeggioPos & 7;
				value -= (sample.vibratoLen * sample.vibratoStep);
				value += voice.pitchBend;
				voice.period = 0;
			}

			chan.period = value + voice.vibratoPeriod;
			adsr = voice.status & 14;
			value = voice.volume;

			if (adsr == 0)
			{
				if (voice.attackCtr == 0)
				{
					voice.attackCtr = sample.attackDelay;
					value += sample.attackStep;

					if (value >= 64)
					{
						adsr |= 2;
						voice.status |= 2;
						value = 64;
					}
				}
				else
				{
					voice.attackCtr--;
				}
			}

			if (adsr == 2)
			{
				if (voice.decayCtr == 0)
				{
					voice.decayCtr = sample.decayDelay;
					value -= sample.decayStep;

					if (value <= sample.volume)
					{
						adsr |= 6;
						voice.status |= 6;
						value = sample.volume;
					}
				}
				else
				{
					voice.decayCtr--;
				}
			}

			if (adsr == 6)
			{
				if (voice.sustain == 0)
				{
					adsr |= 14;
					voice.status |= 14;
				}
				else
				{
					voice.sustain--;
				}
			}

			if (adsr == 14)
			{
				if (voice.releaseCtr == 0)
				{
					voice.releaseCtr = sample.releaseDelay;
					value -= sample.releaseStep;

					if (value < 0)
					{
						voice.status &= 9;
						value = 0;
					}
				}
				else
				{
					voice.releaseCtr--;
				}
			}

			chan.volume = voice.volume = value;
			chan.enabled = 1;

			if (sample.synth == 0)
			{
				if (sample.loop != 0)
				{
					chan.pointer = sample.loopPtr;
					chan.length = sample.repeat;
				}
				else
				{
					chan.pointer = amiga.loopPtr;
					chan.length = 2;
				}
			}
			voice = voice.next;
		}
	}

	override function initialize()
	{
		var voice = voices[0];
		super.initialize();

		speed = 6;

		while (voice != null)
		{
			voice.initialize();
			voice.channel = amiga.channels[voice.index];
			voice.sample = samples[20];
			voice = voice.next;
		}
	}

	override function loader(stream:ByteArray)
	{
		var data:Vector<Int>;
		var i:Int;
		var id:String;
		var index:Int;
		var j = 0;
		var len:Int;
		var position:Int;
		var row:AmigaRow;
		var sample:D1Sample;
		var step:AmigaStep;
		var value:Int;
		id = stream.readMultiByte(4, CorePlayer.ENCODING);
		if (id != "ALL ")
			return;

		position = 104;
		data = new Vector<Int>(25, true);
		for (_tmp_ in 0...25)
		{
			i = _tmp_;
			data[i] = stream.readUnsignedInt();
		};

		pointers = new Vector<Int>(4, true);
		for (_tmp_ in 1...4)
		{
			i = _tmp_;
			pointers[i] = pointers[j] + (data[j++] >> 1) - 1;
		};

		len = pointers[3] + (data[3] >> 1) - 1;
		tracks = new Vector<AmigaStep>(len, true);
		index = position + data[1] - 2;
		stream.position = position;
		j = 1;

		for (_tmp_ in 0...len)
		{
			i = _tmp_;
			step = new AmigaStep();
			value = stream.readUnsignedShort();

			if (value == 0xffff || stream.position == (index : UInt))
			{
				step.pattern = -1;
				step.transpose = stream.readUnsignedShort();
				index += data[j++];
			}
			else
			{
				stream.position--;
				step.pattern = ((value >> 2) & 0x3fc0) >> 2;
				step.transpose = stream.readByte();
			}
			tracks[i] = step;
		}

		len = data[4] >> 2;
		patterns = new Vector<AmigaRow>(len, true);

		for (_tmp_ in 0...len)
		{
			i = _tmp_;
			row = new AmigaRow();
			row.sample = stream.readUnsignedByte();
			row.note = stream.readUnsignedByte();
			row.effect = stream.readUnsignedByte() & 31;
			row.param = stream.readUnsignedByte();
			patterns[i] = row;
		}

		index = 5;

		for (_tmp_ in 0...20)
		{
			i = _tmp_;
			samples[i] = null;

			if (data[index] != 0)
			{
				sample = new D1Sample();
				sample.attackStep = stream.readUnsignedByte();
				sample.attackDelay = stream.readUnsignedByte();
				sample.decayStep = stream.readUnsignedByte();
				sample.decayDelay = stream.readUnsignedByte();
				sample.sustain = stream.readUnsignedShort();
				sample.releaseStep = stream.readUnsignedByte();
				sample.releaseDelay = stream.readUnsignedByte();
				sample.volume = stream.readUnsignedByte();
				sample.vibratoWait = stream.readUnsignedByte();
				sample.vibratoStep = stream.readUnsignedByte();
				sample.vibratoLen = stream.readUnsignedByte();
				sample.pitchBend = stream.readByte();
				sample.portamento = stream.readUnsignedByte();
				sample.synth = stream.readUnsignedByte();
				sample.tableDelay = stream.readUnsignedByte();

				for (_tmp_ in 0...8)
				{
					j = _tmp_;
					sample.arpeggio[j] = stream.readByte();
				};

				sample.length = stream.readUnsignedShort();
				sample.loop = stream.readUnsignedShort();
				sample.repeat = stream.readUnsignedShort() << 1;
				sample.synth = sample.synth != 0 ? 0 : 1;

				if (sample.synth != 0)
				{
					for (_tmp_ in 0...48)
					{
						j = _tmp_;
						sample.table[j] = stream.readByte();
					}

					len = data[index] - 78;
				}
				else
				{
					len = sample.length;
				}

				sample.pointer = amiga.store(stream, len);
				sample.loopPtr = sample.pointer + sample.loop;
				samples[i] = sample;
			}
			index++;
		}

		sample = new D1Sample();
		sample.pointer = sample.loopPtr = amiga.memory.length;
		sample.length = sample.repeat = 2;
		samples[20] = sample;
		version = 1;
	}

	var PERIODS:Vector<Int> = Vector.ofArray([
		0, 6848, 6464, 6096, 5760, 5424, 5120, 4832, 4560, 4304, 4064, 3840, 3616, 3424, 3232, 3048, 2880, 2712, 2560, 2416, 2280, 2152, 2032, 1920, 1808,
		1712, 1616, 1524, 1440, 1356, 1280, 1208, 1140, 1076, 960, 904, 856, 808, 762, 720, 678, 640, 604, 570, 538, 508, 480, 452, 428, 404, 381, 360, 339,
		320, 302, 285, 269, 254, 240, 226, 214, 202, 190, 180, 170, 160, 151, 143, 135, 127, 120, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113, 113,
		113
	]);
}
