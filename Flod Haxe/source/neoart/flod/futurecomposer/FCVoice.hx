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
package neoart.flod.futurecomposer ;
  import neoart.flod.core.*;

   final class FCVoice {
    
    @:allow(neoart.flod.futurecomposer) var index          : Int = 0;
    @:allow(neoart.flod.futurecomposer) var next           : FCVoice;
    @:allow(neoart.flod.futurecomposer) var channel        : AmigaChannel;
    @:allow(neoart.flod.futurecomposer) var sample         : AmigaSample;
    @:allow(neoart.flod.futurecomposer) var enabled        : Int = 0;
    @:allow(neoart.flod.futurecomposer) var pattern        : Int = 0;
    @:allow(neoart.flod.futurecomposer) var soundTranspose : Int = 0;
    @:allow(neoart.flod.futurecomposer) var transpose      : Int = 0;
    @:allow(neoart.flod.futurecomposer) var patStep        : Int = 0;
    @:allow(neoart.flod.futurecomposer) var frqStep        : Int = 0;
    @:allow(neoart.flod.futurecomposer) var frqPos         : Int = 0;
    @:allow(neoart.flod.futurecomposer) var frqSustain     : Int = 0;
    @:allow(neoart.flod.futurecomposer) var frqTranspose   : Int = 0;
    @:allow(neoart.flod.futurecomposer) var volStep        : Int = 0;
    @:allow(neoart.flod.futurecomposer) var volPos         : Int = 0;
    @:allow(neoart.flod.futurecomposer) var volCtr         : Int = 0;
    @:allow(neoart.flod.futurecomposer) var volSpeed       : Int = 0;
    @:allow(neoart.flod.futurecomposer) var volSustain     : Int = 0;
    @:allow(neoart.flod.futurecomposer) var note           : Int = 0;
    @:allow(neoart.flod.futurecomposer) var pitch          : Int = 0;
    @:allow(neoart.flod.futurecomposer) var volume         : Int = 0;
    @:allow(neoart.flod.futurecomposer) var pitchBendFlag  : Int = 0;
    @:allow(neoart.flod.futurecomposer) var pitchBendSpeed : Int = 0;
    @:allow(neoart.flod.futurecomposer) var pitchBendTime  : Int = 0;
    @:allow(neoart.flod.futurecomposer) var portamentoFlag : Int = 0;
    @:allow(neoart.flod.futurecomposer) var portamento     : Int = 0;
    @:allow(neoart.flod.futurecomposer) var volBendFlag    : Int = 0;
    @:allow(neoart.flod.futurecomposer) var volBendSpeed   : Int = 0;
    @:allow(neoart.flod.futurecomposer) var volBendTime    : Int = 0;
    @:allow(neoart.flod.futurecomposer) var vibratoFlag    : Int = 0;
    @:allow(neoart.flod.futurecomposer) var vibratoSpeed   : Int = 0;
    @:allow(neoart.flod.futurecomposer) var vibratoDepth   : Int = 0;
    @:allow(neoart.flod.futurecomposer) var vibratoDelay   : Int = 0;
    @:allow(neoart.flod.futurecomposer) var vibrato        : Int = 0;

    public function new(index:Int) {
      this.index = index;
    }

    @:allow(neoart.flod.futurecomposer) function initialize() {
      sample         = null;
      enabled        = 0;
      pattern        = 0;
      soundTranspose = 0;
      transpose      = 0;
      patStep        = 0;
      frqStep        = 0;
      frqPos         = 0;
      frqSustain     = 0;
      frqTranspose   = 0;
      volStep        = 0;
      volPos         = 0;
      volCtr         = 1;
      volSpeed       = 1;
      volSustain     = 0;
      note           = 0;
      pitch          = 0;
      volume         = 0;
      pitchBendFlag  = 0;
      pitchBendSpeed = 0;
      pitchBendTime  = 0;
      portamentoFlag = 0;
      portamento     = 0;
      volBendFlag    = 0;
      volBendSpeed   = 0;
      volBendTime    = 0;
      vibratoFlag    = 0;
      vibratoSpeed   = 0;
      vibratoDepth   = 0;
      vibratoDelay   = 0;
      vibrato        = 0;
    }

    @:allow(neoart.flod.futurecomposer) function volumeBend() {
      volBendFlag ^= 1;

      if (volBendFlag != 0) {
        volBendTime--;
        volume += volBendSpeed;
        if (volume < 0 || volume > 64) volBendTime = 0;
      }
    }
  }
