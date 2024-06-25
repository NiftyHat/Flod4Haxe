/*
	Flod 4.1
	2012/04/30
	Christian Corti
	Neoart Costa Rica

	Last Update: Flod 4.0 - 2012/03/31

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
	OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
	LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR
	IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

	This work is licensed under the Creative Commons Attribution-Noncommercial-Share Alike 3.0 Unported License.
	To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/3.0/ or send a letter to
	Creative Commons, 171 Second Street, Suite 300, San Francisco, California, 94105, USA.
 */
package neoart.flod.sidmon;

import flash.utils.*;
import neoart.flod.core.*;
import flash.Vector;

final class S2Player extends AmigaPlayer
{
	var tracks:Vector<S2Step>;
	var patterns:Vector<SMRow>;
	var instruments:Vector<S2Instrument>;
	var samples:Vector<S2Sample>;
	var arpeggios:Vector<Int>;
	var vibratos:Vector<Int>;
	var waves:Vector<Int>;
	var length:Int = 0;
	var speedDef:Int = 0;
	var voices:Vector<S2Voice>;
	var trackPos:Int = 0;
	var patternPos:Int = 0;
	var patternLen:Int = 0;
	var arpeggioFx:Vector<Int>;
	var arpeggioPos:Int = 0;

	public function new(amiga:Amiga = null)
	{
		super(amiga);
		PERIODS.fixed = true;

		arpeggioFx = new Vector<Int>(4, true);
		voices = new Vector<S2Voice>(4, true);

		voices[0] = new S2Voice(0);
		voices[0].next = voices[1] = new S2Voice(1);
		voices[1].next = voices[2] = new S2Voice(2);
		voices[2].next = voices[3] = new S2Voice(3);
	}

