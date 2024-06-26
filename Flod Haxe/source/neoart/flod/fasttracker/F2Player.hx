/*
	Flod 4.1
	2012/04/30
	Christian Corti
	Neoart Costa Rica

	Last Update: Flod 4.0 - 2012/03/05

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
	OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
	LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR
	IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

	This work is licensed under the Creative Commons Attribution-Noncommercial-Share Alike 3.0 Unported License.
	To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/3.0/ or send a letter to
	Creative Commons, 171 Second Street, Suite 300, San Francisco, California, 94105, USA.
 */
package neoart.flod.fasttracker;

import flash.utils.*;
import neoart.flod.core.*;
import flash.Vector;

final class F2Player extends SBPlayer
{
	@:allow(neoart.flod.fasttracker) var patterns:Vector<F2Pattern>;
	@:allow(neoart.flod.fasttracker) var instruments:Vector<F2Instrument>;
	@:allow(neoart.flod.fasttracker) var linear:Int = 0;
	var voices:Vector<F2Voice>;
	var order:Int = 0;
	var position:Int = 0;
	var nextOrder:Int = 0;
	var nextPosition:Int = 0;
	var pattern:F2Pattern;
	var patternDelay:Int = 0;
	var patternOffset:Int = 0;
	var complete:Int = 0;

	public function new(mixer:Soundblaster = null)
	{
		super(mixer);
	}

