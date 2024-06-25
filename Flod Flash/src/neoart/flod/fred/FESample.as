/*
  Flod 4.1
  2012/04/30
  Christian Corti
  Neoart Costa Rica

  Last Update: Flod 4.0 - 2012/02/16

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
  LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR
  IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

  This work is licensed under the Creative Commons Attribution-Noncommercial-Share Alike 3.0 Unported License.
  To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/3.0/ or send a letter to
  Creative Commons, 171 Second Street, Suite 300, San Francisco, California, 94105, USA.
*/
package neoart.flod.fred {

  public final class FESample {
    
    internal var pointer       : int;
    internal var loopPtr       : int;
    internal var length        : int;
    internal var relative      : int;
    internal var type          : int;
    internal var synchro       : int;
    internal var envelopeVol   : int;
    internal var attackSpeed   : int;
    internal var attackVol     : int;
    internal var decaySpeed    : int;
    internal var decayVol      : int;
    internal var sustainTime   : int;
    internal var releaseSpeed  : int;
    internal var releaseVol    : int;
    internal var arpeggio      : Vector.<int>;
    internal var arpeggioLimit : int;
    internal var arpeggioSpeed : int;
    internal var vibratoDelay  : int;
    internal var vibratoDepth  : int;
    internal var vibratoSpeed  : int;
    internal var pulseCounter  : int;
    internal var pulseDelay    : int;
    internal var pulsePosL     : int;
    internal var pulsePosH     : int;
    internal var pulseSpeed    : int;
    internal var pulseRateNeg  : int;
    internal var pulseRatePos  : int;
    internal var blendCounter  : int;
    internal var blendDelay    : int;
    internal var blendRate     : int;

    public function FESample() {
      arpeggio = new Vector.<int>(16, true);
    }
  }
}