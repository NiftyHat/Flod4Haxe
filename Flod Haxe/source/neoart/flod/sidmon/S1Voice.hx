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
package neoart.flod.sidmon ;
  import neoart.flod.core.*;

   final class S1Voice {
    
    @:allow(neoart.flod.sidmon) var index        : Int = 0;
    @:allow(neoart.flod.sidmon) var next         : S1Voice;
    @:allow(neoart.flod.sidmon) var channel      : AmigaChannel;
    @:allow(neoart.flod.sidmon) var step         : Int = 0;
    @:allow(neoart.flod.sidmon) var row          : Int = 0;
    @:allow(neoart.flod.sidmon) var sample       : Int = 0;
    @:allow(neoart.flod.sidmon) var samplePtr    : Int = 0;
    @:allow(neoart.flod.sidmon) var sampleLen    : Int = 0;
    @:allow(neoart.flod.sidmon) var note         : Int = 0;
    @:allow(neoart.flod.sidmon) var noteTimer    : Int = 0;
    @:allow(neoart.flod.sidmon) var period       : Int = 0;
    @:allow(neoart.flod.sidmon) var volume       : Int = 0;
    @:allow(neoart.flod.sidmon) var bendTo       : Int = 0;
    @:allow(neoart.flod.sidmon) var bendSpeed    : Int = 0;
    @:allow(neoart.flod.sidmon) var arpeggioCtr  : Int = 0;
    @:allow(neoart.flod.sidmon) var envelopeCtr  : Int = 0;
    @:allow(neoart.flod.sidmon) var pitchCtr     : Int = 0;
    @:allow(neoart.flod.sidmon) var pitchFallCtr : Int = 0;
    @:allow(neoart.flod.sidmon) var sustainCtr   : Int = 0;
    @:allow(neoart.flod.sidmon) var phaseTimer   : Int = 0;
    @:allow(neoart.flod.sidmon) var phaseSpeed   : Int = 0;
    @:allow(neoart.flod.sidmon) var wavePos      : Int = 0;
    @:allow(neoart.flod.sidmon) var waveList     : Int = 0;
    @:allow(neoart.flod.sidmon) var waveTimer    : Int = 0;
    @:allow(neoart.flod.sidmon) var waitCtr      : Int = 0;

    public function new(index:Int) {
      this.index = index;
    }

    @:allow(neoart.flod.sidmon) function initialize() {
      step         =  0;
      row          =  0;
      sample       =  0;
      samplePtr    = -1;
      sampleLen    =  0;
      note         =  0;
      noteTimer    =  0;
      period       =  0x9999;
      volume       =  0;
      bendTo       =  0;
      bendSpeed    =  0;
      arpeggioCtr  =  0;
      envelopeCtr  =  0;
      pitchCtr     =  0;
      pitchFallCtr =  0;
      sustainCtr   =  0;
      phaseTimer   =  0;
      phaseSpeed   =  0;
      wavePos      =  0;
      waveList     =  0;
      waveTimer    =  0;
      waitCtr      =  0;
    }
  }
