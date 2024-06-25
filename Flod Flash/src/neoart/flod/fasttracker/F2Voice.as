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
package neoart.flod.fasttracker {
  import neoart.flod.core.*;

  public final class F2Voice {
    
    internal var index          : int;
    internal var next           : F2Voice;
    internal var flags          : int;
    internal var delay          : int;
    internal var channel        : SBChannel;
    internal var patternLoop    : int;
    internal var patternLoopRow : int;
    internal var playing        : F2Instrument;
    internal var note           : int;
    internal var keyoff         : int;
    internal var period         : int;
    internal var finetune       : int;
    internal var arpDelta       : int;
    internal var vibDelta       : int;
    internal var instrument     : F2Instrument;
    internal var autoVibratoPos : int;
    internal var autoSweep      : int;
    internal var autoSweepPos   : int;
    internal var sample         : F2Sample;
    internal var sampleOffset   : int;
    internal var volume         : int;
    internal var volEnabled     : int;
    internal var volEnvelope    : F2Envelope;
    internal var volDelta       : int;
    internal var volSlide       : int;
    internal var volSlideMaster : int;
    internal var fineSlideU     : int;
    internal var fineSlideD     : int;
    internal var fadeEnabled    : int;
    internal var fadeDelta      : int;
    internal var fadeVolume     : int;
    internal var panning        : int;
    internal var panEnabled     : int;
    internal var panEnvelope    : F2Envelope;
    internal var panSlide       : int;
    internal var portaU         : int;
    internal var portaD         : int;
    internal var finePortaU     : int;
    internal var finePortaD     : int;
    internal var xtraPortaU     : int;
    internal var xtraPortaD     : int;
    internal var portaPeriod    : int;
    internal var portaSpeed     : int;
    internal var glissando      : int;
    internal var glissPeriod    : int;
    internal var vibratoPos     : int;
    internal var vibratoSpeed   : int;
    internal var vibratoDepth   : int;
    internal var vibratoReset   : int;
    internal var tremoloPos     : int;
    internal var tremoloSpeed   : int;
    internal var tremoloDepth   : int;
    internal var waveControl    : int;
    internal var tremorPos      : int;
    internal var tremorOn       : int;
    internal var tremorOff      : int;
    internal var tremorVolume   : int;
    internal var retrigx        : int;
    internal var retrigy        : int;

    public function F2Voice(index:int) {
      this.index = index;
      volEnvelope = new F2Envelope();
      panEnvelope = new F2Envelope();
    }

    internal function reset():void {
      volume   = sample.volume;
      panning  = sample.panning;
      finetune = (sample.finetune >> 3) << 2;
      keyoff   = 0;
      volDelta = 0;

      fadeEnabled = 0;      
      fadeDelta   = 0;
      fadeVolume  = 65536;

      autoVibratoPos = 0;
      autoSweep      = 1;
      autoSweepPos   = 0;
      vibDelta       = 0;
      portaPeriod    = 0;
      vibratoReset   = 0;

      if ((waveControl & 15) < 4) vibratoPos = 0;
      if ((waveControl >> 4) < 4) tremoloPos = 0;
    }

    internal function autoVibrato():int {
      var delta:int;

      autoVibratoPos = (autoVibratoPos + playing.vibratoSpeed) & 255;

      switch (playing.vibratoType) {
        case 0:
          delta = AUTOVIBRATO[autoVibratoPos];
          break;
        case 1:
          if (autoVibratoPos < 128) {
			  delta = -64;
		  }
            else {
				delta = 64;
		  }
          break;
        case 2:
          delta = ((64 + (autoVibratoPos >> 1)) & 127) - 64;
          break;
        case 3:
          delta = ((64 - (autoVibratoPos >> 1)) & 127) - 64;
          break;
      }

      delta *= playing.vibratoDepth;

      if (autoSweep) {
        if (!playing.vibratoSweep) {
          autoSweep = 0;
        } else {
          if (autoSweepPos > playing.vibratoSweep) {
            if (autoSweepPos & 2) delta *= (autoSweepPos / playing.vibratoSweep);
            autoSweep = 0;
          } else {
            delta *= (++autoSweepPos / playing.vibratoSweep);
          }
        }
      }

      flags |= F2Player.UPDATE_PERIOD;
      return (delta >> 6);
    }

    internal function tonePortamento():void {
      if (!glissPeriod) glissPeriod = period;

      if (period < portaPeriod) {
        glissPeriod += portaSpeed << 2;

        if (!glissando) {
			period = glissPeriod;
		}
          else {
			  period = Math.round(glissPeriod / 64) << 6;
		  }

        if (period >= portaPeriod) {
          period = portaPeriod;
          glissPeriod = portaPeriod = 0;
        }
      } else if (period > portaPeriod) {
        glissPeriod -= portaSpeed << 2;

        if (!glissando) {period = glissPeriod;}
          else{ period = Math.round(glissPeriod / 64) << 6;}

        if (period <= portaPeriod) {
          period = portaPeriod;
          glissPeriod = portaPeriod = 0;
        }
      }

      flags |= F2Player.UPDATE_PERIOD;
    }

    internal function tremolo():void {
      var delta:int = 255, position:int = tremoloPos & 31;

      switch ((waveControl >> 4) & 3) {
        case 0:
          delta = VIBRATO[position];
          break;
        case 1:
          delta = position << 3;
          break;
      }

      volDelta = (delta * tremoloDepth) >> 6;
      if (tremoloPos > 31) volDelta = -volDelta;
      tremoloPos = (tremoloPos + tremoloSpeed) & 63;

      flags |= F2Player.UPDATE_VOLUME;
    }

    internal function tremor():void {
      if (tremorPos == tremorOn) {
        tremorVolume = volume;
        volume = 0;
        flags |= F2Player.UPDATE_VOLUME;
      } else if (tremorPos == tremorOff) {
        tremorPos = 0;
        volume = tremorVolume;
        flags |= F2Player.UPDATE_VOLUME;
      }

      ++tremorPos;
    }

    internal function vibrato():void {
      var delta:int = 255, position:int = vibratoPos & 31;

      switch (waveControl & 3) {
        case 0:
          delta = VIBRATO[position];
          break;
        case 1:
          delta = position << 3;
          if (vibratoPos > 31) delta = 255 - delta;
          break;
      }

      vibDelta = (delta * vibratoDepth) >> 7;
      if (vibratoPos > 31) vibDelta = -vibDelta;
      vibratoPos = (vibratoPos + vibratoSpeed) & 63;

      flags |= F2Player.UPDATE_PERIOD;
    }

    
    private static const AUTOVIBRATO : Vector.<int> = Vector.<int>([
          0, -2, -3, -5, -6, -8, -9,-11,-12,-14,-16,-17,-19,-20,-22,-23,
        -24,-26,-27,-29,-30,-32,-33,-34,-36,-37,-38,-39,-41,-42,-43,-44,
        -45,-46,-47,-48,-49,-50,-51,-52,-53,-54,-55,-56,-56,-57,-58,-59,
        -59,-60,-60,-61,-61,-62,-62,-62,-63,-63,-63,-64,-64,-64,-64,-64,
        -64,-64,-64,-64,-64,-64,-63,-63,-63,-62,-62,-62,-61,-61,-60,-60,
        -59,-59,-58,-57,-56,-56,-55,-54,-53,-52,-51,-50,-49,-48,-47,-46,
        -45,-44,-43,-42,-41,-39,-38,-37,-36,-34,-33,-32,-30,-29,-27,-26,
        -24,-23,-22,-20,-19,-17,-16,-14,-12,-11, -9, -8, -6, -5, -3, -2,
          0,  2,  3,  5,  6,  8,  9, 11, 12, 14, 16, 17, 19, 20, 22, 23,
         24, 26, 27, 29, 30, 32, 33, 34, 36, 37, 38, 39, 41, 42, 43, 44,
         45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 56, 57, 58, 59,
         59, 60, 60, 61, 61, 62, 62, 62, 63, 63, 63, 64, 64, 64, 64, 64,
         64, 64, 64, 64, 64, 64, 63, 63, 63, 62, 62, 62, 61, 61, 60, 60,
         59, 59, 58, 57, 56, 56, 55, 54, 53, 52, 51, 50, 49, 48, 47, 46,
         45, 44, 43, 42, 41, 39, 38, 37, 36, 34, 33, 32, 30, 29, 27, 26,
         24, 23, 22, 20, 19, 17, 16, 14, 12, 11,  9,  8,  6,  5,  3,  2]);

    private static const VIBRATO : Vector.<int> = Vector.<int>([
          0, 24, 49, 74, 97,120,141,161,180,197,212,224,235,244,250,253,
        255,253,250,244,235,224,212,197,180,161,141,120, 97, 74, 49, 24]);
  }
}