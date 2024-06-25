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

   final class HMVoice {
    
    @:allow(neoart.flod.trackers) var index        : Int = 0;
    @:allow(neoart.flod.trackers) var next         : HMVoice;
    @:allow(neoart.flod.trackers) var channel      : AmigaChannel;
    @:allow(neoart.flod.trackers) var sample       : HMSample;
    @:allow(neoart.flod.trackers) var enabled      : Int = 0;
    @:allow(neoart.flod.trackers) var period       : Int = 0;
    @:allow(neoart.flod.trackers) var effect       : Int = 0;
    @:allow(neoart.flod.trackers) var param        : Int = 0;
    @:allow(neoart.flod.trackers) var volume1      : Int = 0;
    @:allow(neoart.flod.trackers) var volume2      : Int = 0;
    @:allow(neoart.flod.trackers) var handler      : Int = 0;
    @:allow(neoart.flod.trackers) var portaDir     : Int = 0;
    @:allow(neoart.flod.trackers) var portaPeriod  : Int = 0;
    @:allow(neoart.flod.trackers) var portaSpeed   : Int = 0;
    @:allow(neoart.flod.trackers) var vibratoPos   : Int = 0;
    @:allow(neoart.flod.trackers) var vibratoSpeed : Int = 0;
    @:allow(neoart.flod.trackers) var wavePos      : Int = 0;

    public function new(index:Int) {
      this.index = index;
    }

    @:allow(neoart.flod.trackers) function initialize() {
      channel      = null;
      sample       = null;
      enabled      = 0;
      period       = 0;
      effect       = 0;
      param        = 0;
      volume1      = 0;
      volume2      = 0;
      handler      = 0;
      portaDir     = 0;
      portaPeriod  = 0;
      portaSpeed   = 0;
      vibratoPos   = 0;
      vibratoSpeed = 0;
      wavePos      = 0;
    }
  }