	override public function process()
	{
		var com:Int, curr:F2Point, instr:F2Instrument, i = 0, jumpFlag = 0, next:F2Point, paramx:Int, paramy:Int, porta:Int, row:F2Row, sample:F2Sample, slide = 0, value:Int, voice = voices[0];

		if (tick == 0)
		{
			if (nextOrder >= 0)
				order = nextOrder;
			if (nextPosition >= 0)
				position = nextPosition;

			nextOrder = nextPosition = -1;
			pattern = patterns[track[order]];

			while (voice != null)
			{
				row = pattern.rows[position + voice.index];
				com = row.volume >> 4;
				porta = row.effect == FX_TONE_PORTAMENTO || row.effect == FX_TONE_PORTA_VOLUME_SLIDE || com == VX_TONE_PORTAMENTO ? 1 : 0;
				paramx = row.param >> 4;
				voice.keyoff = 0;

				if (voice.arpDelta != 0)
				{
					voice.arpDelta = 0;
					voice.flags |= UPDATE_PERIOD;
				}

				if (row.instrument != 0)
				{
					voice.instrument = row.instrument < instruments.length ? instruments[row.instrument] : null;
					voice.volEnvelope.reset();
					voice.panEnvelope.reset();
					voice.flags |= (UPDATE_VOLUME | UPDATE_PANNING | SHORT_RAMP);
				}
				else if (row.note == KEYOFF_NOTE || (row.effect == FX_KEYOFF && row.param == 0))
				{
					voice.fadeEnabled = 1;
					voice.keyoff = 1;
				}

				if (row.note != 0 && row.note != KEYOFF_NOTE)
				{
					if (voice.instrument != null)
					{
						instr = voice.instrument;
						value = row.note - 1;
						sample = instr.samples[instr.noteSamples[value]];
						value += sample.relative;

						if (value >= LOWER_NOTE && value <= HIGHER_NOTE)
						{
							if (porta == 0)
							{
								voice.note = value;
								voice.sample = sample;

								if (row.instrument != 0)
								{
									voice.volEnabled = instr.volEnabled;
									voice.panEnabled = instr.panEnabled;
									voice.flags |= UPDATE_ALL;
								}
								else
								{
									voice.flags |= (UPDATE_PERIOD | UPDATE_TRIGGER);
								}
							}

							if (row.instrument != 0)
							{
								voice.reset();
								voice.fadeDelta = instr.fadeout;
							}
							else
							{
								voice.finetune = (sample.finetune >> 3) << 2;
							}

							if (row.effect == FX_EXTENDED_EFFECTS && paramx == EX_SET_FINETUNE)
								voice.finetune = ((row.param & 15) - 8) << 3;

							if (linear != 0)
							{
								value = ((120 - value) << 6) - voice.finetune;
							}
							else
							{
								value = amiga(value, voice.finetune);
							}

							if (porta == 0)
							{
								voice.period = value;
								voice.glissPeriod = 0;
							}
							else
							{
								voice.portaPeriod = value;
							}
						}
					}
					else
					{
						voice.volume = 0;
						voice.flags = (UPDATE_VOLUME | SHORT_RAMP);
					}
				}
				else if (voice.vibratoReset != 0)
				{
					if (row.effect != FX_VIBRATO && row.effect != FX_VIBRATO_VOLUME_SLIDE)
					{
						voice.vibDelta = 0;
						voice.vibratoReset = 0;
						voice.flags |= UPDATE_PERIOD;
					}
				}

				if (row.volume != 0)
				{
					if (row.volume >= 16 && row.volume <= 80)
					{
						voice.volume = row.volume - 16;
						voice.flags |= (UPDATE_VOLUME | SHORT_RAMP);
					}
					else
					{
						paramy = row.volume & 15;

						switch (com)
						{
							case VX_FINE_VOLUME_SLIDE_DOWN:
								voice.volume -= paramy;
								if (voice.volume < 0)
									voice.volume = 0;
								voice.flags |= UPDATE_VOLUME;

							case VX_FINE_VOLUME_SLIDE_UP:
								voice.volume += paramy;
								if (voice.volume > 64)
									voice.volume = 64;
								voice.flags |= UPDATE_VOLUME;

							case VX_SET_VIBRATO_SPEED:
								if (paramy != 0)
									voice.vibratoSpeed = paramy;

							case VX_VIBRATO:
								if (paramy != 0)
									voice.vibratoDepth = paramy << 2;

							case VX_SET_PANNING:
								voice.panning = paramy << 4;
								voice.flags |= UPDATE_PANNING;

							case VX_TONE_PORTAMENTO:
								if (paramy != 0)
									voice.portaSpeed = paramy << 4;
						}
					}
				}

				if (row.effect != 0)
				{
					paramy = row.param & 15;

					switch (row.effect)
					{
						case FX_PORTAMENTO_UP:
							if (row.param != 0)
								voice.portaU = row.param << 2;

						case FX_PORTAMENTO_DOWN:
							if (row.param != 0)
								voice.portaD = row.param << 2;

						case FX_TONE_PORTAMENTO:
							if (row.param != 0 && com != VX_TONE_PORTAMENTO)
								voice.portaSpeed = row.param;

						case FX_VIBRATO:
							voice.vibratoReset = 1;

						case FX_TONE_PORTA_VOLUME_SLIDE:
							if (row.param != 0)
								voice.volSlide = row.param;

						case FX_VIBRATO_VOLUME_SLIDE:
							if (row.param != 0)
								voice.volSlide = row.param;
							voice.vibratoReset = 1;

						case FX_TREMOLO:
							if (paramx != 0)
								voice.tremoloSpeed = paramx;
							if (paramy != 0)
								voice.tremoloDepth = paramy;

						case FX_SET_PANNING:
							voice.panning = row.param;
							voice.flags |= UPDATE_PANNING;

						case FX_SAMPLE_OFFSET:
							if (row.param != 0)
								voice.sampleOffset = row.param << 8;

							if (voice.sampleOffset >= voice.sample.length)
							{
								voice.volume = 0;
								voice.sampleOffset = 0;
								voice.flags &= ~(UPDATE_PERIOD | UPDATE_TRIGGER);
								voice.flags |= (UPDATE_VOLUME | SHORT_RAMP);
							}

						case FX_VOLUME_SLIDE:
							if (row.param != 0)
								voice.volSlide = row.param;

						case FX_POSITION_JUMP:
							nextOrder = row.param;

							if (nextOrder >= length)
							{
								complete = 1;
							}
							else
							{
								nextPosition = 0;
							}

							jumpFlag = 1;
							patternOffset = 0;

						case FX_SET_VOLUME:
							voice.volume = row.param;
							voice.flags |= (UPDATE_VOLUME | SHORT_RAMP);

						case FX_PATTERN_BREAK:
							nextPosition = ((paramx * 10) + paramy) * channels;
							patternOffset = 0;

							if (jumpFlag == 0)
							{
								nextOrder = order + 1;

								if (nextOrder >= length)
								{
									complete = 1;
									nextPosition = -1;
								}
							}

						case FX_EXTENDED_EFFECTS:
							switch (paramx)
							{
								case EX_FINE_PORTAMENTO_UP:
									if (paramy != 0) voice.finePortaU = paramy << 2;
									voice.period -= voice.finePortaU;
									voice.flags |= UPDATE_PERIOD;

								case EX_FINE_PORTAMENTO_DOWN:
									if (paramy != 0) voice.finePortaD = paramy << 2;
									voice.period += voice.finePortaD;
									voice.flags |= UPDATE_PERIOD;

								case EX_GLISSANDO_CONTROL:
									voice.glissando = paramy;

								case EX_VIBRATO_CONTROL:
									voice.waveControl = (voice.waveControl & 0xf0) | paramy;

								case EX_PATTERN_LOOP:
									if (paramy == 0)
									{
										voice.patternLoopRow = patternOffset = position;
									}
									else
									{
										if (voice.patternLoop == 0)
										{
											voice.patternLoop = paramy;
										}
										else
										{
											voice.patternLoop--;
										}

										if (voice.patternLoop != 0)
											nextPosition = voice.patternLoopRow;
									}

								case EX_TREMOLO_CONTROL:
									voice.waveControl = (voice.waveControl & 0x0f) | (paramy << 4);

								case EX_FINE_VOLUME_SLIDE_UP:
									if (paramy != 0) voice.fineSlideU = paramy;
									voice.volume += voice.fineSlideU;
									voice.flags |= UPDATE_VOLUME;

								case EX_FINE_VOLUME_SLIDE_DOWN:
									if (paramy != 0) voice.fineSlideD = paramy;
									voice.volume -= voice.fineSlideD;
									voice.flags |= UPDATE_VOLUME;

								case EX_NOTE_DELAY:
									voice.delay = voice.flags;
									voice.flags = 0;

								case EX_PATTERN_DELAY:
									patternDelay = paramy * timer;
							}

						case FX_SET_SPEED if (row.param > 0):
							if (row.param < 32)
							{
								timer = row.param;
							}
							else
							{
								mixer.samplesTick = Std.int(110250 / row.param);
							}

						case FX_SET_GLOBAL_VOLUME:
							master = row.param;
							if (master > 64)
								master = 64;
							voice.flags |= UPDATE_VOLUME;

						case FX_GLOBAL_VOLUME_SLIDE:
							if (row.param != 0)
								voice.volSlideMaster = row.param;

						case FX_SET_ENVELOPE_POSITION:
							if (voice.instrument != null && voice.instrument.volEnabled != 0)
							{
								instr = voice.instrument;
								value = row.param;
								paramx = instr.volData.total;

								for (_tmp_ in 0...paramx)
								{
									i = _tmp_;
									if (value < instr.volData.points[i].frame)
										break;
								};

								voice.volEnvelope.position = --i;
								paramx--;

								if (((instr.volData.flags & ENVELOPE_LOOP) != 0) && i == instr.volData.loopEnd)
								{
									i = voice.volEnvelope.position = instr.volData.loopStart;
									value = instr.volData.points[i].frame;
									voice.volEnvelope.frame = value;
								}

								if (i >= paramx)
								{
									voice.volEnvelope.value = instr.volData.points[paramx].value;
									voice.volEnvelope.stopped = 1;
								}
								else
								{
									voice.volEnvelope.stopped = 0;
									voice.volEnvelope.frame = value;
									if (value > instr.volData.points[i].frame)
										voice.volEnvelope.position++;

									curr = instr.volData.points[i];
									next = instr.volData.points[++i];
									value = next.frame - curr.frame;

									voice.volEnvelope.delta = Std.int(value != 0 ? Std.int(((next.value - curr.value) << 8) / value) : 0);
									voice.volEnvelope.fraction = (curr.value << 8);
								}
							}
						case FX_PANNING_SLIDE:
							if (row.param != 0)
								voice.panSlide = row.param;

						case FX_MULTI_RETRIG_NOTE:
							if (paramx != 0)
								voice.retrigx = paramx;
							if (paramy != 0)
								voice.retrigy = paramy;

							if (row.volume == 0 && voice.retrigy != 0)
							{
								com = tick + 1;
								if (com % voice.retrigy != 0)
									break;
								if (row.volume > 80 && voice.retrigx != 0)
									retrig(voice);
							}

						case FX_TREMOR:
							if (row.param != 0)
							{
								voice.tremorOn = ++paramx;
								voice.tremorOff = ++paramy + paramx;
							}

						case FX_EXTRA_FINE_PORTAMENTO:
							if (paramx == 1)
							{
								if (paramy != 0)
									voice.xtraPortaU = paramy;
								voice.period -= voice.xtraPortaU;
								voice.flags |= UPDATE_PERIOD;
							}
							else if (paramx == 2)
							{
								if (paramy != 0)
									voice.xtraPortaD = paramy;
								voice.period += voice.xtraPortaD;
								voice.flags |= UPDATE_PERIOD;
							}
					}
				}
				voice = voice.next;
			}
		}
		else
		{
			while (voice != null)
			{
				row = pattern.rows[position + voice.index];

				if (voice.delay != 0)
				{
					if ((row.param & 15) == tick)
					{
						voice.flags = voice.delay;
						voice.delay = 0;
					}
					else
					{
						voice = voice.next;
						continue;
					}
				}

				if (row.volume != 0)
				{
					paramx = row.volume >> 4;
					paramy = row.volume & 15;

					switch (paramx)
					{
						case VX_VOLUME_SLIDE_DOWN:
							voice.volume -= paramy;
							if (voice.volume < 0)
								voice.volume = 0;
							voice.flags |= UPDATE_VOLUME;

						case VX_VOLUME_SLIDE_UP:
							voice.volume += paramy;
							if (voice.volume > 64)
								voice.volume = 64;
							voice.flags |= UPDATE_VOLUME;

						case VX_VIBRATO:
							voice.vibrato();

						case VX_PANNING_SLIDE_LEFT:
							voice.panning -= paramy;
							if (voice.panning < 0)
								voice.panning = 0;
							voice.flags |= UPDATE_PANNING;

						case VX_PANNING_SLIDE_RIGHT:
							voice.panning += paramy;
							if (voice.panning > 255)
								voice.panning = 255;
							voice.flags |= UPDATE_PANNING;

						case VX_TONE_PORTAMENTO:
							if (voice.portaPeriod != 0)
								voice.tonePortamento();
					}
				}

				paramx = row.param >> 4;
				paramy = row.param & 15;

				switch (row.effect)
				{
					case FX_ARPEGGIO:
						if (row.param == 0)
							break;
						value = (tick - timer) % 3;
						if (value < 0)
							value += 3;
						if (tick == 2 && timer == 18)
							value = 0;

						if (value == 0)
						{
							voice.arpDelta = 0;
						}
						else if (value == 1)
						{
							if (linear != 0)
							{
								voice.arpDelta = -(paramy << 6);
							}
							else
							{
								value = amiga(voice.note + paramy, voice.finetune);
								voice.arpDelta = value - voice.period;
							}
						}
						else
						{
							if (linear != 0)
							{
								voice.arpDelta = -(paramx << 6);
							}
							else
							{
								value = amiga(voice.note + paramx, voice.finetune);
								voice.arpDelta = value - voice.period;
							}
						}

						voice.flags |= UPDATE_PERIOD;

					case FX_PORTAMENTO_UP:
						voice.period -= voice.portaU;
						if (voice.period < 0)
							voice.period = 0;
						voice.flags |= UPDATE_PERIOD;

					case FX_PORTAMENTO_DOWN:
						voice.period += voice.portaD;
						if (voice.period > 9212)
							voice.period = 9212;
						voice.flags |= UPDATE_PERIOD;

					case FX_TONE_PORTAMENTO:
						if (voice.portaPeriod != 0)
							voice.tonePortamento();

					case FX_VIBRATO:
						if (paramx != 0)
							voice.vibratoSpeed = paramx;
						if (paramy != 0)
							voice.vibratoDepth = paramy << 2;
						voice.vibrato();

					case FX_TONE_PORTA_VOLUME_SLIDE:
						slide = 1;
						if (voice.portaPeriod != 0)
							voice.tonePortamento();

					case FX_VIBRATO_VOLUME_SLIDE:
						slide = 1;
						voice.vibrato();

					case FX_TREMOLO:
						voice.tremolo();

					case FX_VOLUME_SLIDE:
						slide = 1;

					case FX_EXTENDED_EFFECTS:
						switch (paramx)
						{
							case EX_RETRIG_NOTE:
								if ((tick % paramy) == 0)
								{
									voice.volEnvelope.reset();
									voice.panEnvelope.reset();
									voice.flags |= (UPDATE_VOLUME | UPDATE_PANNING | UPDATE_TRIGGER);
								}

							case EX_NOTE_CUT:
								if (tick == paramy)
								{
									voice.volume = 0;
									voice.flags |= UPDATE_VOLUME;
								}
						}

					case FX_GLOBAL_VOLUME_SLIDE:
						paramx = voice.volSlideMaster >> 4;
						paramy = voice.volSlideMaster & 15;

						if (paramx != 0)
						{
							master += paramx;
							if (master > 64)
								master = 64;
							voice.flags |= UPDATE_VOLUME;
						}
						else if (paramy != 0)
						{
							master -= paramy;
							if (master < 0)
								master = 0;
							voice.flags |= UPDATE_VOLUME;
						}

					case FX_KEYOFF:
						if (tick == row.param)
						{
							voice.fadeEnabled = 1;
							voice.keyoff = 1;
						}

					case FX_PANNING_SLIDE:
						paramx = voice.panSlide >> 4;
						paramy = voice.panSlide & 15;

						if (paramx != 0)
						{
							voice.panning += paramx;
							if (voice.panning > 255)
								voice.panning = 255;
							voice.flags |= UPDATE_PANNING;
						}
						else if (paramy != 0)
						{
							voice.panning -= paramy;
							if (voice.panning < 0)
								voice.panning = 0;
							voice.flags |= UPDATE_PANNING;
						}

					case FX_MULTI_RETRIG_NOTE:
						com = tick;
						if (row.volume == 0)
							com++;
						if (com % voice.retrigy != 0)
							break;

						if ((row.volume == 0 || row.volume > 80) && voice.retrigx != 0)
							retrig(voice);
						voice.flags |= UPDATE_TRIGGER;

					case FX_TREMOR:
						voice.tremor();
				}

				if (slide != 0)
				{
					paramx = voice.volSlide >> 4;
					paramy = voice.volSlide & 15;
					slide = 0;

					if (paramx != 0)
					{
						voice.volume += paramx;
						voice.flags |= UPDATE_VOLUME;
					}
					else if (paramy != 0)
					{
						voice.volume -= paramy;
						voice.flags |= UPDATE_VOLUME;
					}
				}
				voice = voice.next;
			}
		}

		if (++tick >= (timer + patternDelay))
		{
			patternDelay = tick = 0;

			if (nextPosition < 0)
			{
				nextPosition = position + channels;

				if (nextPosition >= pattern.size || complete != 0)
				{
					nextOrder = order + 1;
					nextPosition = patternOffset;

					if (nextOrder >= length)
					{
						nextOrder = restart;
						mixer.complete = 1;
					}
				}
			}
		}
	}

