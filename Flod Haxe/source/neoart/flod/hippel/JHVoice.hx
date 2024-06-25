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
package neoart.flod.hippel ;
  import neoart.flod.core.*;

   final class JHVoice {
    
    @:allow(neoart.flod.hippel) var index       : Int = 0;
    @:allow(neoart.flod.hippel) var next        : JHVoice;
    @:allow(neoart.flod.hippel) var channel     : AmigaChannel;
    @:allow(neoart.flod.hippel) var enabled     : Int = 0;
    @:allow(neoart.flod.hippel) var cosoCounter : Int = 0;
    @:allow(neoart.flod.hippel) var cosoSpeed   : Int = 0;
    @:allow(neoart.flod.hippel) var trackPtr    : Int = 0;
    @:allow(neoart.flod.hippel) var trackPos    : Int = 0;
    @:allow(neoart.flod.hippel) var trackTransp : Int = 0;
    @:allow(neoart.flod.hippel) var patternPtr  : Int = 0;
    @:allow(neoart.flod.hippel) var patternPos  : Int = 0;
    @:allow(neoart.flod.hippel) var frqseqPtr   : Int = 0;
    @:allow(neoart.flod.hippel) var frqseqPos   : Int = 0;
    @:allow(neoart.flod.hippel) var volseqPtr   : Int = 0;
    @:allow(neoart.flod.hippel) var volseqPos   : Int = 0;
    @:allow(neoart.flod.hippel) var sample      : Int = 0;
    @:allow(neoart.flod.hippel) var loopPtr     : Int = 0;
    @:allow(neoart.flod.hippel) var repeat      : Int = 0;
    @:allow(neoart.flod.hippel) var tick        : Int = 0;
    @:allow(neoart.flod.hippel) var note        : Int = 0;
    @:allow(neoart.flod.hippel) var transpose   : Int = 0;
    @:allow(neoart.flod.hippel) var info        : Int = 0;
    @:allow(neoart.flod.hippel) var infoPrev    : Int = 0;
    @:allow(neoart.flod.hippel) var volume      : Int = 0;
    @:allow(neoart.flod.hippel) var volCounter  : Int = 0;
    @:allow(neoart.flod.hippel) var volSpeed    : Int = 0;
    @:allow(neoart.flod.hippel) var volSustain  : Int = 0;
    @:allow(neoart.flod.hippel) var volTransp   : Int = 0;
    @:allow(neoart.flod.hippel) var volFade     : Int = 0;
    @:allow(neoart.flod.hippel) var portaDelta  : Int = 0;
    @:allow(neoart.flod.hippel) var vibrato     : Int = 0;
    @:allow(neoart.flod.hippel) var vibDelay    : Int = 0;
    @:allow(neoart.flod.hippel) var vibDelta    : Int = 0;
    @:allow(neoart.flod.hippel) var vibDepth    : Int = 0;
    @:allow(neoart.flod.hippel) var vibSpeed    : Int = 0;
    @:allow(neoart.flod.hippel) var slide       : Int = 0;
    @:allow(neoart.flod.hippel) var sldActive   : Int = 0;
    @:allow(neoart.flod.hippel) var sldDone     : Int = 0;
    @:allow(neoart.flod.hippel) var sldCounter  : Int = 0;
    @:allow(neoart.flod.hippel) var sldSpeed    : Int = 0;
    @:allow(neoart.flod.hippel) var sldDelta    : Int = 0;
    @:allow(neoart.flod.hippel) var sldPointer  : Int = 0;
    @:allow(neoart.flod.hippel) var sldLen      : Int = 0;
    @:allow(neoart.flod.hippel) var sldEnd      : Int = 0;
    @:allow(neoart.flod.hippel) var sldLoopPtr  : Int = 0;

    public function new(index:Int) {
      this.index = index;
    }

    @:allow(neoart.flod.hippel) function initialize() {
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
