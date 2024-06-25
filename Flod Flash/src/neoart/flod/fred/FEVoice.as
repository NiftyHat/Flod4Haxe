/*
  Flod 4.1
  2012/04/30
  Christian Corti
  Neoart Costa Rica

  Last Update: Flod 4.0 - 2012/02/16

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
  LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR
  IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

  This work is licensed under the Creative Commons Attribution-Noncommercial-Share Alike 3.0 Unported License.
  To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/3.0/ or send a letter to
  Creative Commons, 171 Second Street, Suite 300, San Francisco, California, 94105, USA.
*/
package neoart.flod.fred {
  import neoart.flod.core.*;

  public final class FEVoice {
    
    internal var index         : int;
    internal var bitFlag       : int;
    internal var next          : FEVoice;
    internal var channel       : AmigaChannel;
    internal var sample        : FESample;
    internal var trackPos      : int;
    internal var patternPos    : int;
    internal var tick          : int;
    internal var busy          : int;
    internal var synth         : int;
    internal var note          : int;
    internal var period        : int;
    internal var volume        : int;
    internal var envelopePos   : int;
    internal var sustainTime   : int;
    internal var arpeggioPos   : int;
    internal var arpeggioSpeed : int;
    internal var portamento    : int;
    internal var portaCounter  : int;
    internal var portaDelay    : int;
    internal var portaFlag     : int;
    internal var portaLimit    : int;
    internal var portaNote     : int;
    internal var portaPeriod   : int;
    internal var portaSpeed    : int;
    internal var vibrato       : int;
    internal var vibratoDelay  : int;
    internal var vibratoDepth  : int;
    internal var vibratoFlag   : int;
    internal var vibratoSpeed  : int;
    internal var pulseCounter  : int;
    internal var pulseDelay    : int;
    internal var pulseDir      : int;
    internal var pulsePos      : int;
    internal var pulseSpeed    : int;
    internal var blendCounter  : int;
    internal var blendDelay    : int;
    internal var blendDir      : int;
    internal var blendPos      : int;

    public function FEVoice(index:int, bitFlag:int) {
      this.index = index;
      this.bitFlag = bitFlag;
    }

    internal function initialize():void {
      channel       = null;
      sample        = null;
      trackPos      = 0;
      patternPos    = 0;
      tick          = 1;
      busy          = 1;
      note          = 0;
      period        = 0;
      volume        = 0;
      envelopePos   = 0;
      sustainTime   = 0;
      arpeggioPos   = 0;
      arpeggioSpeed = 0;
      portamento    = 0;
      portaCounter  = 0;
      portaDelay    = 0;
      portaFlag     = 0;
      portaLimit    = 0;
      portaNote     = 0;
      portaPeriod   = 0;
      portaSpeed    = 0;
      vibrato       = 0;
      vibratoDelay  = 0;
      vibratoDepth  = 0;
      vibratoFlag   = 0;
      vibratoSpeed  = 0;
      pulseCounter  = 0;
      pulseDelay    = 0;
      pulseDir      = 0;
      pulsePos      = 0;
      pulseSpeed    = 0;
      blendCounter  = 0;
      blendDelay    = 0;
      blendDir      = 0;
      blendPos      = 0;
    }
  }
}