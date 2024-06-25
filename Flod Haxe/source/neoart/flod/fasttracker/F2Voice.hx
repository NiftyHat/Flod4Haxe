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
package neoart.flod.fasttracker;

import neoart.flod.core.*;
import flash.Vector;

final class F2Voice
{
	@:allow(neoart.flod.fasttracker) var index:Int = 0;
	@:allow(neoart.flod.fasttracker) var next:F2Voice;
	@:allow(neoart.flod.fasttracker) var flags:Int = 0;
	@:allow(neoart.flod.fasttracker) var delay:Int = 0;
	@:allow(neoart.flod.fasttracker) var channel:SBChannel;
	@:allow(neoart.flod.fasttracker) var patternLoop:Int = 0;
	@:allow(neoart.flod.fasttracker) var patternLoopRow:Int = 0;
	@:allow(neoart.flod.fasttracker) var playing:F2Instrument;
	@:allow(neoart.flod.fasttracker) var note:Int = 0;
	@:allow(neoart.flod.fasttracker) var keyoff:Int = 0;
	@:allow(neoart.flod.fasttracker) var period:Int = 0;
	@:allow(neoart.flod.fasttracker) var finetune:Int = 0;
	@:allow(neoart.flod.fasttracker) var arpDelta:Int = 0;
	@:allow(neoart.flod.fasttracker) var vibDelta:Int = 0;
	@:allow(neoart.flod.fasttracker) var instrument:F2Instrument;
	@:allow(neoart.flod.fasttracker) var autoVibratoPos:Int = 0;
	@:allow(neoart.flod.fasttracker) var autoSweep:Int = 0;
	@:allow(neoart.flod.fasttracker) var autoSweepPos:Int = 0;
	@:allow(neoart.flod.fasttracker) var sample:F2Sample;
	@:allow(neoart.flod.fasttracker) var sampleOffset:Int = 0;
	@:allow(neoart.flod.fasttracker) var volume:Int = 0;
	@:allow(neoart.flod.fasttracker) var volEnabled:Int = 0;
	@:allow(neoart.flod.fasttracker) var volEnvelope:F2Envelope;
	@:allow(neoart.flod.fasttracker) var volDelta:Int = 0;
	@:allow(neoart.flod.fasttracker) var volSlide:Int = 0;
	@:allow(neoart.flod.fasttracker) var volSlideMaster:Int = 0;
	@:allow(neoart.flod.fasttracker) var fineSlideU:Int = 0;
	@:allow(neoart.flod.fasttracker) var fineSlideD:Int = 0;
	@:allow(neoart.flod.fasttracker) var fadeEnabled:Int = 0;
	@:allow(neoart.flod.fasttracker) var fadeDelta:Int = 0;
	@:allow(neoart.flod.fasttracker) var fadeVolume:Int = 0;
	@:allow(neoart.flod.fasttracker) var panning:Int = 0;
	@:allow(neoart.flod.fasttracker) var panEnabled:Int = 0;
	@:allow(neoart.flod.fasttracker) var panEnvelope:F2Envelope;
	@:allow(neoart.flod.fasttracker) var panSlide:Int = 0;
	@:allow(neoart.flod.fasttracker) var portaU:Int = 0;
	@:allow(neoart.flod.fasttracker) var portaD:Int = 0;
	@:allow(neoart.flod.fasttracker) var finePortaU:Int = 0;
	@:allow(neoart.flod.fasttracker) var finePortaD:Int = 0;
	@:allow(neoart.flod.fasttracker) var xtraPortaU:Int = 0;
	@:allow(neoart.flod.fasttracker) var xtraPortaD:Int = 0;
	@:allow(neoart.flod.fasttracker) var portaPeriod:Int = 0;
	@:allow(neoart.flod.fasttracker) var portaSpeed:Int = 0;
	@:allow(neoart.flod.fasttracker) var glissando:Int = 0;
	@:allow(neoart.flod.fasttracker) var glissPeriod:Int = 0;
	@:allow(neoart.flod.fasttracker) var vibratoPos:Int = 0;
	@:allow(neoart.flod.fasttracker) var vibratoSpeed:Int = 0;
	@:allow(neoart.flod.fasttracker) var vibratoDepth:Int = 0;
	@:allow(neoart.flod.fasttracker) var vibratoReset:Int = 0;
	@:allow(neoart.flod.fasttracker) var tremoloPos:Int = 0;
	@:allow(neoart.flod.fasttracker) var tremoloSpeed:Int = 0;
	@:allow(neoart.flod.fasttracker) var tremoloDepth:Int = 0;
	@:allow(neoart.flod.fasttracker) var waveControl:Int = 0;
	@:allow(neoart.flod.fasttracker) var tremorPos:Int = 0;
	@:allow(neoart.flod.fasttracker) var tremorOn:Int = 0;
	@:allow(neoart.flod.fasttracker) var tremorOff:Int = 0;
	@:allow(neoart.flod.fasttracker) var tremorVolume:Int = 0;
	@:allow(neoart.flod.fasttracker) var retrigx:Int = 0;
	@:allow(neoart.flod.fasttracker) var retrigy:Int = 0;