	override public function fast()
	{
		var chan:SBChannel, delta:Int, flags:Int, instr:F2Instrument, panning:Int, voice = voices[0], volume:Float;

		while (voice != null)
		{
			chan = voice.channel;
			flags = voice.flags;
			voice.flags = 0;

			if ((flags & UPDATE_TRIGGER) != 0)
			{
				chan.index = voice.sampleOffset;
				chan.pointer = -1;
				chan.dir = 0;
				chan.fraction = 0;
				chan.sample = voice.sample;
				chan.length = voice.sample.length;

				chan.enabled = chan.sample.data != null ? 1 : 0;
				voice.playing = voice.instrument;
				voice.sampleOffset = 0;
			}

			instr = voice.playing;
			delta = instr.vibratoSpeed != 0 ? voice.autoVibrato() : 0;

			volume = voice.volume + voice.volDelta;

			if (instr.volEnabled != 0)
			{
				if (voice.volEnabled != 0 && voice.volEnvelope.stopped == 0)
					envelope(voice, voice.volEnvelope, instr.volData);

				volume = Std.int(volume * voice.volEnvelope.value) >> 6;
				flags |= UPDATE_VOLUME;

				if (voice.fadeEnabled != 0)
				{
					voice.fadeVolume -= voice.fadeDelta;

					if (voice.fadeVolume < 0)
					{
						volume = 0;

						voice.fadeVolume = 0;
						voice.fadeEnabled = 0;

						voice.volEnvelope.value = 0;
						voice.volEnvelope.stopped = 1;
						voice.panEnvelope.stopped = 1;
					}
					else
					{
						volume = Std.int(volume * voice.fadeVolume) >> 16;
					}
				}
			}
			else if (voice.keyoff != 0)
			{
				volume = 0;
				flags |= UPDATE_VOLUME;
			}

			panning = voice.panning;

			if (instr.panEnabled != 0)
			{
				if (voice.panEnabled != 0 && voice.panEnvelope.stopped == 0)
					envelope(voice, voice.panEnvelope, instr.panData);

				panning = (voice.panEnvelope.value << 2);
				flags |= UPDATE_PANNING;

				if (panning < 0)
				{
					panning = 0;
				}
				else if (panning > 255)
				{
					panning = 255;
				}
			}

			if ((flags & UPDATE_VOLUME) != 0)
			{
				if (volume < 0)
				{
					volume = 0;
				}
				else if (volume > 64)
				{
					volume = 64;
				}

				chan.volume = VOLUMES[Std.int(volume * master) >> 6];
				chan.lvol = chan.volume * chan.lpan;
				chan.rvol = chan.volume * chan.rpan;
			}

			if ((flags & UPDATE_PANNING) != 0)
			{
				chan.panning = panning;
				chan.lpan = PANNING[256 - panning];
				chan.rpan = PANNING[panning];

				chan.lvol = chan.volume * chan.lpan;
				chan.rvol = chan.volume * chan.rpan;
			}

			if ((flags & UPDATE_PERIOD) != 0)
			{
				delta += voice.period + voice.arpDelta + voice.vibDelta;

				if (linear != 0)
				{
					chan.speed = Std.int((548077568 * Math.pow(2, ((4608 - delta) / 768))) / 44100) / 65536;
				}
				else
				{
					chan.speed = Std.int((65536 * (14317456 / delta)) / 44100) / 65536;
				}

				chan.delta = Std.int(chan.speed);
				chan.speed -= chan.delta;
			}
			voice = voice.next;
		}
	}

