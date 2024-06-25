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
package neoart.flod.core;

import flash.events.*;
import flash.utils.*;
import flash.Vector;

final class Soundblaster extends CoreMixer
{
	public var channels:Vector<SBChannel>;

	public function new()
	{
		super();
	}

	@:allow(neoart.flod.core) function setup(len:Int)
	{
		var i = 1;
		channels = new Vector<SBChannel>(len, true);
		channels[0] = new SBChannel();

		while (i < len)
		{
			channels[i] = channels[i - 1].next = new SBChannel();
			++i;
		};
	}

	@:allow(neoart.flod.core)
	override function initialize()
	{
		var chan = channels[0];
		super.initialize();

		while (chan != null)
		{
			chan.initialize();
			chan = chan.next;
		}
	}

	@:allow(neoart.flod.core)
	override function fast(e:SampleDataEvent)
	{
		var chan:SBChannel, d:Vector<Float>, data = e
			.data, i:Int, mixed = 0, mixLen:Int, mixPos = 0, s:SBSample, sample:Sample, size = bufferSize, toMix:Int, value:Float;

		if (completed != 0)
		{
			if (remains == 0)
				return;
			size = remains;
		}

		while (mixed < size)
		{
			if (samplesLeft == 0)
			{
				player.process();
				player.fast();
				samplesLeft = samplesTick;

				if (completed != 0)
				{
					size = mixed + samplesTick;

					if (size > bufferSize)
					{
						remains = size - bufferSize;
						size = bufferSize;
					}
				}
			}

			toMix = samplesLeft;
			if ((mixed + toMix) >= size)
				toMix = size - mixed;
			mixLen = mixPos + toMix;
			chan = channels[0];

			while (chan != null)
			{
				if (chan.enabled == 0)
				{
					chan = chan.next;
					continue;
				}

				s = chan.sample;
				d = s.data;
				sample = buffer[mixPos];

				for (_tmp_ in mixPos...mixLen)
				{
					i = _tmp_;
					if (chan.index != chan.pointer)
					{
						if (chan.index >= chan.length)
						{
							if (s.loopMode == 0)
							{
								chan.enabled = 0;
								break;
							}
							else
							{
								chan.pointer = s.loopStart + (chan.index - chan.length);
								chan.length = s.length;

								if (s.loopMode == 2)
								{
									if (chan.dir == 0)
									{
										chan.dir = s.length + s.loopStart - 1;
									}
									else
									{
										chan.dir = 0;
									}
								}
							}
						}
						else
							chan.pointer = chan.index;

						if (chan.mute == 0)
						{
							if (chan.dir == 0)
							{
								value = d[chan.pointer];
							}
							else
							{
								value = d[chan.dir - chan.pointer];
							}

							chan.ldata = value * chan.lvol;
							chan.rdata = value * chan.rvol;
						}
						else
						{
							chan.ldata = 0.0;
							chan.rdata = 0.0;
						}
					}

					chan.index = chan.pointer + chan.delta;

					if ((chan.fraction += chan.speed) >= 1.0)
					{
						chan.index++;
						chan.fraction--;
					}

					sample.l += chan.ldata;
					sample.r += chan.rdata;
					sample = sample.next;
				}
				chan = chan.next;
			}

			mixPos = mixLen;
			mixed += toMix;
			samplesLeft -= toMix;
		}

		sample = buffer[0];

		if (player.record != 0)
		{
			for (_tmp_ in 0...size)
			{
				i = _tmp_;
				if (sample.l > 1.0)
				{
					sample.l = 1.0;
				}
				else if (sample.l < -1.0)
				{
					sample.l = -1.0;
				}

				if (sample.r > 1.0)
				{
					sample.r = 1.0;
				}
				else if (sample.r < -1.0)
				{
					sample.r = -1.0;
				}

				wave.writeShort(Std.int(sample.l * (sample.l < 0 ? 32768 : 32767)));
				wave.writeShort(Std.int(sample.r * (sample.r < 0 ? 32768 : 32767)));

				data.writeFloat(sample.l);
				data.writeFloat(sample.r);

				sample.l = sample.r = 0.0;
				sample = sample.next;
			}
		}
		else
		{
			for (_tmp_ in 0...size)
			{
				i = _tmp_;
				if (sample.l > 1.0)
				{
					sample.l = 1.0;
				}
				else if (sample.l < -1.0)
				{
					sample.l = -1.0;
				}

				if (sample.r > 1.0)
				{
					sample.r = 1.0;
				}
				else if (sample.r < -1.0)
				{
					sample.r = -1.0;
				}

				data.writeFloat(sample.l);
				data.writeFloat(sample.r);

				sample.l = sample.r = 0.0;
				sample = sample.next;
			}
		}
	}

