/*
  Flod 4.1
  2012/04/30
  Christian Corti
  Neoart Costa Rica

  Last Update: Flod 4.0 - 2012/02/22

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
  LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR
  IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

  This work is licensed under the Creative Commons Attribution-Noncommercial-Share Alike 3.0 Unported License.
  To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/3.0/ or send a letter to
  Creative Commons, 171 Second Street, Suite 300, San Francisco, California, 94105, USA.
*/
package neoart.flod.whittaker ;
  import neoart.flod.core.*;

   final class DWVoice {
    
    @:allow(neoart.flod.whittaker) var index         : Int = 0;
    @:allow(neoart.flod.whittaker) var bitFlag       : Int = 0;
    @:allow(neoart.flod.whittaker) var next          : DWVoice;
    @:allow(neoart.flod.whittaker) var channel       : AmigaChannel;
    @:allow(neoart.flod.whittaker) var sample        : DWSample;
    @:allow(neoart.flod.whittaker) var trackPtr      : Int = 0;
    @:allow(neoart.flod.whittaker) var trackPos      : Int = 0;
    @:allow(neoart.flod.whittaker) var patternPos    : Int = 0;
    @:allow(neoart.flod.whittaker) var frqseqPtr     : Int = 0;
    @:allow(neoart.flod.whittaker) var frqseqPos     : Int = 0;
    @:allow(neoart.flod.whittaker) var volseqPtr     : Int = 0;
    @:allow(neoart.flod.whittaker) var volseqPos     : Int = 0;
    @:allow(neoart.flod.whittaker) var volseqSpeed   : Int = 0;
    @:allow(neoart.flod.whittaker) var volseqCounter : Int = 0;
    @:allow(neoart.flod.whittaker) var halve         : Int = 0;
    @:allow(neoart.flod.whittaker) var speed         : Int = 0;
    @:allow(neoart.flod.whittaker) var tick          : Int = 0;
    @:allow(neoart.flod.whittaker) var busy          : Int = 0;
    @:allow(neoart.flod.whittaker) var flags         : Int = 0;
    @:allow(neoart.flod.whittaker) var note          : Int = 0;
    @:allow(neoart.flod.whittaker) var period        : Int = 0;
    @:allow(neoart.flod.whittaker) var transpose     : Int = 0;
    @:allow(neoart.flod.whittaker) var portaDelay    : Int = 0;
    @:allow(neoart.flod.whittaker) var portaDelta    : Int = 0;
    @:allow(neoart.flod.whittaker) var portaSpeed    : Int = 0;
    @:allow(neoart.flod.whittaker) var vibrato       : Int = 0;
    @:allow(neoart.flod.whittaker) var vibratoDelta  : Int = 0;
    @:allow(neoart.flod.whittaker) var vibratoSpeed  : Int = 0;
    @:allow(neoart.flod.whittaker) var vibratoDepth  : Int = 0;

    public function new(index:Int, bitFlag:Int) {
      this.index = index;
      this.bitFlag = bitFlag;
    }

    @:allow(neoart.flod.whittaker) function initialize() {
      channel       = null;
      sample        = null;
      trackPtr      = 0;
      trackPos      = 0;
      patternPos    = 0;
      frqseqPtr     = 0;
      frqseqPos     = 0;
      volseqPtr     = 0;
      volseqPos     = 0;
      volseqSpeed   = 0;
      volseqCounter = 0;
      halve         = 0;
      speed         = 0;
      tick          = 1;
      busy          = -1;
      flags         = 0;
      note          = 0;
      period        = 0;
      transpose     = 0;
      portaDelay    = 0;
      portaDelta    = 0;
      portaSpeed    = 0;
      vibrato       = 0;
      vibratoDelta  = 0;
      vibratoSpeed  = 0;
      vibratoDepth  = 0;
    }
  }