	public function new(index:Int)
	{
		this.index = index;
		volEnvelope = new F2Envelope();
		panEnvelope = new F2Envelope();
	}

	@:allow(neoart.flod.fasttracker) function reset()
	{
		volume = sample.volume;
		panning = sample.panning;
		finetune = (sample.finetune >> 3) << 2;
		keyoff = 0;
		volDelta = 0;

		fadeEnabled = 0;
		fadeDelta = 0;
		fadeVolume = 65536;

		autoVibratoPos = 0;
		autoSweep = 1;
		autoSweepPos = 0;
		vibDelta = 0;
		portaPeriod = 0;
		vibratoReset = 0;

		if ((waveControl & 15) < 4)
			vibratoPos = 0;
		if ((waveControl >> 4) < 4)
			tremoloPos = 0;
	}

	@:allow(neoart.flod.fasttracker) function autoVibrato():Int
	{
		var delta = 0;

		autoVibratoPos = (autoVibratoPos + playing.vibratoSpeed) & 255;

		switch (playing.vibratoType)
		{
			case 0:
				delta = AUTOVIBRATO[autoVibratoPos];

			case 1:
				if (autoVibratoPos < 128)
				{
					delta = -64;
				}
				else
				{
					delta = 64;
				}

			case 2:
				delta = ((64 + (autoVibratoPos >> 1)) & 127) - 64;

			case 3:
				delta = ((64 - (autoVibratoPos >> 1)) & 127) - 64;
		}

		delta *= playing.vibratoDepth;

		if (autoSweep != 0)
		{
			if (playing.vibratoSweep == 0)
			{
				autoSweep = 0;
			}
			else
			{
				if (autoSweepPos > playing.vibratoSweep)
				{
					if ((autoSweepPos & 2) != 0)
						delta = Std.int(delta * Std.int(autoSweepPos / playing.vibratoSweep));
					autoSweep = 0;
				}
				else
				{
					delta = Std.int(delta * Std.int(++autoSweepPos / playing.vibratoSweep));
				}
			}
		}

		flags |= F2Player.UPDATE_PERIOD;
		return (delta >> 6);
	}

	@:allow(neoart.flod.fasttracker) function tonePortamento()
	{
		if (glissPeriod == 0)
			glissPeriod = period;

		if (period < portaPeriod)
		{
			glissPeriod += portaSpeed << 2;

			if (glissando == 0)
			{
				period = glissPeriod;
			}
			else
			{
				period = Math.round(glissPeriod / 64) << 6;
			}

			if (period >= portaPeriod)
			{
				period = portaPeriod;
				glissPeriod = portaPeriod = 0;
			}
		}
		else if (period > portaPeriod)
		{
			glissPeriod -= portaSpeed << 2;

			if (glissando == 0)
			{
				period = glissPeriod;
			}
			else
			{
				period = Math.round(glissPeriod / 64) << 6;
			}

			if (period <= portaPeriod)
			{
				period = portaPeriod;
				glissPeriod = portaPeriod = 0;
			}
		}

		flags |= F2Player.UPDATE_PERIOD;
	}

