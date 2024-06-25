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
package neoart.flod.trackers {
  import neoart.flod.core.*;

  public final class PTVoice {
    
    internal var index        : int;
    internal var next         : PTVoice;
    internal var channel      : AmigaChannel;
    internal var sample       : PTSample;
    internal var enabled      : int;
    internal var loopCtr      : int;
    internal var loopPos      : int;
    internal var step         : int;
    internal var period       : int;
    internal var effect       : int;
    internal var param        : int;
    internal var volume       : int;
    internal var pointer      : int;
    internal var length       : int;
    internal var loopPtr      : int;
    internal var repeat       : int;
    internal var finetune     : int;
    internal var offset       : int;
    internal var portaDir     : int;
    internal var portaPeriod  : int;
    internal var portaSpeed   : int;
    internal var glissando    : int;
    internal var tremoloParam : int;
    internal var tremoloPos   : int;
    internal var tremoloWave  : int;
    internal var vibratoParam : int;
    internal var vibratoPos   : int;
    internal var vibratoWave  : int;
    internal var funkPos      : int;
    internal var funkSpeed    : int;
    internal var funkWave     : int;

    public function PTVoice(index:int) {
      this.index = index;
    }

    internal function initialize():void {
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
}