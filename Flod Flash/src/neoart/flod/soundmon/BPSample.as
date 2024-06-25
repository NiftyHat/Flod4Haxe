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

  public final class BPSample extends AmigaSample {
    
    internal var synth       : int;
    internal var table       : int;
    internal var adsrControl : int;
    internal var adsrTable   : int;
    internal var adsrLen     : int;
    internal var adsrSpeed   : int;
    internal var lfoControl  : int;
    internal var lfoTable    : int;
    internal var lfoDepth    : int;
    internal var lfoLen      : int;
    internal var lfoDelay    : int;
    internal var lfoSpeed    : int;
    internal var egControl   : int;
    internal var egTable     : int;
    internal var egLen       : int;
    internal var egDelay     : int;
    internal var egSpeed     : int;
    internal var fxControl   : int;
    internal var fxDelay     : int;
    internal var fxSpeed     : int;
    internal var modControl  : int;
    internal var modTable    : int;
    internal var modLen      : int;
    internal var modDelay    : int;
    internal var modSpeed    : int;
  }
}