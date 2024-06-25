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
package neoart.flod.whittaker {
  import neoart.flod.core.*;

  public final class DWVoice {
    
    internal var index         : int;
    internal var bitFlag       : int;
    internal var next          : DWVoice;
    internal var channel       : AmigaChannel;
    internal var sample        : DWSample;
    internal var trackPtr      : int;
    internal var trackPos      : int;
    internal var patternPos    : int;
    internal var frqseqPtr     : int;
    internal var frqseqPos     : int;
    internal var volseqPtr     : int;
    internal var volseqPos     : int;
    internal var volseqSpeed   : int;
    internal var volseqCounter : int;
    internal var halve         : int;
    internal var speed         : int;
    internal var tick          : int;
    internal var busy          : int;
    internal var flags         : int;
    internal var note          : int;
    internal var period        : int;
    internal var transpose     : int;
    internal var portaDelay    : int;
    internal var portaDelta    : int;
    internal var portaSpeed    : int;
    internal var vibrato       : int;
    internal var vibratoDelta  : int;
    internal var vibratoSpeed  : int;
    internal var vibratoDepth  : int;

    public function DWVoice(index:int, bitFlag:int) {
      this.index = index;
      this.bitFlag = bitFlag;
    }

    internal function initialize():void {
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
}