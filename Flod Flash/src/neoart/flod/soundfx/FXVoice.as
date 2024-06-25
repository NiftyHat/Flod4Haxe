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
package neoart.flod.soundfx {
  import neoart.flod.core.*;

  public final class FXVoice {
    
    internal var index       : int;
    internal var next        : FXVoice;
    internal var channel     : AmigaChannel;
    internal var sample      : AmigaSample;
    internal var enabled     : int;
    internal var period      : int;
    internal var effect      : int;
    internal var param       : int;
    internal var volume      : int;
    internal var last        : int;
    internal var slideCtr    : int;
    internal var slideDir    : int;
    internal var slideParam  : int;
    internal var slidePeriod : int;
    internal var slideSpeed  : int;
    internal var stepPeriod  : int;
    internal var stepSpeed   : int;
    internal var stepWanted  : int;

    public function FXVoice(index:int) {
      this.index = index;
    }

    internal function initialize():void {
      channel     = null;
      sample      = null;
      enabled     = 0;
      period      = 0;
      effect      = 0;
      param       = 0;
      volume      = 0;
      last        = 0;
      slideCtr    = 0;
      slideDir    = 0;
      slideParam  = 0;
      slidePeriod = 0;
      slideSpeed  = 0;
      stepPeriod  = 0;
      stepSpeed   = 0;
      stepWanted  = 0;
    }
  }
}