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

   final class BPSample extends AmigaSample {
    
    @:allow(neoart.flod.soundmon) var synth       : Int = 0;
    @:allow(neoart.flod.soundmon) var table       : Int = 0;
    @:allow(neoart.flod.soundmon) var adsrControl : Int = 0;
    @:allow(neoart.flod.soundmon) var adsrTable   : Int = 0;
    @:allow(neoart.flod.soundmon) var adsrLen     : Int = 0;
    @:allow(neoart.flod.soundmon) var adsrSpeed   : Int = 0;
    @:allow(neoart.flod.soundmon) var lfoControl  : Int = 0;
    @:allow(neoart.flod.soundmon) var lfoTable    : Int = 0;
    @:allow(neoart.flod.soundmon) var lfoDepth    : Int = 0;
    @:allow(neoart.flod.soundmon) var lfoLen      : Int = 0;
    @:allow(neoart.flod.soundmon) var lfoDelay    : Int = 0;
    @:allow(neoart.flod.soundmon) var lfoSpeed    : Int = 0;
    @:allow(neoart.flod.soundmon) var egControl   : Int = 0;
    @:allow(neoart.flod.soundmon) var egTable     : Int = 0;
    @:allow(neoart.flod.soundmon) var egLen       : Int = 0;
    @:allow(neoart.flod.soundmon) var egDelay     : Int = 0;
    @:allow(neoart.flod.soundmon) var egSpeed     : Int = 0;
    @:allow(neoart.flod.soundmon) var fxControl   : Int = 0;
    @:allow(neoart.flod.soundmon) var fxDelay     : Int = 0;
    @:allow(neoart.flod.soundmon) var fxSpeed     : Int = 0;
    @:allow(neoart.flod.soundmon) var modControl  : Int = 0;
    @:allow(neoart.flod.soundmon) var modTable    : Int = 0;
    @:allow(neoart.flod.soundmon) var modLen      : Int = 0;
    @:allow(neoart.flod.soundmon) var modDelay    : Int = 0;
    @:allow(neoart.flod.soundmon) var modSpeed    : Int = 0;
  }