	override public function accurate()
	{
		var chan:SBChannel, delta:Int, flags:Int, instr:F2Instrument, lpan:Float, lvol:Float, panning:Int, rpan:Float, rvol:Float, voice = voices[0], volume:Float;

		while (voice != null)
		{
			chan = voice.channel;
			flags = voice.flags;
			voice.flags = 0;

			if ((flags & UPDATE_TRIGGER) != 0)
			{
				if (chan.sample != null)
				{
					flags |= SHORT_RAMP;
					chan.mixCounter = 220;
					chan.oldSample = null;
					chan.oldPointer = -1;

					if (chan.enabled != 0)
					{
						chan.oldDir = chan.dir;
						chan.oldFraction = chan.fraction;
						chan.oldSpeed = chan.speed;
						chan.oldSample = chan.sample;
						chan.oldPointer = chan.pointer;
						chan.oldLength = chan.length;

						chan.lmixRampD = chan.lvol;
						chan.lmixDeltaD = chan.lvol / 220;
						chan.rmixRampD = chan.rvol;
						chan.rmixDeltaD = chan.rvol / 220;
					}
				}

				chan.dir = 1;
				chan.fraction = 0;
				chan.sample = voice.sample;
				chan.pointer = voice.sampleOffset;
				chan.length = voice.sample.length;

				chan.enabled = chan.sample.data != null ? 1 : 0;
				voice.playing = voice.instrument;
				voice.sampleOffset = 0;
			}

			instr = voice.playing;
			delta = instr.vibratoSpeed != 0 ? voice.autoVibrato() : 0;

			volume = voice.volume + voice.volDelta;

			if (instr.volEnabled != 0)
			{
				if (voice.volEnabled != 0 && voice.volEnvelope.stopped == 0)
					envelope(voice, voice.volEnvelope, instr.volData);

				volume = Std.int(volume * voice.volEnvelope.value) >> 6;
				flags |= UPDATE_VOLUME;

				if (voice.fadeEnabled != 0)
				{
					voice.fadeVolume -= voice.fadeDelta;

					if (voice.fadeVolume < 0)
					{
						volume = 0;

						voice.fadeVolume = 0;
						voice.fadeEnabled = 0;

						voice.volEnvelope.value = 0;
						voice.volEnvelope.stopped = 1;
						voice.panEnvelope.stopped = 1;
					}
					else
					{
						volume = Std.int(volume * voice.fadeVolume) >> 16;
					}
				}
			}
			else if (voice.keyoff != 0)
			{
				volume = 0;
				flags |= UPDATE_VOLUME;
			}

			panning = voice.panning;

			if (instr.panEnabled != 0)
			{
				if (voice.panEnabled != 0 && voice.panEnvelope.stopped == 0)
					envelope(voice, voice.panEnvelope, instr.panData);

				panning = (voice.panEnvelope.value << 2);
				flags |= UPDATE_PANNING;

				if (panning < 0)
				{
					panning = 0;
				}
				else if (panning > 255)
				{
					panning = 255;
				}
			}

			if (chan.enabled == 0)
			{
				chan.volCounter = 0;
				chan.panCounter = 0;
				voice = voice.next;
				continue;
			}

			if ((flags & UPDATE_VOLUME) != 0)
			{
				if (volume < 0)
				{
					volume = 0;
				}
				else if (volume > 64)
				{
					volume = 64;
				}

				volume = VOLUMES[Std.int(volume * master) >> 6];
				lvol = volume * PANNING[256 - panning];
				rvol = volume * PANNING[panning];

				if (volume != chan.volume && chan.mixCounter == 0)
				{
					chan.volCounter = ((flags & SHORT_RAMP) != 0) ? 220 : mixer.samplesTick;

					chan.lvolDelta = (lvol - chan.lvol) / chan.volCounter;
					chan.rvolDelta = (rvol - chan.rvol) / chan.volCounter;
				}
				else
				{
					chan.lvol = lvol;
					chan.rvol = rvol;
				}
				chan.volume = volume;
			}

			if ((flags & UPDATE_PANNING) != 0)
			{
				lpan = PANNING[256 - panning];
				rpan = PANNING[panning];

				if (panning != chan.panning && chan.mixCounter == 0 && chan.volCounter == 0)
				{
					chan.panCounter = mixer.samplesTick;

					chan.lpanDelta = (lpan - chan.lpan) / chan.panCounter;
					chan.rpanDelta = (rpan - chan.rpan) / chan.panCounter;
				}
				else
				{
					chan.lpan = lpan;
					chan.rpan = rpan;
				}
				chan.panning = panning;
			}

			if ((flags & UPDATE_PERIOD) != 0)
			{
				delta += voice.period + voice.arpDelta + voice.vibDelta;

				if (linear != 0)
				{
					chan.speed = Std.int((548077568 * Math.pow(2, ((4608 - delta) / 768))) / 44100) / 65536;
				}
				else
				{
					chan.speed = Std.int((65536 * (14317456 / delta)) / 44100) / 65536;
				}
			}

			if (chan.mixCounter != 0)
			{
				chan.lmixRampU = 0.0;
				chan.lmixDeltaU = chan.lvol / 220;
				chan.rmixRampU = 0.0;
				chan.rmixDeltaU = chan.rvol / 220;
			}
			voice = voice.next;
		}
	}

