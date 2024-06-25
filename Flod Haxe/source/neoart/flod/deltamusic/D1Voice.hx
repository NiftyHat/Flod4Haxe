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
package neoart.flod.deltamusic ;
  import neoart.flod.core.*;

   final class D1Voice {
    
    @:allow(neoart.flod.deltamusic) var index         : Int = 0;
    @:allow(neoart.flod.deltamusic) var next          : D1Voice;
    @:allow(neoart.flod.deltamusic) var channel       : AmigaChannel;
    @:allow(neoart.flod.deltamusic) var sample        : D1Sample;
    @:allow(neoart.flod.deltamusic) var trackPos      : Int = 0;
    @:allow(neoart.flod.deltamusic) var patternPos    : Int = 0;
    @:allow(neoart.flod.deltamusic) var status        : Int = 0;
    @:allow(neoart.flod.deltamusic) var speed         : Int = 0;
    @:allow(neoart.flod.deltamusic) var step          : AmigaStep;
    @:allow(neoart.flod.deltamusic) var row           : AmigaRow;
    @:allow(neoart.flod.deltamusic) var note          : Int = 0;
    @:allow(neoart.flod.deltamusic) var period        : Int = 0;
    @:allow(neoart.flod.deltamusic) var arpeggioPos   : Int = 0;
    @:allow(neoart.flod.deltamusic) var pitchBend     : Int = 0;
    @:allow(neoart.flod.deltamusic) var tableCtr      : Int = 0;
    @:allow(neoart.flod.deltamusic) var tablePos      : Int = 0;
    @:allow(neoart.flod.deltamusic) var vibratoCtr    : Int = 0;
    @:allow(neoart.flod.deltamusic) var vibratoDir    : Int = 0;
    @:allow(neoart.flod.deltamusic) var vibratoPos    : Int = 0;
    @:allow(neoart.flod.deltamusic) var vibratoPeriod : Int = 0;
    @:allow(neoart.flod.deltamusic) var volume        : Int = 0;
    @:allow(neoart.flod.deltamusic) var attackCtr     : Int = 0;
    @:allow(neoart.flod.deltamusic) var decayCtr      : Int = 0;
    @:allow(neoart.flod.deltamusic) var releaseCtr    : Int = 0;
    @:allow(neoart.flod.deltamusic) var sustain       : Int = 0;

    public function new(index:Int) {
      this.index = index;
    }

    @:allow(neoart.flod.deltamusic) function initialize() {
      sample        = null;
      trackPos      = 0;
      patternPos    = 0;
      status        = 0;
      speed         = 1;
      step          = null;
      row           = null;
      note          = 0;
      period        = 0;
      arpeggioPos   = 0;
      pitchBend     = 0;
      tableCtr      = 0;
      tablePos      = 0;
      vibratoCtr    = 0;
      vibratoDir    = 0;
      vibratoPos    = 0;
      vibratoPeriod = 0;
      volume        = 0;
      attackCtr     = 0;
      decayCtr      = 0;
      releaseCtr    = 0;
      sustain       = 1;
    }
  }
