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
package neoart.flod.deltamusic {
  import neoart.flod.core.*;

  public final class D2Voice {
    
    internal var index          : int;
    internal var next           : D2Voice;
    internal var channel        : AmigaChannel;
    internal var sample         : D2Sample;
    internal var trackPtr       : int;
    internal var trackPos       : int;
    internal var trackLen       : int;
    internal var patternPos     : int;
    internal var restart        : int;
    internal var step           : AmigaStep;
    internal var row            : AmigaRow;
    internal var note           : int;
    internal var period         : int;
    internal var finalPeriod    : int;
    internal var arpeggioPtr    : int;
    internal var arpeggioPos    : int;
    internal var pitchBend      : int;
    internal var portamento     : int;
    internal var tableCtr       : int;
    internal var tablePos       : int;
    internal var vibratoCtr     : int;
    internal var vibratoDir     : int;
    internal var vibratoPos     : int;
    internal var vibratoPeriod  : int;
    internal var vibratoSustain : int;
    internal var volume         : int;
    internal var volumeMax      : int;
    internal var volumePos      : int;
    internal var volumeSustain  : int;

    public function D2Voice(index:int) {
      this.index = index;
    }

    internal function initialize():void {
      sample         = null;
      trackPtr       = 0;
      trackPos       = 0;
      trackLen       = 0;
      patternPos     = 0;
      restart        = 0;
      step           = null;
      row            = null;
      note           = 0;
      period         = 0;
      finalPeriod    = 0;
      arpeggioPtr    = 0;
      arpeggioPos    = 0;
      pitchBend      = 0;
      portamento     = 0;
      tableCtr       = 0;
      tablePos       = 0;
      vibratoCtr     = 0;
      vibratoDir     = 0;
      vibratoPos     = 0;
      vibratoPeriod  = 0;
      vibratoSustain = 0;
      volume         = 0;
      volumeMax      = 63;
      volumePos      = 0;
      volumeSustain  = 0;
    }
  }
}