	override function initialize()
	{
		var i = 0, voice:F2Voice;
		super.initialize();

		timer = speed;
		order = 0;
		position = 0;
		nextOrder = -1;
		nextPosition = -1;
		patternDelay = 0;
		patternOffset = 0;
		complete = 0;
		master = 64;

		voices = new Vector<F2Voice>(channels, true);

		while (i < channels)
		{
			voice = new F2Voice(i);

			voice.channel = mixer.channels[i];
			voice.playing = instruments[0];
			voice.sample = voice.playing.samples[0];

			voices[i] = voice;
			if (i != 0)
				voices[i - 1].next = voice;
			++i;
		}
	}

	override function loader(stream:ByteArray)
	{
		var header:Int, i:Int, id:String, iheader:Int, instr:F2Instrument, ipos:Int, j:Int, len:Int, pattern:F2Pattern, pos:Int, reserved = 22, row:F2Row, rows:Int, sample:F2Sample, value:Int;
		if (stream.length < 360)
			return;
		stream.position = 17;

		title = stream.readMultiByte(20, CorePlayer.ENCODING);
		stream.position++;
		id = stream.readMultiByte(20, CorePlayer.ENCODING);

		if (id == "FastTracker v2.00   " || id == "FastTracker v 2.00  ")
		{
			this.version = 1;
		}
		else if (id == "Sk@le Tracker")
		{
			reserved = 2;
			this.version = 2;
		}
		else if (id == "MadTracker 2.0")
		{
			this.version = 3;
		}
		else if (id == "MilkyTracker        ")
		{
			this.version = 4;
		}
		else if (id == "DigiBooster Pro 2.18")
		{
			this.version = 5;
		}
		else if (id.indexOf("OpenMPT") != -1)
		{
			this.version = 6;
		}
		else
			return;

		stream.readUnsignedShort();

		header = stream.readUnsignedInt();
		length = stream.readUnsignedShort();
		restart = stream.readUnsignedShort();
		channels = stream.readUnsignedShort();

		value = rows = stream.readUnsignedShort();
		instruments = new Vector<F2Instrument>(stream.readUnsignedShort() + 1, true);

		linear = stream.readUnsignedShort();
		speed = stream.readUnsignedShort();
		tempo = stream.readUnsignedShort();

		track = new Vector<Int>(length, true);

		i = 0;
		while (i < length)
		{
			j = stream.readUnsignedByte();
			if (j >= value)
				rows = j + 1;
			track[i] = j;
			++i;
		}

		patterns = new Vector<F2Pattern>(rows, true);

		if (rows != value)
		{
			pattern = new F2Pattern(64, channels);
			j = pattern.size;
			for (_tmp_ in 0...j)
			{
				i = _tmp_;
				pattern.rows[i] = new F2Row();
			};
			patterns[--rows] = pattern;
		}

		stream.position = pos = header + 60;
		len = value;

		for (_tmp_ in 0...len)
		{
			i = _tmp_;
			header = stream.readUnsignedInt();
			stream.position++;

			pattern = new F2Pattern(stream.readUnsignedShort(), channels);
			rows = pattern.size;

			value = stream.readUnsignedShort();
			stream.position = pos + header;
			ipos = stream.position + value;

			if (value != 0)
			{
				for (_tmp_ in 0...rows)
				{
					j = _tmp_;
					row = new F2Row();
					value = stream.readUnsignedByte();

					if ((value & 128) != 0)
					{
						if ((value & 1) != 0)
							row.note = stream.readUnsignedByte();
						if ((value & 2) != 0)
							row.instrument = stream.readUnsignedByte();
						if ((value & 4) != 0)
							row.volume = stream.readUnsignedByte();
						if ((value & 8) != 0)
							row.effect = stream.readUnsignedByte();
						if ((value & 16) != 0)
							row.param = stream.readUnsignedByte();
					}
					else
					{
						row.note = value;
						row.instrument = stream.readUnsignedByte();
						row.volume = stream.readUnsignedByte();
						row.effect = stream.readUnsignedByte();
						row.param = stream.readUnsignedByte();
					}

					if (row.note != KEYOFF_NOTE)
						if (row.note > 96)
							row.note = 0;
					pattern.rows[j] = row;
				}
			}
			else
			{
				for (_tmp_ in 0...rows)
				{
					j = _tmp_;
					pattern.rows[j] = new F2Row();
				};
			}

			patterns[i] = pattern;
			pos = stream.position;
			if (pos != ipos)
				pos = stream.position = ipos;
		}

		ipos = stream.position;
		len = instruments.length;

		for (_tmp_ in 1...len)
		{
			i = _tmp_;
			iheader = stream.readUnsignedInt();
			if ((stream.position + iheader) >= stream.length)
				break;

			instr = new F2Instrument();
			instr.name = stream.readMultiByte(22, CorePlayer.ENCODING);
			stream.position++;

			value = stream.readUnsignedShort();
			if (value > 16)
				value = 16;
			header = stream.readUnsignedInt();
			if (reserved == 2 && header != 64)
				header = 64;

			if (value != 0)
			{
				instr.samples = new Vector<F2Sample>(value, true);

				for (_tmp_ in 0...96)
				{
					j = _tmp_;
					instr.noteSamples[j] = stream.readUnsignedByte();
				};
				for (_tmp_ in 0...12)
				{
					j = _tmp_;
					instr.volData.points[j] = new F2Point(stream.readUnsignedShort(), stream.readUnsignedShort());
				};
				for (_tmp_ in 0...12)
				{
					j = _tmp_;
					instr.panData.points[j] = new F2Point(stream.readUnsignedShort(), stream.readUnsignedShort());
				};

				instr.volData.total = stream.readUnsignedByte();
				instr.panData.total = stream.readUnsignedByte();
				instr.volData.sustain = stream.readUnsignedByte();
				instr.volData.loopStart = stream.readUnsignedByte();
				instr.volData.loopEnd = stream.readUnsignedByte();
				instr.panData.sustain = stream.readUnsignedByte();
				instr.panData.loopStart = stream.readUnsignedByte();
				instr.panData.loopEnd = stream.readUnsignedByte();
				instr.volData.flags = stream.readUnsignedByte();
				instr.panData.flags = stream.readUnsignedByte();

				if ((instr.volData.flags & ENVELOPE_ON) != 0)
					instr.volEnabled = 1;
				if ((instr.panData.flags & ENVELOPE_ON) != 0)
					instr.panEnabled = 1;

				instr.vibratoType = stream.readUnsignedByte();
				instr.vibratoSweep = stream.readUnsignedByte();
				instr.vibratoDepth = stream.readUnsignedByte();
				instr.vibratoSpeed = stream.readUnsignedByte();
				instr.fadeout = stream.readUnsignedShort() << 1;

				stream.position += reserved;
				pos = stream.position;
				instruments[i] = instr;

				for (_tmp_ in 0...value)
				{
					j = _tmp_;
					sample = new F2Sample();
					sample.length = stream.readUnsignedInt();
					sample.loopStart = stream.readUnsignedInt();
					sample.loopLen = stream.readUnsignedInt();
					sample.volume = stream.readUnsignedByte();
					sample.finetune = stream.readByte();
					sample.loopMode = stream.readUnsignedByte();
					sample.panning = stream.readUnsignedByte();
					sample.relative = stream.readByte();

					stream.position++;
					sample.name = stream.readMultiByte(22, CorePlayer.ENCODING);
					instr.samples[j] = sample;

					stream.position = (pos += header);
				}

				for (_tmp_ in 0...value)
				{
					j = _tmp_;
					sample = instr.samples[j];
					if (sample.length == 0)
						continue;
					pos = stream.position + sample.length;

					if ((sample.loopMode & 16) != 0)
					{
						sample.bits = 16;
						sample.loopMode ^= 16;
						sample.length >>= 1;
						sample.loopStart >>= 1;
						sample.loopLen >>= 1;
					}

					if (sample.loopLen == 0)
						sample.loopMode = 0;
					sample.store(stream);
					if (sample.loopMode != 0)
						sample.length = sample.loopStart + sample.loopLen;
					stream.position = pos;
				}
			}
			else
			{
				stream.position = ipos + iheader;
			}

			ipos = stream.position;
			if ((ipos : UInt) >= stream.length)
				break;
		}

		instr = new F2Instrument();
		instr.volData = new F2Data();
		instr.panData = new F2Data();
		instr.samples = new Vector<F2Sample>(1, true);

		for (_tmp_ in 0...12)
		{
			i = _tmp_;
			instr.volData.points[i] = new F2Point();
			instr.panData.points[i] = new F2Point();
		}

		sample = new F2Sample();
		sample.length = 220;
		sample.data = new Vector<Float>(220, true);

		for (_tmp_ in 0...220)
		{
			i = _tmp_;
			sample.data[i] = 0.0;
		}

		instr.samples[0] = sample;
		instruments[0] = instr;
	}