	@:allow(neoart.flod.core)
	override function accurate(e:SampleDataEvent)
	{
		var chan:SBChannel, d1:Vector<Float>, d2:Vector<Float> = null, data = e
			.data, delta:Int, i:Int, mixed = 0, mixLen:Int, mixPos = 0, mixValue:Float, s1:SBSample, s2:SBSample, sample:Sample, size = bufferSize, toMix:Int, value:Float;

		if (completed != 0)
		{
			if (remains == 0)
				return;
			size = remains;
		}

		while (mixed < size)
		{
			if (samplesLeft == 0)
			{
				player.process();
				player.accurate();
				samplesLeft = samplesTick;

				if (completed != 0)
				{
					size = mixed + samplesTick;

					if (size > bufferSize)
					{
						remains = size - bufferSize;
						size = bufferSize;
					}
				}
			}

			toMix = samplesLeft;
			if ((mixed + toMix) >= size)
				toMix = size - mixed;
			mixLen = mixPos + toMix;
			chan = channels[0];

			while (chan != null)
			{
				if (chan.enabled == 0)
				{
					chan = chan.next;
					continue;
				}

				s1 = chan.sample;
				d1 = s1.data;
				s2 = chan.oldSample;
				if (s2 != null)
					d2 = s2.data;

				sample = buffer[mixPos];

				for (_tmp_ in mixPos...mixLen)
				{
					i = _tmp_;
					value = chan.mute != 0 ? 0.0 : d1[chan.pointer];
					value += (d1[chan.pointer + chan.dir] - value) * chan.fraction;

					if ((chan.fraction += chan.speed) >= 1.0)
					{
						delta = Std.int(chan.fraction);
						chan.fraction -= delta;

						if (chan.dir > 0)
						{
							chan.pointer += delta;

							if (chan.pointer > chan.length)
							{
								chan.fraction += chan.pointer - chan.length;
								chan.pointer = chan.length;
							}
						}
						else
						{
							chan.pointer -= delta;

							if (chan.pointer < chan.length)
							{
								chan.fraction += chan.length - chan.pointer;
								chan.pointer = chan.length;
							}
						}
					}

					if (chan.mixCounter == 0)
					{
						sample.l += value * chan.lvol;
						sample.r += value * chan.rvol;

						if (chan.volCounter != 0)
						{
							chan.lvol += chan.lvolDelta;
							chan.rvol += chan.rvolDelta;
							chan.volCounter--;
						}
						else if (chan.panCounter != 0)
						{
							chan.lpan += chan.lpanDelta;
							chan.rpan += chan.rpanDelta;
							chan.panCounter--;

							chan.lvol = chan.volume * chan.lpan;
							chan.rvol = chan.volume * chan.rpan;
						}
					}
					else
					{
						if (s2 != null)
						{
							mixValue = chan.mute != 0 ? 0.0 : d2[chan.oldPointer];
							mixValue += (d2[chan.oldPointer + chan.oldDir] - mixValue) * chan.oldFraction;

							if ((chan.oldFraction += chan.oldSpeed) > 1)
							{
								delta = Std.int(chan.oldFraction);
								chan.oldFraction -= delta;

								if (chan.oldDir > 0)
								{
									chan.oldPointer += delta;

									if (chan.oldPointer > chan.oldLength)
									{
										chan.oldFraction += chan.oldPointer - chan.oldLength;
										chan.oldPointer = chan.oldLength;
									}
								}
								else
								{
									chan.oldPointer -= delta;

									if (chan.oldPointer < chan.oldLength)
									{
										chan.oldFraction += chan.oldLength - chan.oldPointer;
										chan.oldPointer = chan.oldLength;
									}
								}
							}

							sample.l += (value * chan.lmixRampU) + (mixValue * chan.lmixRampD);
							sample.r += (value * chan.rmixRampU) + (mixValue * chan.rmixRampD);

							chan.lmixRampD -= chan.lmixDeltaD;
							chan.rmixRampD -= chan.rmixDeltaD;
						}
						else
						{
							sample.l += (value * chan.lmixRampU);
							sample.r += (value * chan.rmixRampU);
						}

						chan.lmixRampU += chan.lmixDeltaU;
						chan.rmixRampU += chan.rmixDeltaU;
						chan.mixCounter--;

						if (chan.oldPointer == chan.oldLength)
						{
							if (s2.loopMode == 0)
							{
								s2 = null;
								chan.oldPointer = 0;
							}
							else if (s2.loopMode == 1)
							{
								chan.oldPointer = s2.loopStart;
								chan.oldLength = s2.length;
							}
							else
							{
								if (chan.oldDir > 0)
								{
									chan.oldPointer = s2.length - 1;
									chan.oldLength = s2.loopStart;
									chan.oldDir = -1;
								}
								else
								{
									chan.oldFraction -= 1;
									chan.oldPointer = s2.loopStart;
									chan.oldLength = s2.length;
									chan.oldDir = 1;
								}
							}
						}
					}

					if (chan.pointer == chan.length)
					{
						if (s1.loopMode == 0)
						{
							chan.enabled = 0;
							break;
						}
						else if (s1.loopMode == 1)
						{
							chan.pointer = s1.loopStart;
							chan.length = s1.length;
						}
						else
						{
							if (chan.dir > 0)
							{
								chan.pointer = s1.length - 1;
								chan.length = s1.loopStart;
								chan.dir = -1;
							}
							else
							{
								chan.fraction -= 1;
								chan.pointer = s1.loopStart;
								chan.length = s1.length;
								chan.dir = 1;
							}
						}
					}
					sample = sample.next;
				}
				chan = chan.next;
			}

			mixPos = mixLen;
			mixed += toMix;
			samplesLeft -= toMix;
		}

		sample = buffer[0];

		if (player.record != 0)
		{
			for (_tmp_ in 0...size)
			{
				i = _tmp_;
				if (sample.l > 1.0)
				{
					sample.l = 1.0;
				}
				else if (sample.l < -1.0)
				{
					sample.l = -1.0;
				}

				if (sample.r > 1.0)
				{
					sample.r = 1.0;
				}
				else if (sample.r < -1.0)
				{
					sample.r = -1.0;
				}

				wave.writeShort(Std.int(sample.l * (sample.l < 0 ? 32768 : 32767)));
				wave.writeShort(Std.int(sample.r * (sample.r < 0 ? 32768 : 32767)));

				data.writeFloat(sample.l);
				data.writeFloat(sample.r);

				sample.l = sample.r = 0.0;
				sample = sample.next;
			}
		}
		else
		{
			for (_tmp_ in 0...size)
			{
				i = _tmp_;
				if (sample.l > 1.0)
				{
					sample.l = 1.0;
				}
				else if (sample.l < -1.0)
				{
					sample.l = -1.0;
				}

				if (sample.r > 1.0)
				{
					sample.r = 1.0;
				}
				else if (sample.r < -1.0)
				{
					sample.r = -1.0;
				}

				data.writeFloat(sample.l);
				data.writeFloat(sample.r);

				sample.l = sample.r = 0.0;
				sample = sample.next;
			}
		}
	}
}
