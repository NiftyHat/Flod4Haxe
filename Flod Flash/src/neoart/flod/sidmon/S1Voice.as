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
package neoart.flod.sidmon {
  import neoart.flod.core.*;

  public final class S1Voice {
    
    internal var index        : int;
    internal var next         : S1Voice;
    internal var channel      : AmigaChannel;
    internal var step         : int;
    internal var row          : int;
    internal var sample       : int;
    internal var samplePtr    : int;
    internal var sampleLen    : int;
    internal var note         : int;
    internal var noteTimer    : int;
    internal var period       : int;
    internal var volume       : int;
    internal var bendTo       : int;
    internal var bendSpeed    : int;
    internal var arpeggioCtr  : int;
    internal var envelopeCtr  : int;
    internal var pitchCtr     : int;
    internal var pitchFallCtr : int;
    internal var sustainCtr   : int;
    internal var phaseTimer   : int;
    internal var phaseSpeed   : int;
    internal var wavePos      : int;
    internal var waveList     : int;
    internal var waveTimer    : int;
    internal var waitCtr      : int;

    public function S1Voice(index:int) {
      this.index = index;
    }

    internal function initialize():void {
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
}