	@:allow(neoart.flod.fasttracker) function tremolo()
	{
		var delta = 255, position = tremoloPos & 31;

		switch ((waveControl >> 4) & 3)
		{
			case 0:
				delta = VIBRATO[position];

			case 1:
				delta = position << 3;
		}

		volDelta = (delta * tremoloDepth) >> 6;
		if (tremoloPos > 31)
			volDelta = -volDelta;
		tremoloPos = (tremoloPos + tremoloSpeed) & 63;

		flags |= F2Player.UPDATE_VOLUME;
	}

	@:allow(neoart.flod.fasttracker) function tremor()
	{
		if (tremorPos == tremorOn)
		{
			tremorVolume = volume;
			volume = 0;
			flags |= F2Player.UPDATE_VOLUME;
		}
		else if (tremorPos == tremorOff)
		{
			tremorPos = 0;
			volume = tremorVolume;
			flags |= F2Player.UPDATE_VOLUME;
		}

		++tremorPos;
	}

	@:allow(neoart.flod.fasttracker) function vibrato()
	{
		var delta = 255, position = vibratoPos & 31;

		switch (waveControl & 3)
		{
			case 0:
				delta = VIBRATO[position];

			case 1:
				delta = position << 3;
				if (vibratoPos > 31)
					delta = 255 - delta;
		}

		vibDelta = (delta * vibratoDepth) >> 7;
		if (vibratoPos > 31)
			vibDelta = -vibDelta;
		vibratoPos = (vibratoPos + vibratoSpeed) & 63;

		flags |= F2Player.UPDATE_PERIOD;
	}

	static final AUTOVIBRATO:Vector<Int> = Vector.ofArray([
		0, -2, -3, -5, -6, -8, -9, -11, -12, -14, -16, -17, -19, -20, -22, -23, -24, -26, -27, -29, -30, -32, -33, -34, -36, -37, -38, -39, -41, -42, -43, -44,
		-45, -46, -47, -48, -49, -50, -51, -52, -53, -54, -55, -56, -56, -57, -58, -59, -59, -60, -60, -61, -61, -62, -62, -62, -63, -63, -63, -64, -64, -64,
		-64, -64, -64, -64, -64, -64, -64, -64, -63, -63, -63, -62, -62, -62, -61, -61, -60, -60, -59, -59, -58, -57, -56, -56, -55, -54, -53, -52, -51, -50,
		-49, -48, -47, -46, -45, -44, -43, -42, -41, -39, -38, -37, -36, -34, -33, -32, -30, -29, -27, -26, -24, -23, -22, -20, -19, -17, -16, -14, -12, -11,
		-9, -8, -6, -5, -3, -2, 0, 2, 3, 5, 6, 8, 9, 11, 12, 14, 16, 17, 19, 20, 22, 23, 24, 26, 27, 29, 30, 32, 33, 34, 36, 37, 38, 39, 41, 42, 43, 44, 45,
		46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 56, 57, 58, 59, 59, 60, 60, 61, 61, 62, 62, 62, 63, 63, 63, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 63,
		63, 63, 62, 62, 62, 61, 61, 60, 60, 59, 59, 58, 57, 56, 56, 55, 54, 53, 52, 51, 50, 49, 48, 47, 46, 45, 44, 43, 42, 41, 39, 38, 37, 36, 34, 33, 32, 30,
		29, 27, 26, 24, 23, 22, 20, 19, 17, 16, 14, 12, 11, 9, 8, 6, 5, 3, 2
	]);
	static final VIBRATO:Vector<Int> = Vector.ofArray([
		0, 24, 49, 74, 97, 120, 141, 161, 180, 197, 212, 224, 235, 244, 250, 253, 255, 253, 250, 244, 235, 224, 212, 197, 180, 161, 141, 120, 97, 74, 49, 24
	]);
}
