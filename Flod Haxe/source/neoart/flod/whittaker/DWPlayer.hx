package neoart.flod.whittaker;

/*
	Flod 4.1
	2012/04/30
	Christian Corti
	Neoart Costa Rica

	Last Update: Flod 4.0 - 2012/03/24

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
	OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
	LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR
	IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

	This work is licensed under the Creative Commons Attribution-Noncommercial-Share Alike 3.0 Unported License.
	To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/3.0/ or send a letter to
	Creative Commons, 171 Second Street, Suite 300, San Francisco, California, 94105, USA.
 */
import flash.utils.*;
import neoart.flod.core.*;
import flash.Vector;
import openfl.utils.ByteArray;

final class DWPlayer extends AmigaPlayer
{
	var songs:Vector<DWSong>;
	var samples:Vector<DWSample>;
	var stream:ByteArray;
	var song:DWSong;
	var songvol:Int = 0;
	var master:Int = 0;
	var periods:Int = 0;
	var frqseqs:Int = 0;
	var volseqs:Int = 0;
	var transpose:Int = 0;
	var slower:Int = 0;
	var slowerCounter:Int = 0;
	var delaySpeed:Int = 0;
	var delayCounter:Int = 0;
	var fadeSpeed:Int = 0;
	var fadeCounter:Int = 0;
	var wave:DWSample;
	var waveCenter:Int = 0;
	var waveLo:Int = 0;
	var waveHi:Int = 0;
	var waveDir:Int = 0;
	var waveLen:Int = 0;
	var wavePos:Int = 0;
	var waveRateNeg:Int = 0;
	var waveRatePos:Int = 0;
	var voices:Vector<DWVoice>;
	var active:Int = 0;
	var complete:Int = 0;
	var base:Int = 0;
	var com2:Int = 0;
	var com3:Int = 0;
	var com4:Int = 0;
	var readMix:String;
	var readLen:Int = 0;

	public function new(amiga:Amiga = null)
	{
		super(amiga);
		voices = new Vector<DWVoice>(4, true);

		voices[0] = new DWVoice(0, 1);
		voices[1] = new DWVoice(1, 2);
		voices[2] = new DWVoice(2, 4);
		voices[3] = new DWVoice(3, 8);
	}

	static private function invokeFunction(object:Dynamic, functionName:String):Dynamic
	{
		var fn = Reflect.field(object, functionName);
		return Reflect.callMethod(object, fn, []);
	}

