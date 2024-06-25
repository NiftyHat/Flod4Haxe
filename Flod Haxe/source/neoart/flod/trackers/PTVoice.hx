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
package neoart.flod.trackers ;
  import neoart.flod.core.*;

   final class PTVoice {
    
    @:allow(neoart.flod.trackers) var index        : Int = 0;
    @:allow(neoart.flod.trackers) var next         : PTVoice;
    @:allow(neoart.flod.trackers) var channel      : AmigaChannel;
    @:allow(neoart.flod.trackers) var sample       : PTSample;
    @:allow(neoart.flod.trackers) var enabled      : Int = 0;
    @:allow(neoart.flod.trackers) var loopCtr      : Int = 0;
    @:allow(neoart.flod.trackers) var loopPos      : Int = 0;
    @:allow(neoart.flod.trackers) var step         : Int = 0;
    @:allow(neoart.flod.trackers) var period       : Int = 0;
    @:allow(neoart.flod.trackers) var effect       : Int = 0;
    @:allow(neoart.flod.trackers) var param        : Int = 0;
    @:allow(neoart.flod.trackers) var volume       : Int = 0;
    @:allow(neoart.flod.trackers) var pointer      : Int = 0;
    @:allow(neoart.flod.trackers) var length       : Int = 0;
    @:allow(neoart.flod.trackers) var loopPtr      : Int = 0;
    @:allow(neoart.flod.trackers) var repeat       : Int = 0;
    @:allow(neoart.flod.trackers) var finetune     : Int = 0;
    @:allow(neoart.flod.trackers) var offset       : Int = 0;
    @:allow(neoart.flod.trackers) var portaDir     : Int = 0;
    @:allow(neoart.flod.trackers) var portaPeriod  : Int = 0;
    @:allow(neoart.flod.trackers) var portaSpeed   : Int = 0;
    @:allow(neoart.flod.trackers) var glissando    : Int = 0;
    @:allow(neoart.flod.trackers) var tremoloParam : Int = 0;
    @:allow(neoart.flod.trackers) var tremoloPos   : Int = 0;
    @:allow(neoart.flod.trackers) var tremoloWave  : Int = 0;
    @:allow(neoart.flod.trackers) var vibratoParam : Int = 0;
    @:allow(neoart.flod.trackers) var vibratoPos   : Int = 0;
    @:allow(neoart.flod.trackers) var vibratoWave  : Int = 0;
    @:allow(neoart.flod.trackers) var funkPos      : Int = 0;
    @:allow(neoart.flod.trackers) var funkSpeed    : Int = 0;
    @:allow(neoart.flod.trackers) var funkWave     : Int = 0;

    public function new(index:Int) {
      this.index = index;
    }

    @:allow(neoart.flod.trackers) function initialize() {
      channel      = null;
      sample       = null;
      enabled      = 0;
      loopCtr      = 0;
      loopPos      = 0;
      step         = 0;
      period       = 0;
      effect       = 0;
      param        = 0;
      volume       = 0;
      pointer      = 0;
      length       = 0;
      loopPtr      = 0;
      repeat       = 0;
      finetune     = 0;
      offset       = 0;
      portaDir     = 0;
      portaPeriod  = 0;
      portaSpeed   = 0;
      glissando    = 0;
      tremoloParam = 0;
      tremoloPos   = 0;
      tremoloWave  = 0;
      vibratoParam = 0;
      vibratoPos   = 0;
      vibratoWave  = 0;
      funkPos      = 0;
      funkSpeed    = 0;
      funkWave     = 0;
    }
  }
