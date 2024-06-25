/*
  Flod 4.1
  2012/04/30
  Christian Corti
  Neoart Costa Rica

  Last Update: Flod 4.0 - 2012/03/08

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
  LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR
  IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

  This work is licensed under the Creative Commons Attribution-Noncommercial-Share Alike 3.0 Unported License.
  To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/3.0/ or send a letter to
  Creative Commons, 171 Second Street, Suite 300, San Francisco, California, 94105, USA.
*/
package neoart.flod.hippel {
  import neoart.flod.core.*;

  public final class JHVoice {
    
    internal var index       : int;
    internal var next        : JHVoice;
    internal var channel     : AmigaChannel;
    internal var enabled     : int;
    internal var cosoCounter : int;
    internal var cosoSpeed   : int;
    internal var trackPtr    : int;
    internal var trackPos    : int;
    internal var trackTransp : int;
    internal var patternPtr  : int;
    internal var patternPos  : int;
    internal var frqseqPtr   : int;
    internal var frqseqPos   : int;
    internal var volseqPtr   : int;
    internal var volseqPos   : int;
    internal var sample      : int;
    internal var loopPtr     : int;
    internal var repeat      : int;
    internal var tick        : int;
    internal var note        : int;
    internal var transpose   : int;
    internal var info        : int;
    internal var infoPrev    : int;
    internal var volume      : int;
    internal var volCounter  : int;
    internal var volSpeed    : int;
    internal var volSustain  : int;
    internal var volTransp   : int;
    internal var volFade     : int;
    internal var portaDelta  : int;
    internal var vibrato     : int;
    internal var vibDelay    : int;
    internal var vibDelta    : int;
    internal var vibDepth    : int;
    internal var vibSpeed    : int;
    internal var slide       : int;
    internal var sldActive   : int;
    internal var sldDone     : int;
    internal var sldCounter  : int;
    internal var sldSpeed    : int;
    internal var sldDelta    : int;
    internal var sldPointer  : int;
    internal var sldLen      : int;
    internal var sldEnd      : int;
    internal var sldLoopPtr  : int;

    public function JHVoice(index:int) {
      this.index = index;
    }

    internal function initialize():void {
      channel     = null;
      enabled     = 0;
      cosoCounter = 0;
      cosoSpeed   = 0;
      trackPtr    = 0;
      trackPos    = 12;
      trackTransp = 0;
      patternPtr  = 0;
      patternPos  = 0;
      frqseqPtr   = 0;
      frqseqPos   = 0;
      volseqPtr   = 0;
      volseqPos   = 0;
      sample      = -1;
      loopPtr     = 0;
      repeat      = 0;
      tick        = 0;
      note        = 0;
      transpose   = 0;
      info        = 0;
      infoPrev    = 0;
      volume      = 0;
      volCounter  = 1;
      volSpeed    = 1;
      volSustain  = 0;
      volTransp   = 0;
      volFade     = 100;
      portaDelta  = 0;
      vibrato     = 0;
      vibDelay    = 0;
      vibDelta    = 0;
      vibDepth    = 0;
      vibSpeed    = 0;
      slide       = 0;
      sldActive   = 0;
      sldDone     = 0;
      sldCounter  = 0;
      sldSpeed    = 0;
      sldDelta    = 0;
      sldPointer  = 0;
      sldLen      = 0;
      sldEnd      = 0;
      sldLoopPtr  = 0;
    }
  }
}