	override public function process()
	{
		var chan:AmigaChannel, instr:S2Instrument, row:SMRow = null, sample:S2Sample, value:Int, voice = voices[0];
		arpeggioPos = ++arpeggioPos & 3;

		if (++tick >= speed)
		{
			tick = 0;

			while (voice != null)
			{
				chan = voice.channel;
				voice.enabled = voice.note = 0;

				if (patternPos == 0)
				{
					voice.step = tracks[trackPos + voice.index * length];
					voice.pattern = voice.step.pattern;
					voice.speed = 0;
				}
				if (--voice.speed < 0)
				{
					voice.row = row = patterns[voice.pattern++];
					voice.speed = row.speed;

					if (row.note != 0)
					{
						voice.enabled = 1;
						voice.note = row.note + voice.step.transpose;
						chan.enabled = 0;
					}
				}
				voice.pitchBend = 0;

				if (voice.note != 0)
				{
					voice.waveCtr = voice.sustainCtr = 0;
					voice.arpeggioCtr = voice.arpeggioPos = 0;
					voice.vibratoCtr = voice.vibratoPos = 0;
					voice.pitchBendCtr = voice.noteSlideSpeed = 0;
					voice.adsrPos = 4;
					voice.volume = 0;

					if (row.sample != 0)
					{
						voice.instrument = row.sample;
						voice.instr = instruments[voice.instrument + voice.step.soundTranspose];
						voice.sample = samples[waves[voice.instr.wave]];
					}
					voice.original = voice.note + arpeggios[voice.instr.arpeggio];
					chan.period = voice.period = PERIODS[voice.original];

					sample = voice.sample;
					chan.pointer = sample.pointer;
					chan.length = sample.length;
					chan.enabled = voice.enabled;
					chan.pointer = sample.loopPtr;
					chan.length = sample.repeat;
				}
				voice = voice.next;
			}

			if (++patternPos == patternLen)
			{
				patternPos = 0;

				if (++trackPos == length)
				{
					trackPos = 0;
					amiga.complete = 1;
				}
			}
		}
		voice = voices[0];

		while (voice != null)
		{
			if (voice.sample == null)
			{
				voice = voice.next;
				continue;
			}
			chan = voice.channel;
			sample = voice.sample;

			if (sample.negToggle != 0)
			{
				voice = voice.next;
				continue;
			}
			sample.negToggle = 1;

			if (sample.negCtr != 0)
			{
				sample.negCtr = --sample.negCtr & 31;
			}
			else
			{
				sample.negCtr = sample.negSpeed;
				if (sample.negDir == 0)
				{
					voice = voice.next;
					continue;
				}

				value = sample.negStart + sample.negPos;
				amiga.memory[value] = ~amiga.memory[value];
				sample.negPos += sample.negOffset;
				value = sample.negLen - 1;

				if (sample.negPos < 0)
				{
					if (sample.negDir == 2)
					{
						sample.negPos = value;
					}
					else
					{
						sample.negOffset = -sample.negOffset;
						sample.negPos += sample.negOffset;
					}
				}
				else if (value < sample.negPos)
				{
					if (sample.negDir == 1)
					{
						sample.negPos = 0;
					}
					else
					{
						sample.negOffset = -sample.negOffset;
						sample.negPos += sample.negOffset;
					}
				}
			}
			voice = voice.next;
		}
		voice = voices[0];

		while (voice != null)
		{
			if (voice.sample == null)
			{
				voice = voice.next;
				continue;
			}
			voice.sample.negToggle = 0;
			voice = voice.next;
		}
		voice = voices[0];

		while (voice != null)
		{
			chan = voice.channel;
			instr = voice.instr;

			switch (voice.adsrPos)
			{
				case 0:

				case 4: // attack
					voice.volume += instr.attackSpeed;
					if (instr.attackMax <= voice.volume)
					{
						voice.volume = instr.attackMax;
						voice.adsrPos--;
					}

				case 3: // decay
					if (instr.decaySpeed == 0)
					{
						voice.adsrPos--;
					}
					else
					{
						voice.volume -= instr.decaySpeed;
						if (instr.decayMin >= voice.volume)
						{
							voice.volume = instr.decayMin;
							voice.adsrPos--;
						}
					}

				case 2: // sustain
					if (voice.sustainCtr == instr.sustain)
					{
						voice.adsrPos--;
					}
					else
					{
						voice.sustainCtr++;
					}

				case 1: // release
					voice.volume -= instr.releaseSpeed;
					if (instr.releaseMin >= voice.volume)
					{
						voice.volume = instr.releaseMin;
						voice.adsrPos--;
					}
			}
			chan.volume = voice.volume >> 2;

			if (instr.waveLen != 0)
			{
				if (voice.waveCtr == instr.waveDelay)
				{
					voice.waveCtr = instr.waveDelay - instr.waveSpeed;
					if (voice.wavePos == instr.waveLen)
					{
						voice.wavePos = 0;
					}
					else
					{
						voice.wavePos++;
					}

					voice.sample = sample = samples[waves[instr.wave + voice.wavePos]];
					chan.pointer = sample.pointer;
					chan.length = sample.length;
				}
				else
				{
					voice.waveCtr++;
				}
			}

			if (instr.arpeggioLen != 0)
			{
				if (voice.arpeggioCtr == instr.arpeggioDelay)
				{
					voice.arpeggioCtr = instr.arpeggioDelay - instr.arpeggioSpeed;
					if (voice.arpeggioPos == instr.arpeggioLen)
					{
						voice.arpeggioPos = 0;
					}
					else
					{
						voice.arpeggioPos++;
					}

					value = voice.original + arpeggios[instr.arpeggio + voice.arpeggioPos];
					voice.period = PERIODS[value];
				}
				else
				{
					voice.arpeggioCtr++;
				}
			}
			row = voice.row;

			if (tick != 0)
			{
				switch (row.effect)
				{
					case 0:

					case 0x70: // arpeggio
						arpeggioFx[0] = row.param >> 4;
						arpeggioFx[2] = row.param & 15;
						value = voice.original + arpeggioFx[arpeggioPos];
						voice.period = PERIODS[value];

					case 0x71: // pitch up
						voice.pitchBend = -row.param;

					case 0x72: // pitch down
						voice.pitchBend = row.param;

					case 0x73: // volume up
						if (voice.adsrPos != 0)
							break;
						if (voice.instrument != 0)
							voice.volume = instr.attackMax;
						voice.volume += row.param << 2;
						if (voice.volume >= 256)
							voice.volume = -1;

					case 0x74: // volume down
						if (voice.adsrPos != 0)
							break;
						if (voice.instrument != 0)
							voice.volume = instr.attackMax;
						voice.volume -= row.param << 2;
						if (voice.volume < 0)
							voice.volume = 0;
				}
			}

			switch (row.effect)
			{
				case 0:

				case 0x75: // set adsr attack
					instr.attackMax = row.param;
					instr.attackSpeed = row.param;

				case 0x76: // set pattern length
					patternLen = row.param;

				case 0x7c: // set volume
					chan.volume = row.param;
					voice.volume = row.param << 2;
					if (voice.volume >= 255)
						voice.volume = 255;

				case 0x7f: // set speed
					value = row.param & 15;
					if (value != 0)
						speed = value;
			}

			if (instr.vibratoLen != 0)
			{
				if (voice.vibratoCtr == instr.vibratoDelay)
				{
					voice.vibratoCtr = instr.vibratoDelay - instr.vibratoSpeed;
					if (voice.vibratoPos == instr.vibratoLen)
					{
						voice.vibratoPos = 0;
					}
					else
					{
						voice.vibratoPos++;
					}

					voice.period += vibratos[instr.vibrato + voice.vibratoPos];
				}
				else
					voice.vibratoCtr++;
			}

			if (instr.pitchBend != 0)
			{
				if (voice.pitchBendCtr == instr.pitchBendDelay)
				{
					voice.pitchBend += instr.pitchBend;
				}
				else
					voice.pitchBendCtr++;
			}

			if (row.param != 0)
			{
				if (row.effect != 0 && row.effect < 0x70)
				{
					voice.noteSlideTo = PERIODS[row.effect + voice.step.transpose];
					value = row.param;
					if ((voice.noteSlideTo - voice.period) < 0)
						value = -value;
					voice.noteSlideSpeed = value;
				}
			}

			if (voice.noteSlideTo != 0 && voice.noteSlideSpeed != 0)
			{
				voice.period += voice.noteSlideSpeed;

				if ((voice.noteSlideSpeed < 0 && voice.period < voice.noteSlideTo) || (voice.noteSlideSpeed > 0 && voice.period > voice.noteSlideTo))
				{
					voice.noteSlideSpeed = 0;
					voice.period = voice.noteSlideTo;
				}
			}

			voice.period += voice.pitchBend;

			if (voice.period < 95)
			{
				voice.period = 95;
			}
			else if (voice.period > 5760)
			{
				voice.period = 5760;
			}

			chan.period = voice.period;
			voice = voice.next;
		}
	}

