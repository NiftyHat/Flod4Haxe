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
package neoart.flod.fred ;
  import neoart.flod.core.*;

   final class FEVoice {
    
    @:allow(neoart.flod.fred) var index         : Int = 0;
    @:allow(neoart.flod.fred) var bitFlag       : Int = 0;
    @:allow(neoart.flod.fred) var next          : FEVoice;
    @:allow(neoart.flod.fred) var channel       : AmigaChannel;
    @:allow(neoart.flod.fred) var sample        : FESample;
    @:allow(neoart.flod.fred) var trackPos      : Int = 0;
    @:allow(neoart.flod.fred) var patternPos    : Int = 0;
    @:allow(neoart.flod.fred) var tick          : Int = 0;
    @:allow(neoart.flod.fred) var busy          : Int = 0;
    @:allow(neoart.flod.fred) var synth         : Int = 0;
    @:allow(neoart.flod.fred) var note          : Int = 0;
    @:allow(neoart.flod.fred) var period        : Int = 0;
    @:allow(neoart.flod.fred) var volume        : Int = 0;
    @:allow(neoart.flod.fred) var envelopePos   : Int = 0;
    @:allow(neoart.flod.fred) var sustainTime   : Int = 0;
    @:allow(neoart.flod.fred) var arpeggioPos   : Int = 0;
    @:allow(neoart.flod.fred) var arpeggioSpeed : Int = 0;
    @:allow(neoart.flod.fred) var portamento    : Int = 0;
    @:allow(neoart.flod.fred) var portaCounter  : Int = 0;
    @:allow(neoart.flod.fred) var portaDelay    : Int = 0;
    @:allow(neoart.flod.fred) var portaFlag     : Int = 0;
    @:allow(neoart.flod.fred) var portaLimit    : Int = 0;
    @:allow(neoart.flod.fred) var portaNote     : Int = 0;
    @:allow(neoart.flod.fred) var portaPeriod   : Int = 0;
    @:allow(neoart.flod.fred) var portaSpeed    : Int = 0;
    @:allow(neoart.flod.fred) var vibrato       : Int = 0;
    @:allow(neoart.flod.fred) var vibratoDelay  : Int = 0;
    @:allow(neoart.flod.fred) var vibratoDepth  : Int = 0;
    @:allow(neoart.flod.fred) var vibratoFlag   : Int = 0;
    @:allow(neoart.flod.fred) var vibratoSpeed  : Int = 0;
    @:allow(neoart.flod.fred) var pulseCounter  : Int = 0;
    @:allow(neoart.flod.fred) var pulseDelay    : Int = 0;
    @:allow(neoart.flod.fred) var pulseDir      : Int = 0;
    @:allow(neoart.flod.fred) var pulsePos      : Int = 0;
    @:allow(neoart.flod.fred) var pulseSpeed    : Int = 0;
    @:allow(neoart.flod.fred) var blendCounter  : Int = 0;
    @:allow(neoart.flod.fred) var blendDelay    : Int = 0;
    @:allow(neoart.flod.fred) var blendDir      : Int = 0;
    @:allow(neoart.flod.fred) var blendPos      : Int = 0;

    public function new(index:Int, bitFlag:Int) {
      this.index = index;
      this.bitFlag = bitFlag;
    }

    @:allow(neoart.flod.fred) function initialize() {
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