	override public function process()
	{
		var chan:AmigaChannel, loop:Int, pos:Int, sample:DWSample, value:Int, voice = voices[active], volume:Int;

		if (slower != 0)
		{
			if (--slowerCounter == 0)
			{
				slowerCounter = 6;
				return;
			}
		}

		if ((delayCounter += delaySpeed) > 255)
		{
			delayCounter -= 256;
			return;
		}

		if (fadeSpeed != 0)
		{
			if (--fadeCounter == 0)
			{
				fadeCounter = fadeSpeed;
				songvol--;
			}

			if (songvol == 0)
			{
				if (loopSong == 0)
				{
					amiga.complete = 1;
					return;
				}
				else
				{
					initialize();
				}
			}
		}

		if (wave != null)
		{
			if (waveDir != 0)
			{
				amiga.memory[wavePos++] = waveRatePos;
				if (waveLen > 1)
					amiga.memory[wavePos++] = waveRatePos;
				if ((wavePos -= (waveLen << 1)) == waveLo)
					waveDir = 0;
			}
			else
			{
				amiga.memory[wavePos++] = waveRateNeg;
				if (waveLen > 1)
					amiga.memory[wavePos++] = waveRateNeg;
				if (wavePos == waveHi)
					waveDir = 1;
			}
		}

		while (voice != null)
		{
			chan = voice.channel;
			stream.position = voice.patternPos;
			sample = voice.sample;

			if (voice.busy == 0)
			{
				voice.busy = 1;

				if (sample.loopPtr < 0)
				{
					chan.pointer = amiga.loopPtr;
					chan.length = amiga.loopLen;
				}
				else
				{
					chan.pointer = sample.pointer + sample.loopPtr;
					chan.length = sample.length - sample.loopPtr;
				}
			}

			if (--voice.tick == 0)
			{
				voice.flags = 0;
				loop = 1;

				while (loop > 0)
				{
					value = stream.readByte();

					if (value < 0)
					{
						if (value >= -32)
						{
							voice.speed = speed * (value + 33);
						}
						else if (value >= com2)
						{
							value -= com2;
							voice.sample = sample = samples[value];
						}
						else if (value >= com3)
						{
							pos = stream.position;

							stream.position = volseqs + ((value - com3) << 1);
							stream.position = base + stream.readUnsignedShort();
							voice.volseqPtr = stream.position;

							stream.position--;
							voice.volseqSpeed = stream.readUnsignedByte();

							stream.position = pos;
						}
						else if (value >= com4)
						{
							pos = stream.position;

							stream.position = frqseqs + ((value - com4) << 1);
							voice.frqseqPtr = base + stream.readUnsignedShort();
							voice.frqseqPos = voice.frqseqPtr;

							stream.position = pos;
						}
						else
						{
							switch (value)
							{
								case -128:
									stream.position = voice.trackPtr + voice.trackPos;

									value = cast(invokeFunction(stream, readMix), UInt);

									if (value != 0)
									{
										stream.position = base + value;
										voice.trackPos += readLen;
									}
									else
									{
										stream.position = voice.trackPtr;
										stream.position = base + cast(invokeFunction(stream, readMix), UInt);
										voice.trackPos = readLen;

										if (loopSong == 0)
										{
											complete &= ~voice.bitFlag;
											if (complete == 0)
												amiga.complete = 1;
										}
									}

								case -127:
									if (variant > 0)
										voice.portaDelta = 0;
									voice.portaSpeed = stream.readByte();
									voice.portaDelay = stream.readUnsignedByte();
									voice.flags |= 2;

								case -126:
									voice.tick = voice.speed;
									voice.patternPos = stream.position;

									if (variant == 41)
									{
										voice.busy = 1;
										chan.enabled = 0;
									}
									else
									{
										chan.pointer = amiga.loopPtr;
										chan.length = amiga.loopLen;
									}

									loop = 0;

								case -125:
									if (variant > 0)
									{
										voice.tick = voice.speed;
										voice.patternPos = stream.position;
										chan.enabled = 1;
										loop = 0;
									}

								case -124:
									amiga.complete = 1;

								case -123:
									if (variant > 0)
										transpose = stream.readByte();

								case -122:
									voice.vibrato = -1;
									voice.vibratoSpeed = stream.readUnsignedByte();
									voice.vibratoDepth = stream.readUnsignedByte();
									voice.vibratoDelta = 0;

								case -121:
									voice.vibrato = 0;

								case -120:
									if (variant == 21)
									{
										voice.halve = 1;
									}
									else if (variant == 11)
									{
										fadeSpeed = stream.readUnsignedByte();
									}
									else
									{
										voice.transpose = stream.readByte();
									}

								case -119:
									if (variant == 21)
									{
										voice.halve = 0;
									}
									else
									{
										voice.trackPtr = base + stream.readUnsignedShort();
										voice.trackPos = 0;
									}

								case -118:
									if (variant == 31)
									{
										delaySpeed = stream.readUnsignedByte();
									}
									else
									{
										speed = stream.readUnsignedByte();
									}

								case -117:
									fadeSpeed = stream.readUnsignedByte();
									fadeCounter = fadeSpeed;

								case -116:
									value = stream.readUnsignedByte();
									if (variant != 32)
										songvol = value;
							}
						}
					}
					else
					{
						voice.patternPos = stream.position;
						voice.note = (value += sample.finetune);
						voice.tick = voice.speed;
						voice.busy = 0;

						if (variant >= 20)
						{
							value = (value + transpose + voice.transpose) & 0xff;
							stream.position = voice.volseqPtr;
							volume = stream.readUnsignedByte();

							voice.volseqPos = stream.position;
							voice.volseqCounter = voice.volseqSpeed;

							if (voice.halve != 0)
								volume >>= 1;
							volume = (volume * songvol) >> 6;
						}
						else
						{
							volume = sample.volume;
						}

						chan.pointer = sample.pointer;
						chan.length = sample.length;
						chan.volume = volume;

						stream.position = periods + (value << 1);
						value = (stream.readUnsignedShort() * sample.relative) >> 10;
						if (variant < 10)
							voice.portaDelta = value;

						chan.period = value;
						chan.enabled = 1;
						loop = 0;
					}
				}
			}
			else if (voice.tick == 1)
			{
				if (variant < 30)
				{
					chan.enabled = 0;
				}
				else
				{
					value = stream.readUnsignedByte();

					if (value != 131)
					{
						if (variant < 40 || value < 224 || (stream.readUnsignedByte() != 131))
							chan.enabled = 0;
					}
				}
			}
			else if (variant == 0)
			{
				if ((voice.flags & 2) != 0)
				{
					if (voice.portaDelay != 0)
					{
						voice.portaDelay--;
					}
					else
					{
						voice.portaDelta -= voice.portaSpeed;
						chan.period = voice.portaDelta;
					}
				}
			}
			else
			{
				stream.position = voice.frqseqPos;
				value = stream.readByte();

				if (value < 0)
				{
					value &= 0x7f;
					stream.position = voice.frqseqPtr;
				}

				voice.frqseqPos = stream.position;

				value = (value + voice.note + transpose + voice.transpose) & 0xff;
				stream.position = periods + (value << 1);
				value = (stream.readUnsignedShort() * sample.relative) >> 10;

				if ((voice.flags & 2) != 0)
				{
					if (voice.portaDelay != 0)
					{
						voice.portaDelay--;
					}
					else
					{
						voice.portaDelta += voice.portaSpeed;
						value -= voice.portaDelta;
					}
				}

				if (voice.vibrato != 0)
				{
					if (voice.vibrato > 0)
					{
						voice.vibratoDelta -= voice.vibratoSpeed;
						if (voice.vibratoDelta == 0)
							voice.vibrato ^= 0x80000000;
					}
					else
					{
						voice.vibratoDelta += voice.vibratoSpeed;
						if (voice.vibratoDelta == voice.vibratoDepth)
							voice.vibrato ^= 0x80000000;
					}

					if (voice.vibratoDelta == 0)
						voice.vibrato ^= 1;

					if ((voice.vibrato & 1) != 0)
					{
						value += voice.vibratoDelta;
					}
					else
					{
						value -= voice.vibratoDelta;
					}
				}

				chan.period = value;

				if (variant >= 20)
				{
					if (--voice.volseqCounter < 0)
					{
						stream.position = voice.volseqPos;
						volume = stream.readByte();

						if (volume >= 0)
							voice.volseqPos = stream.position;
						voice.volseqCounter = voice.volseqSpeed;
						volume &= 0x7f;

						if (voice.halve != 0)
							volume >>= 1;
						chan.volume = (volume * songvol) >> 6;
					}
				}
			}

			voice = voice.next;
		}
	}