	override function initialize()
	{
		var voice = voices[0];
		super.initialize();

		speed = speedDef;
		tick = speedDef;
		trackPos = 0;
		patternPos = 0;
		patternLen = 64;

		while (voice != null)
		{
			voice.initialize();
			voice.channel = amiga.channels[voice.index];
			voice.instr = instruments[0];

			arpeggioFx[voice.index] = 0;
			voice = voice.next;
		}
	}

	override function loader(stream:ByteArray)
	{
		var higher = 0, i = 0, id:String, instr:S2Instrument, j:Int, len:Int, pointers:Vector<Int>, position:Int, pos = 0, row:SMRow, step:S2Step, sample:S2Sample, sampleData:Int, value:Int;
		stream.position = 58;
		id = stream.readMultiByte(28, CorePlayer.ENCODING);
		if (id != "SIDMON II - THE MIDI VERSION")
			return;

		stream.position = 2;
		length = stream.readUnsignedByte();
		speedDef = stream.readUnsignedByte();
		samples = new Vector<S2Sample>(stream.readUnsignedShort() >> 6, true);

		stream.position = 14;
		len = stream.readUnsignedInt();
		tracks = new Vector<S2Step>(len, true);
		stream.position = 90;

		while (i < len)
		{
			step = new S2Step();
			step.pattern = stream.readUnsignedByte();
			if (step.pattern > higher)
				higher = step.pattern;
			tracks[i] = step;
			++i;
		}

		for (_tmp_ in 0...len)
		{
			i = _tmp_;
			step = tracks[i];
			step.transpose = stream.readByte();
		}

		for (_tmp_ in 0...len)
		{
			i = _tmp_;
			step = tracks[i];
			step.soundTranspose = stream.readByte();
		}

		position = stream.position;
		stream.position = 26;
		len = stream.readUnsignedInt() >> 5;
		instruments = new Vector<S2Instrument>(++len, true);
		stream.position = position;

		instruments[0] = new S2Instrument();

		i = 0;
		while (++i < len)
		{
			instr = new S2Instrument();
			instr.wave = stream.readUnsignedByte() << 4;
			instr.waveLen = stream.readUnsignedByte();
			instr.waveSpeed = stream.readUnsignedByte();
			instr.waveDelay = stream.readUnsignedByte();
			instr.arpeggio = stream.readUnsignedByte() << 4;
			instr.arpeggioLen = stream.readUnsignedByte();
			instr.arpeggioSpeed = stream.readUnsignedByte();
			instr.arpeggioDelay = stream.readUnsignedByte();
			instr.vibrato = stream.readUnsignedByte() << 4;
			instr.vibratoLen = stream.readUnsignedByte();
			instr.vibratoSpeed = stream.readUnsignedByte();
			instr.vibratoDelay = stream.readUnsignedByte();
			instr.pitchBend = stream.readByte();
			instr.pitchBendDelay = stream.readUnsignedByte();
			stream.readByte();
			stream.readByte();
			instr.attackMax = stream.readUnsignedByte();
			instr.attackSpeed = stream.readUnsignedByte();
			instr.decayMin = stream.readUnsignedByte();
			instr.decaySpeed = stream.readUnsignedByte();
			instr.sustain = stream.readUnsignedByte();
			instr.releaseMin = stream.readUnsignedByte();
			instr.releaseSpeed = stream.readUnsignedByte();
			instruments[i] = instr;
			stream.position += 9;
		}

		position = stream.position;
		stream.position = 30;
		len = stream.readUnsignedInt();
		waves = new Vector<Int>(len, true);
		stream.position = position;

		for (_tmp_ in 0...len)
		{
			i = _tmp_;
			waves[i] = stream.readUnsignedByte();
		};

		position = stream.position;
		stream.position = 34;
		len = stream.readUnsignedInt();
		arpeggios = new Vector<Int>(len, true);
		stream.position = position;

		for (_tmp_ in 0...len)
		{
			i = _tmp_;
			arpeggios[i] = stream.readByte();
		};

		position = stream.position;
		stream.position = 38;
		len = stream.readUnsignedInt();
		vibratos = new Vector<Int>(len, true);
		stream.position = position;

		for (_tmp_ in 0...len)
		{
			i = _tmp_;
			vibratos[i] = stream.readByte();
		};

		len = samples.length;
		position = 0;

		for (_tmp_ in 0...len)
		{
			i = _tmp_;
			sample = new S2Sample();
			stream.readUnsignedInt();
			sample.length = stream.readUnsignedShort() << 1;
			sample.loop = stream.readUnsignedShort() << 1;
			sample.repeat = stream.readUnsignedShort() << 1;
			sample.negStart = position + (stream.readUnsignedShort() << 1);
			sample.negLen = stream.readUnsignedShort() << 1;
			sample.negSpeed = stream.readUnsignedShort();
			sample.negDir = stream.readUnsignedShort();
			sample.negOffset = stream.readShort();
			sample.negPos = stream.readUnsignedInt();
			sample.negCtr = stream.readUnsignedShort();
			stream.position += 6;
			sample.name = stream.readMultiByte(32, CorePlayer.ENCODING);

			sample.pointer = position;
			sample.loopPtr = position + sample.loop;
			position += sample.length;
			samples[i] = sample;
		}

		sampleData = position;
		len = ++higher;
		pointers = new Vector<Int>(++higher, true);
		for (_tmp_ in 0...len)
		{
			i = _tmp_;
			pointers[i] = stream.readUnsignedShort();
		};

		position = stream.position;
		stream.position = 50;
		len = stream.readUnsignedInt();
		patterns = new Vector<SMRow>();
		stream.position = position;
		j = 1;

		i = 0;
		while (i < len)
		{
			row = new SMRow();
			value = stream.readByte();

			if (value == 0)
			{
				row.effect = stream.readByte();
				row.param = stream.readUnsignedByte();
				i += 2;
			}
			else if (value < 0)
			{
				row.speed = ~value;
			}
			else if (value < 112)
			{
				row.note = value;
				value = stream.readByte();
				i++;

				if (value < 0)
				{
					row.speed = ~value;
				}
				else if (value < 112)
				{
					row.sample = value;
					value = stream.readByte();
					i++;

					if (value < 0)
					{
						row.speed = ~value;
					}
					else
					{
						row.effect = value;
						row.param = stream.readUnsignedByte();
						i++;
					}
				}
				else
				{
					row.effect = value;
					row.param = stream.readUnsignedByte();
					i++;
				}
			}
			else
			{
				row.effect = value;
				row.param = stream.readUnsignedByte();
				i++;
			}

			patterns[pos++] = row;
			if (((position + pointers[j]):UInt) == stream.position)
				pointers[j++] = pos;
			++i;
		}
		pointers[j] = patterns.length;
		patterns.fixed = true;

		if ((stream.position & 1) != 0)
			stream.position++;
		amiga.store(stream, sampleData);
		len = tracks.length;

		for (_tmp_ in 0...len)
		{
			i = _tmp_;
			step = tracks[i];
			step.pattern = pointers[step.pattern];
		}

		length++;
		version = 2;
	}

	final PERIODS:Vector<Int> = Vector.ofArray([
		0, 5760, 5424, 5120, 4832, 4560, 4304, 4064, 3840, 3616, 3424, 3232, 3048, 2880, 2712, 2560, 2416, 2280, 2152, 2032, 1920, 1808, 1712, 1616, 1524,
		1440, 1356, 1280, 1208, 1140, 1076, 1016, 960, 904, 856, 808, 762, 720, 678, 640, 604, 570, 538, 508, 480, 453, 428, 404, 381, 360, 339, 320, 302, 285,
		269, 254, 240, 226, 214, 202, 190, 180, 170, 160, 151, 143, 135, 127, 120, 113, 107, 101, 95
	]);
}
