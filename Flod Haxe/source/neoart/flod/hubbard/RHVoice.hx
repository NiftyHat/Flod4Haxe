/*
  Flod 4.1
  2012/04/30
  Christian Corti
  Neoart Costa Rica

  Last Update: Flod 4.0 - 2012/02/12

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
  LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR
  IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

  This work is licensed under the Creative Commons Attribution-Noncommercial-Share Alike 3.0 Unported License.
  To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/3.0/ or send a letter to
  Creative Commons, 171 Second Street, Suite 300, San Francisco, California, 94105, USA.
*/
package neoart.flod.hubbard ;
  import neoart.flod.core.*;

   final class RHVoice {
    
    @:allow(neoart.flod.hubbard) var index      : Int = 0;
    @:allow(neoart.flod.hubbard) var bitFlag    : Int = 0;
    @:allow(neoart.flod.hubbard) var next       : RHVoice;
    @:allow(neoart.flod.hubbard) var channel    : AmigaChannel;
    @:allow(neoart.flod.hubbard) var sample     : RHSample;
    @:allow(neoart.flod.hubbard) var trackPtr   : Int = 0;
    @:allow(neoart.flod.hubbard) var trackPos   : Int = 0;
    @:allow(neoart.flod.hubbard) var patternPos : Int = 0;
    @:allow(neoart.flod.hubbard) var tick       : Int = 0;
    @:allow(neoart.flod.hubbard) var busy       : Int = 0;
    @:allow(neoart.flod.hubbard) var flags      : Int = 0;
    @:allow(neoart.flod.hubbard) var note       : Int = 0;
    @:allow(neoart.flod.hubbard) var period     : Int = 0;
    @:allow(neoart.flod.hubbard) var volume     : Int = 0;
    @:allow(neoart.flod.hubbard) var portaSpeed : Int = 0;
    @:allow(neoart.flod.hubbard) var vibratoPtr : Int = 0;
    @:allow(neoart.flod.hubbard) var vibratoPos : Int = 0;
    @:allow(neoart.flod.hubbard) var synthPos   : Int = 0;

    public function new(index:Int, bitFlag:Int) {
      this.index = index;
      this.bitFlag = bitFlag;
    }

    @:allow(neoart.flod.hubbard) function initialize() {
      channel    = null;
      sample     = null;
      trackPtr   = 0;
      trackPos   = 0;
      patternPos = 0;
      tick       = 1;
      busy       = 1;
      flags      = 0;
      note       = 0;
      period     = 0;
      volume     = 0;
      portaSpeed = 0;
      vibratoPtr = 0;
      vibratoPos = 0;
      synthPos   = 0;
    }
  }