	override function initialize()
	{
		var i:Int, len:Int, voice = voices[active];
		super.initialize();

		song = songs[playSong];
		songvol = master;
		speed = song.speed;

		transpose = 0;
		slowerCounter = 6;
		delaySpeed = song.delay;
		delayCounter = 0;
		fadeSpeed = 0;
		fadeCounter = 0;

		if (wave != null)
		{
			waveDir = 0;
			wavePos = wave.pointer + waveCenter;
			i = wave.pointer;

			len = wavePos;
			while (i < len)
			{
				amiga.memory[i] = waveRateNeg;
				++i;
			};

			len += waveCenter;
			while (i < len)
			{
				amiga.memory[i] = waveRatePos;
				++i;
			};
		}

		while (voice != null)
		{
			voice.initialize();
			voice.channel = amiga.channels[voice.index];
			voice.sample = samples[0];
			complete += voice.bitFlag;

			voice.trackPtr = song.tracks[voice.index];
			voice.trackPos = readLen;
			stream.position = voice.trackPtr;
			voice.patternPos = base + cast(invokeFunction(stream, readMix), UInt);

			if (frqseqs != 0)
			{
				stream.position = frqseqs;
				voice.frqseqPtr = base + stream.readUnsignedShort();
				voice.frqseqPos = voice.frqseqPtr;
			}

			voice = voice.next;
		}
	}