	function envelope(voice:F2Voice, envelope:F2Envelope, data:F2Data)
	{
		var pos = envelope.position, curr = data.points[pos], next:F2Point;

		if (envelope.frame == curr.frame)
		{
			if (((data.flags & ENVELOPE_LOOP) != 0) && pos == data.loopEnd)
			{
				pos = envelope.position = data.loopStart;
				curr = data.points[pos];
				envelope.frame = curr.frame;
			}

			if (pos == (data.total - 1))
			{
				envelope.value = curr.value;
				envelope.stopped = 1;
				return;
			}

			if (((data.flags & ENVELOPE_SUSTAIN) != 0) && pos == data.sustain && voice.fadeEnabled == 0)
			{
				envelope.value = curr.value;
				return;
			}

			envelope.position++;
			next = data.points[envelope.position];

			envelope.delta = Std.int(((next.value - curr.value) << 8) / (next.frame - curr.frame));
			envelope.fraction = (curr.value << 8);
		}
		else
		{
			envelope.fraction += envelope.delta;
		}

		envelope.value = (envelope.fraction >> 8);
		envelope.frame++;
	}

	function amiga(note:Int, finetune:Int):Int
	{
		var delta = 0.0, period = PERIODS[++note];

		if (finetune < 0)
		{
			delta = (PERIODS[--note] - period) / 64;
		}
		else if (finetune > 0)
		{
			delta = (period - PERIODS[++note]) / 64;
		}

		return Std.int(period - (delta * finetune));
	}

