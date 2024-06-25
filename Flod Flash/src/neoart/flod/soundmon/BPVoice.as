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
package neoart.flod.soundmon {
  import neoart.flod.core.*;

  public final class BPVoice {
    
    internal var index        : int;
    internal var next         : BPVoice;
    internal var channel      : AmigaChannel;
    internal var enabled      : int;
    internal var restart      : int;
    internal var note         : int;
    internal var period       : int;
    internal var sample       : int;
    internal var samplePtr    : int;
    internal var sampleLen    : int;
    internal var synth        : int;
    internal var synthPtr     : int;
    internal var arpeggio     : int;
    internal var autoArpeggio : int;
    internal var autoSlide    : int;
    internal var vibrato      : int;
    internal var volume       : int;
    internal var volumeDef    : int;
    internal var adsrControl  : int;
    internal var adsrPtr      : int;
    internal var adsrCtr      : int;
    internal var lfoControl   : int;
    internal var lfoPtr       : int;
    internal var lfoCtr       : int;
    internal var egControl    : int;
    internal var egPtr        : int;
    internal var egCtr        : int;
    internal var egValue      : int;
    internal var fxControl    : int;
    internal var fxCtr        : int;
    internal var modControl   : int;
    internal var modPtr       : int;
    internal var modCtr       : int;

    public function BPVoice(index:int) {
      this.index = index;
    }

    internal function initialize():void {
      channel      =  null,
      enabled      =  0;
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
}