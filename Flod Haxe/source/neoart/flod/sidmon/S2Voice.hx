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

   final class S2Voice {
    
    @:allow(neoart.flod.sidmon) var index          : Int = 0;
    @:allow(neoart.flod.sidmon) var next           : S2Voice;
    @:allow(neoart.flod.sidmon) var channel        : AmigaChannel;
    @:allow(neoart.flod.sidmon) var step           : S2Step;
    @:allow(neoart.flod.sidmon) var row            : SMRow;
    @:allow(neoart.flod.sidmon) var instr          : S2Instrument;
    @:allow(neoart.flod.sidmon) var sample         : S2Sample;
    @:allow(neoart.flod.sidmon) var enabled        : Int = 0;
    @:allow(neoart.flod.sidmon) var pattern        : Int = 0;
    @:allow(neoart.flod.sidmon) var instrument     : Int = 0;
    @:allow(neoart.flod.sidmon) var note           : Int = 0;
    @:allow(neoart.flod.sidmon) var period         : Int = 0;
    @:allow(neoart.flod.sidmon) var volume         : Int = 0;
    @:allow(neoart.flod.sidmon) var original       : Int = 0;
    @:allow(neoart.flod.sidmon) var adsrPos        : Int = 0;
    @:allow(neoart.flod.sidmon) var sustainCtr     : Int = 0;
    @:allow(neoart.flod.sidmon) var pitchBend      : Int = 0;
    @:allow(neoart.flod.sidmon) var pitchBendCtr   : Int = 0;
    @:allow(neoart.flod.sidmon) var noteSlideTo    : Int = 0;
    @:allow(neoart.flod.sidmon) var noteSlideSpeed : Int = 0;
    @:allow(neoart.flod.sidmon) var waveCtr        : Int = 0;
    @:allow(neoart.flod.sidmon) var wavePos        : Int = 0;
    @:allow(neoart.flod.sidmon) var arpeggioCtr    : Int = 0;
    @:allow(neoart.flod.sidmon) var arpeggioPos    : Int = 0;
    @:allow(neoart.flod.sidmon) var vibratoCtr     : Int = 0;
    @:allow(neoart.flod.sidmon) var vibratoPos     : Int = 0;
    @:allow(neoart.flod.sidmon) var speed          : Int = 0;

    public function new(index:Int) {
      this.index = index;
    }

    @:allow(neoart.flod.sidmon) function initialize() {
      step           = null;
      row            = null;
      instr          = null;
      sample         = null;
      enabled        = 0;
      pattern        = 0;
      instrument     = 0;
      note           = 0;
      period         = 0;
      volume         = 0;
      original       = 0;
      adsrPos        = 0;
      sustainCtr     = 0;
      pitchBend      = 0;
      pitchBendCtr   = 0;
      noteSlideTo    = 0;
      noteSlideSpeed = 0;
      waveCtr        = 0;
      wavePos        = 0;
      arpeggioCtr    = 0;
      arpeggioPos    = 0;
      vibratoCtr     = 0;
      vibratoPos     = 0;
      speed          = 0;
    }
  }