	override function loader(stream:ByteArray)
	{
		var flag = 0, headers = 0, i:Int, index:Int, info = 0, lower:Int, pos:Int, sample:DWSample, size = 10, song:DWSong, total:Int, value = 0;

		master = 64;
		readMix = "readUnsignedShort";
		readLen = 2;
		variant = 0;

		if (stream.readUnsignedShort() == 0x48e7)
		{ // movem.l
			stream.position = 4;
			if (stream.readUnsignedShort() != 0x6100)
				return; // bsr.w

			stream.position += stream.readUnsignedShort();
			variant = 30;
		}
		else
		{
			stream.position = 0;
		}

		while (value != 0x4e75)
		{ // rts
			value = stream.readUnsignedShort();

			switch (value)
			{
				case 0x47fa: // lea x,a3
					base = stream.position + stream.readShort();

				case 0x6100: // bsr.w
					stream.position += 2;
					info = stream.position;

					if (stream.readUnsignedShort() == 0x6100) // bsr.w
						info = stream.position + stream.readUnsignedShort();

				case 0xc0fc: // mulu.w #x,d0
					size = stream.readUnsignedShort();

					if (size == 18)
					{
						readMix = "readUnsignedInt";
						readLen = 4;
					}
					else
					{
						variant = 10;
					}

					if (stream.readUnsignedShort() == 0x41fa)
						headers = stream.position + stream.readUnsignedShort();

					if (stream.readUnsignedShort() == 0x1230)
						flag = 1;

				case 0x1230: // move.b (a0,d0.w),d1
					stream.position -= 6;

					if (stream.readUnsignedShort() == 0x41fa)
					{
						headers = stream.position + stream.readUnsignedShort();
						flag = 1;
					}

					stream.position += 4;

				case 0xbe7c: // cmp.w #x,d7
					channels = stream.readUnsignedShort();
					stream.position += 2;

					if (stream.readUnsignedShort() == 0x377c)
						master = stream.readUnsignedShort();
			}

			if (stream.bytesAvailable < 20)
				return;
		}

		index = stream.position;
		songs = new Vector<DWSong>();
		lower = 0x7fffffff;
		total = 0;
		stream.position = headers;

		while (1 != 0)
		{
			song = new DWSong();
			song.tracks = new Vector<Int>(channels, true);

			if (flag != 0)
			{
				song.speed = stream.readUnsignedByte();
				song.delay = stream.readUnsignedByte();
			}
			else
			{
				song.speed = stream.readUnsignedShort();
			}

			if (song.speed > 255)
				break;

			i = 0;
			while (i < channels)
			{
				value = base + cast(invokeFunction(stream, readMix), Int);
				if (value < lower)
					lower = value;
				song.tracks[i] = value;
				++i;
			}

			songs[total++] = song;
			if ((lower - stream.position) < (size : UInt))
				break;
		}

		if (total == 0)
			return;
		songs.fixed = true;
		lastSong = songs.length - 1;

		stream.position = info;
		if (stream.readUnsignedShort() != 0x4a2b)
			return; // tst.b x(a3)
		headers = size = 0;
		wave = null;

		while (value != 0x4e75)
		{ // rts
			value = stream.readUnsignedShort();

			switch (value)
			{
				case 0x4bfa:
					if (headers != 0)
						break;
					info = stream.position + stream.readShort();
					stream.position++;
					total = stream.readUnsignedByte();

					stream.position -= 10;
					value = stream.readUnsignedShort();
					pos = stream.position;

					if (value == 0x41fa || value == 0x207a)
					{ // lea x,a0 | movea.l x,a0
						headers = stream.position + stream.readUnsignedShort();
					}
					else if (value == 0xd0fc)
					{ // adda.w #x,a0
						headers = (64 + stream.readUnsignedShort());
						stream.position -= 18;
						headers += (stream.position + stream.readUnsignedShort());
					}

					stream.position = pos;

				case 0x84c3: // divu.w d3,d2
					if (size != 0)
						break;
					stream.position += 4;
					value = stream.readUnsignedShort();

					if (value == 0xdafc)
					{ // adda.w #x,a5
						size = stream.readUnsignedShort();
					}
					else if (value == 0xdbfc)
					{ // adda.l #x,a5
						size = stream.readUnsignedInt();
					}

					if (size == 12 && variant < 30)
						variant = 20;

					pos = stream.position;
					samples = new Vector<DWSample>(++total, true);
					stream.position = headers;

					for (_tmp_ in 0...total)
					{
						i = _tmp_;
						sample = new DWSample();
						sample.length = stream.readUnsignedInt();
						sample.relative = Std.int(3579545 / stream.readUnsignedShort());
						sample.pointer = amiga.store(stream, sample.length);

						value = stream.position;
						stream.position = info + (i * size) + 4;
						sample.loopPtr = stream.readInt();

						if (variant == 0)
						{
							stream.position += 6;
							sample.volume = stream.readUnsignedShort();
						}
						else if (variant == 10)
						{
							stream.position += 4;
							sample.volume = stream.readUnsignedShort();
							sample.finetune = stream.readByte();
						}

						stream.position = value;
						samples[i] = sample;
					}

					amiga.loopLen = 64;
					stream.length = headers;
					stream.position = pos;

				case 0x207a: // movea.l x,a0
					value = stream.position + stream.readShort();

					if (stream.readUnsignedShort() != 0x323c)
					{ // move.w #x,d1
						stream.position -= 2;
						break;
					}

					wave = samples[Std.int((value - info) / size)];
					waveCenter = (stream.readUnsignedShort() + 1) << 1;

					stream.position += 2;
					waveRateNeg = stream.readByte();
					stream.position += 12;
					waveRatePos = stream.readByte();

				case 0x046b // subi.w #x,x(a3)
					| 0x066b: // addi.w #x,x(a3)
					total = stream.readUnsignedShort();
					sample = samples[Std.int((stream.readUnsignedShort() - info) / size)];

					if (value == 0x066b)
					{
						sample.relative += total;
					}
					else
					{
						sample.relative -= total;
					}
			}
		}

		if (samples.length == 0)
			return;
		stream.position = index;

		periods = 0;
		frqseqs = 0;
		volseqs = 0;
		slower = 0;

		com2 = 0xb0;
		com3 = 0xa0;
		com4 = 0x90;

		while (stream.bytesAvailable > 16)
		{
			value = stream.readUnsignedShort();

			switch (value)
			{
				case 0x47fa: // lea x,a3
					stream.position += 2;
					if (stream.readUnsignedShort() != 0x4a2b)
						break; // tst.b x(a3)

					pos = stream.position;
					stream.position += 4;
					value = stream.readUnsignedShort();

					if (value == 0x103a)
					{ // move.b x,d0
						stream.position += 4;

						if (stream.readUnsignedShort() == 0xc0fc)
						{ // mulu.w #x,d0
							value = stream.readUnsignedShort();
							total = songs.length;
							for (_tmp_ in 0...total)
							{
								i = _tmp_;
								songs[i].delay *= value;
							};
							stream.position += 6;
						}
					}
					else if (value == 0x532b)
					{ // subq.b #x,x(a3)
						stream.position -= 8;
					}

					value = stream.readUnsignedShort();

					if (value == 0x4a2b)
					{ // tst.b x(a3)
						stream.position = base + stream.readUnsignedShort();
						slower = stream.readByte();
					}

					stream.position = pos;

				case 0x0c6b: // cmpi.w #x,x(a3)
					stream.position -= 6;
					value = stream.readUnsignedShort();

					if (value == 0x546b || value == 0x526b)
					{ // addq.w #2,x(a3) | addq.w #1,x(a3)
						stream.position += 4;
						waveHi = wave.pointer + stream.readUnsignedShort();
					}
					else if (value == 0x556b || value == 0x536b)
					{ // subq.w #2,x(a3) | subq.w #1,x(a3)
						stream.position += 4;
						waveLo = wave.pointer + stream.readUnsignedShort();
					}

					waveLen = (value < 0x546b) ? 1 : 2;

				case 0x7e00 // moveq #0,d7
					| 0x7e01 // moveq #1,d7
					| 0x7e02 // moveq #2,d7
					| 0x7e03: // moveq #3,d7
					active = value & 0xf;
					total = channels - 1;

					if (active != 0)
					{
						voices[0].next = null;
						i = total;
						while (i > 0)
							voices[i].next = voices[--i];
					}
					else
					{
						voices[total].next = null;
						i = 0;
						while (i < total)
							voices[i].next = voices[++i];
					}

				case 0x0c68: // cmpi.w #x,x(a0)
					stream.position += 22;
					if (stream.readUnsignedShort() == 0x0c11)
						variant = 40;

				case 0x322d: // move.w x(a5),d1
					pos = stream.position;
					value = stream.readUnsignedShort();

					if (value == 0x000a || value == 0x000c)
					{ // 10 | 12
						stream.position -= 8;

						if (stream.readUnsignedShort() == 0x45fa) // lea x,a2
							periods = stream.position + stream.readUnsignedShort();
					}

					stream.position = pos + 2;

				case 0x0400 // subi.b #x,d0
					| 0x0440 // subi.w #x,d0
					| 0x0600: // addi.b #x,d0
					value = stream.readUnsignedShort();

					if (value == 0x00c0 || value == 0x0040)
					{ // 192 | 64
						com2 = 0xc0;
						com3 = 0xb0;
						com4 = 0xa0;
					}
					else if (value == com3)
					{
						stream.position += 2;

						if (stream.readUnsignedShort() == 0x45fa)
						{ // lea x,a2
							volseqs = stream.position + stream.readUnsignedShort();
							if (variant < 40)
								variant = 30;
						}
					}
					else if (value == com4)
					{
						stream.position += 2;

						if (stream.readUnsignedShort() == 0x45fa) // lea x,a2
							frqseqs = stream.position + stream.readUnsignedShort();
					}

				case 0x4ef3: // jmp (a3,a2.w)
					stream.position += 2;

				case 0x4ed2: // jmp a2
					lower = stream.position;
					stream.position -= 10;
					stream.position += stream.readUnsignedShort();
					pos = stream.position; // jump table address

					stream.position = pos + 2; // effect -126
					stream.position = base + stream.readUnsignedShort() + 10;
					if (stream.readUnsignedShort() == 0x4a14)
						variant = 41; // tst.b (a4)

					stream.position = pos + 16; // effect -120
					value = base + stream.readUnsignedShort();

					if (value > lower && value < pos)
					{
						stream.position = value;
						value = stream.readUnsignedShort();

						if (value == 0x50e8)
						{ // st x(a0)
							variant = 21;
						}
						else if (value == 0x1759)
						{ // move.b (a1)+,x(a3)
							variant = 11;
						}
					}

					stream.position = pos + 20; // effect -118
					value = base + stream.readUnsignedShort();

					if (value > lower && value < pos)
					{
						stream.position = value + 2;
						if (stream.readUnsignedShort() != 0x4880)
							variant = 31; // ext.w d0
					}

					stream.position = pos + 26; // effect -115
					value = stream.readUnsignedShort();
					if (value > lower && value < pos)
						variant = 32;

					if (frqseqs != 0)
						stream.position = stream.length;
			}
		}

		if (periods == 0)
			return;
		com2 -= 256;
		com3 -= 256;
		com4 -= 256;

		this.stream = stream;
		version = 1;
	}
}
