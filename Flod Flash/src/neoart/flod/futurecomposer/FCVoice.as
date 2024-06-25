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
package neoart.flod.futurecomposer {
  import neoart.flod.core.*;

  public final class FCVoice {
    
    internal var index          : int;
    internal var next           : FCVoice;
    internal var channel        : AmigaChannel;
    internal var sample         : AmigaSample;
    internal var enabled        : int;
    internal var pattern        : int;
    internal var soundTranspose : int;
    internal var transpose      : int;
    internal var patStep        : int;
    internal var frqStep        : int;
    internal var frqPos         : int;
    internal var frqSustain     : int;
    internal var frqTranspose   : int;
    internal var volStep        : int;
    internal var volPos         : int;
    internal var volCtr         : int;
    internal var volSpeed       : int;
    internal var volSustain     : int;
    internal var note           : int;
    internal var pitch          : int;
    internal var volume         : int;
    internal var pitchBendFlag  : int;
    internal var pitchBendSpeed : int;
    internal var pitchBendTime  : int;
    internal var portamentoFlag : int;
    internal var portamento     : int;
    internal var volBendFlag    : int;
    internal var volBendSpeed   : int;
    internal var volBendTime    : int;
    internal var vibratoFlag    : int;
    internal var vibratoSpeed   : int;
    internal var vibratoDepth   : int;
    internal var vibratoDelay   : int;
    internal var vibrato        : int;

    public function FCVoice(index:int) {
      this.index = index;
    }

    internal function initialize():void {
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

    internal function volumeBend():void {
      volBendFlag ^= 1;

      if (volBendFlag) {
        volBendTime--;
        volume += volBendSpeed;
        if (volume < 0 || volume > 64) volBendTime = 0;
      }
    }
  }
}