	function retrig(voice:F2Voice)
	{
		switch (voice.retrigx)
		{
			case 1:
				voice.volume--;

			case 2:
				voice.volume++;

			case 3:
				voice.volume -= 4;

			case 4:
				voice.volume -= 8;

			case 5:
				voice.volume -= 16;

			case 6:
				voice.volume = Std.int((voice.volume << 1) / 3);

			case 7:
				voice.volume >>= 1;

			case 8:
				voice.volume = voice.sample.volume;

			case 9:
				voice.volume++;

			case 10:
				voice.volume += 2;

			case 11:
				voice.volume += 4;

			case 12:
				voice.volume += 8;

			case 13:
				voice.volume += 16;

			case 14:
				voice.volume = (voice.volume * 3) >> 1;

			case 15:
				voice.volume <<= 1;
		}

		if (voice.volume < 0)
		{
			voice.volume = 0;
		}
		else if (voice.volume > 64)
		{
			voice.volume = 64;
		}

		voice.flags |= UPDATE_VOLUME;
	}

	@:allow(neoart.flod.fasttracker) static inline final UPDATE_PERIOD = 1;
	@:allow(neoart.flod.fasttracker) static inline final UPDATE_VOLUME = 2;
	@:allow(neoart.flod.fasttracker) static inline final UPDATE_PANNING = 4;
	@:allow(neoart.flod.fasttracker) static inline final UPDATE_TRIGGER = 8;
	@:allow(neoart.flod.fasttracker) static inline final UPDATE_ALL = 15;
	@:allow(neoart.flod.fasttracker) static inline final SHORT_RAMP = 32;
	@:allow(neoart.flod.fasttracker) static inline final ENVELOPE_ON = 1;
	@:allow(neoart.flod.fasttracker) static inline final ENVELOPE_SUSTAIN = 2;
	@:allow(neoart.flod.fasttracker) static inline final ENVELOPE_LOOP = 4;
	@:allow(neoart.flod.fasttracker) static inline final LOWER_NOTE = 0;
	@:allow(neoart.flod.fasttracker) static inline final HIGHER_NOTE = 118;
	@:allow(neoart.flod.fasttracker) static inline final KEYOFF_NOTE = 97;
	@:allow(neoart.flod.fasttracker) static inline final FX_ARPEGGIO = 0;
	@:allow(neoart.flod.fasttracker) static inline final FX_PORTAMENTO_UP = 1;
	@:allow(neoart.flod.fasttracker) static inline final FX_PORTAMENTO_DOWN = 2;
	@:allow(neoart.flod.fasttracker) static inline final FX_TONE_PORTAMENTO = 3;
	@:allow(neoart.flod.fasttracker) static inline final FX_VIBRATO = 4;
	@:allow(neoart.flod.fasttracker) static inline final FX_TONE_PORTA_VOLUME_SLIDE = 5;
	@:allow(neoart.flod.fasttracker) static inline final FX_VIBRATO_VOLUME_SLIDE = 6;
	@:allow(neoart.flod.fasttracker) static inline final FX_TREMOLO = 7;
	@:allow(neoart.flod.fasttracker) static inline final FX_SET_PANNING = 8;
	@:allow(neoart.flod.fasttracker) static inline final FX_SAMPLE_OFFSET = 9;
	@:allow(neoart.flod.fasttracker) static inline final FX_VOLUME_SLIDE = 10;
	@:allow(neoart.flod.fasttracker) static inline final FX_POSITION_JUMP = 11;
	@:allow(neoart.flod.fasttracker) static inline final FX_SET_VOLUME = 12;
	@:allow(neoart.flod.fasttracker) static inline final FX_PATTERN_BREAK = 13;
	@:allow(neoart.flod.fasttracker) static inline final FX_EXTENDED_EFFECTS = 14;
	@:allow(neoart.flod.fasttracker) static inline final FX_SET_SPEED = 15;
	@:allow(neoart.flod.fasttracker) static inline final FX_SET_GLOBAL_VOLUME = 16;
	@:allow(neoart.flod.fasttracker) static inline final FX_GLOBAL_VOLUME_SLIDE = 17;
	@:allow(neoart.flod.fasttracker) static inline final FX_KEYOFF = 20;
	@:allow(neoart.flod.fasttracker) static inline final FX_SET_ENVELOPE_POSITION = 21;
	@:allow(neoart.flod.fasttracker) static inline final FX_PANNING_SLIDE = 24;
	@:allow(neoart.flod.fasttracker) static inline final FX_MULTI_RETRIG_NOTE = 27;
	@:allow(neoart.flod.fasttracker) static inline final FX_TREMOR = 29;
	@:allow(neoart.flod.fasttracker) static inline final FX_EXTRA_FINE_PORTAMENTO = 33;
	@:allow(neoart.flod.fasttracker) static inline final EX_FINE_PORTAMENTO_UP = 1;
	@:allow(neoart.flod.fasttracker) static inline final EX_FINE_PORTAMENTO_DOWN = 2;
	@:allow(neoart.flod.fasttracker) static inline final EX_GLISSANDO_CONTROL = 3;
	@:allow(neoart.flod.fasttracker) static inline final EX_VIBRATO_CONTROL = 4;
	@:allow(neoart.flod.fasttracker) static inline final EX_SET_FINETUNE = 5;
	@:allow(neoart.flod.fasttracker) static inline final EX_PATTERN_LOOP = 6;
	@:allow(neoart.flod.fasttracker) static inline final EX_TREMOLO_CONTROL = 7;
	@:allow(neoart.flod.fasttracker) static inline final EX_RETRIG_NOTE = 9;
	@:allow(neoart.flod.fasttracker) static inline final EX_FINE_VOLUME_SLIDE_UP = 10;
	@:allow(neoart.flod.fasttracker) static inline final EX_FINE_VOLUME_SLIDE_DOWN = 11;
	@:allow(neoart.flod.fasttracker) static inline final EX_NOTE_CUT = 12;
	@:allow(neoart.flod.fasttracker) static inline final EX_NOTE_DELAY = 13;
	@:allow(neoart.flod.fasttracker) static inline final EX_PATTERN_DELAY = 14;
	@:allow(neoart.flod.fasttracker) static inline final VX_VOLUME_SLIDE_DOWN = 6;
	@:allow(neoart.flod.fasttracker) static inline final VX_VOLUME_SLIDE_UP = 7;
	@:allow(neoart.flod.fasttracker) static inline final VX_FINE_VOLUME_SLIDE_DOWN = 8;
	@:allow(neoart.flod.fasttracker) static inline final VX_FINE_VOLUME_SLIDE_UP = 9;
	@:allow(neoart.flod.fasttracker) static inline final VX_SET_VIBRATO_SPEED = 10;
	@:allow(neoart.flod.fasttracker) static inline final VX_VIBRATO = 11;
	@:allow(neoart.flod.fasttracker) static inline final VX_SET_PANNING = 12;
	@:allow(neoart.flod.fasttracker) static inline final VX_PANNING_SLIDE_LEFT = 13;
	@:allow(neoart.flod.fasttracker) static inline final VX_PANNING_SLIDE_RIGHT = 14;
	@:allow(neoart.flod.fasttracker) static inline final VX_TONE_PORTAMENTO = 15;
	@:allow(neoart.flod.fasttracker) static final PANNING:Vector<Float> = Vector.ofArray([
		0.000000, 0.044170, 0.062489, 0.076523, 0.088371, 0.098821, 0.108239, 0.116927, 0.124977, 0.132572, 0.139741, 0.146576, 0.153077, 0.159335, 0.165350,
		0.171152, 0.176772, 0.182210, 0.187496, 0.192630, 0.197643, 0.202503, 0.207273, 0.211951, 0.216477, 0.220943, 0.225348, 0.229631, 0.233854, 0.237985,
		0.242056, 0.246066, 0.249985, 0.253873, 0.257670, 0.261437, 0.265144, 0.268819, 0.272404, 0.275989, 0.279482, 0.282976, 0.286409, 0.289781, 0.293153,
		0.296464, 0.299714, 0.302965, 0.306185, 0.309344, 0.312473, 0.315602, 0.318671, 0.321708, 0.324746, 0.327754, 0.330700, 0.333647, 0.336563, 0.339449,
		0.342305, 0.345161, 0.347986, 0.350781, 0.353545, 0.356279, 0.359013, 0.361717, 0.364421, 0.367094, 0.369737, 0.372380, 0.374992, 0.377574, 0.380157,
		0.382708, 0.385260, 0.387782, 0.390303, 0.392794, 0.395285, 0.397746, 0.400176, 0.402606, 0.405037, 0.407437, 0.409836, 0.412206, 0.414576, 0.416915,
		0.419254, 0.421563, 0.423841, 0.426180, 0.428458, 0.430737, 0.432985, 0.435263, 0.437481, 0.439729, 0.441916, 0.444134, 0.446321, 0.448508, 0.450665,
		0.452852, 0.455009, 0.457136, 0.459262, 0.461389, 0.463485, 0.465611, 0.467708, 0.469773, 0.471839, 0.473935, 0.475970, 0.478036, 0.480072, 0.482077,
		0.484112, 0.486117, 0.488122, 0.490127, 0.492101, 0.494106, 0.496051, 0.498025, 0.500000, 0.501944, 0.503888, 0.505802, 0.507746, 0.509660, 0.511574,
		0.513488, 0.515371, 0.517255, 0.519138, 0.521022, 0.522905, 0.524758, 0.526611, 0.528465, 0.530318, 0.532140, 0.533993, 0.535816, 0.537639, 0.539462,
		0.541254, 0.543046, 0.544839, 0.546631, 0.548423, 0.550216, 0.551978, 0.553739, 0.555501, 0.557263, 0.558995, 0.560757, 0.562489, 0.564220, 0.565952,
		0.567683, 0.569384, 0.571116, 0.572817, 0.574518, 0.576220, 0.577890, 0.579592, 0.581262, 0.582964, 0.584634, 0.586305, 0.587946, 0.589617, 0.591257,
		0.592928, 0.594568, 0.596209, 0.597849, 0.599459, 0.601100, 0.602710, 0.604350, 0.605960, 0.607570, 0.609150, 0.610760, 0.612370, 0.613950, 0.615560,
		0.617139, 0.618719, 0.620268, 0.621848, 0.623428, 0.624977, 0.626557, 0.628106, 0.629655, 0.631205, 0.632754, 0.634303, 0.635822, 0.637372, 0.638890,
		0.640440, 0.641959, 0.643478, 0.644966, 0.646485, 0.648004, 0.649523, 0.651012, 0.652500, 0.653989, 0.655477, 0.656966, 0.658454, 0.659943, 0.661431,
		0.662890, 0.664378, 0.665836, 0.667294, 0.668783, 0.670241, 0.671699, 0.673127, 0.674585, 0.676043, 0.677471, 0.678929, 0.680357, 0.681785, 0.683213,
		0.684641, 0.686068, 0.687496, 0.688894, 0.690321, 0.691749, 0.693147, 0.694574, 0.695972, 0.697369, 0.698767, 0.700164, 0.701561, 0.702928, 0.704326,
		0.705723, 0.707110
	]);
	@:allow(neoart.flod.fasttracker) static final VOLUMES:Vector<Float> = Vector.ofArray([
		0.000000, 0.005863, 0.013701, 0.021569, 0.029406, 0.037244, 0.045082, 0.052919, 0.060757, 0.068625, 0.076463, 0.084300, 0.092138, 0.099976, 0.107844,
		0.115681, 0.123519, 0.131357, 0.139194, 0.147032, 0.154900, 0.162738, 0.170575, 0.178413, 0.186251, 0.194119, 0.201956, 0.209794, 0.217632, 0.225469,
		0.233307, 0.241175, 0.249013, 0.256850, 0.264688, 0.272526, 0.280394, 0.288231, 0.296069, 0.303907, 0.311744, 0.319582, 0.327450, 0.335288, 0.343125,
		0.350963, 0.358800, 0.366669, 0.374506, 0.382344, 0.390182, 0.398019, 0.405857, 0.413725, 0.421563, 0.429400, 0.437238, 0.445076, 0.452944, 0.460781,
		0.468619, 0.476457, 0.484294, 0.492132, 0.500000
	]);
	@:allow(neoart.flod.fasttracker) static final PERIODS:Vector<Int> = Vector.ofArray([
		29024, 27392, 25856, 24384, 23040, 21696, 20480, 19328, 18240, 17216, 16256, 15360, 14512, 13696, 12928, 12192, 11520, 10848, 10240, 9664, 9120, 8608,
		8128, 7680, 7256, 6848, 6464, 6096, 5760, 5424, 5120, 4832, 4560, 4304, 4064, 3840, 3628, 3424, 3232, 3048, 2880, 2712, 2560, 2416, 2280, 2152, 2032,
		1920, 1814, 1712, 1616, 1524, 1440, 1356, 1280, 1208, 1140, 1076, 1016, 960, 907, 856, 808, 762, 720, 678, 640, 604, 570, 538, 508, 480, 453, 428, 404,
		381, 360, 339, 320, 302, 285, 269, 254, 240, 227, 214, 202, 190, 180, 169, 160, 151, 142, 134, 127, 120, 113, 107, 101, 95, 90, 85, 80, 75, 71, 67, 63,
		60, 57, 53, 50, 48, 45, 42, 40, 38, 36, 34, 32, 30, 28
	]);
}
