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
package neoart.flod.soundmon ;
  import neoart.flod.core.*;

   final class BPVoice {
    
    @:allow(neoart.flod.soundmon) var index        : Int = 0;
    @:allow(neoart.flod.soundmon) var next         : BPVoice;
    @:allow(neoart.flod.soundmon) var channel      : AmigaChannel;
    @:allow(neoart.flod.soundmon) var enabled      : Int = 0;
    @:allow(neoart.flod.soundmon) var restart      : Int = 0;
    @:allow(neoart.flod.soundmon) var note         : Int = 0;
    @:allow(neoart.flod.soundmon) var period       : Int = 0;
    @:allow(neoart.flod.soundmon) var sample       : Int = 0;
    @:allow(neoart.flod.soundmon) var samplePtr    : Int = 0;
    @:allow(neoart.flod.soundmon) var sampleLen    : Int = 0;
    @:allow(neoart.flod.soundmon) var synth        : Int = 0;
    @:allow(neoart.flod.soundmon) var synthPtr     : Int = 0;
    @:allow(neoart.flod.soundmon) var arpeggio     : Int = 0;
    @:allow(neoart.flod.soundmon) var autoArpeggio : Int = 0;
    @:allow(neoart.flod.soundmon) var autoSlide    : Int = 0;
    @:allow(neoart.flod.soundmon) var vibrato      : Int = 0;
    @:allow(neoart.flod.soundmon) var volume       : Int = 0;
    @:allow(neoart.flod.soundmon) var volumeDef    : Int = 0;
    @:allow(neoart.flod.soundmon) var adsrControl  : Int = 0;
    @:allow(neoart.flod.soundmon) var adsrPtr      : Int = 0;
    @:allow(neoart.flod.soundmon) var adsrCtr      : Int = 0;
    @:allow(neoart.flod.soundmon) var lfoControl   : Int = 0;
    @:allow(neoart.flod.soundmon) var lfoPtr       : Int = 0;
    @:allow(neoart.flod.soundmon) var lfoCtr       : Int = 0;
    @:allow(neoart.flod.soundmon) var egControl    : Int = 0;
    @:allow(neoart.flod.soundmon) var egPtr        : Int = 0;
    @:allow(neoart.flod.soundmon) var egCtr        : Int = 0;
    @:allow(neoart.flod.soundmon) var egValue      : Int = 0;
    @:allow(neoart.flod.soundmon) var fxControl    : Int = 0;
    @:allow(neoart.flod.soundmon) var fxCtr        : Int = 0;
    @:allow(neoart.flod.soundmon) var modControl   : Int = 0;
    @:allow(neoart.flod.soundmon) var modPtr       : Int = 0;
    @:allow(neoart.flod.soundmon) var modCtr       : Int = 0;

    public function new(index:Int) {
      this.index = index;
    }

    @:allow(neoart.flod.soundmon) function initialize() {
      {channel      =  null;
      enabled      =  0;}
      restart      =  0;
      note         =  0;
      period       =  0;
      sample       =  0;
      samplePtr    =  0;
      sampleLen    =  2;
      synth        =  0;
      synthPtr     = -1;
      arpeggio     =  0;
      autoArpeggio =  0;
      autoSlide    =  0;
      vibrato      =  0;
      volume       =  0;
      volumeDef    =  0;
      adsrControl  =  0;
      adsrPtr      =  0;
      adsrCtr      =  0;
      lfoControl   =  0;
      lfoPtr       =  0;
      lfoCtr       =  0;
      egControl    =  0;
      egPtr        =  0;
      egCtr        =  0;
      egValue      =  0;
      fxControl    =  0;
      fxCtr        =  0;
      modControl   =  0;
      modPtr       =  0;
      modCtr       =  0;
    } 
  }
