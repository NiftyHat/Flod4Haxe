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
package neoart.flod.fred ;

   final class FESample {
    
    @:allow(neoart.flod.fred) var pointer       : Int = 0;
    @:allow(neoart.flod.fred) var loopPtr       : Int = 0;
    @:allow(neoart.flod.fred) var length        : Int = 0;
    @:allow(neoart.flod.fred) var relative      : Int = 0;
    @:allow(neoart.flod.fred) var type          : Int = 0;
    @:allow(neoart.flod.fred) var synchro       : Int = 0;
    @:allow(neoart.flod.fred) var envelopeVol   : Int = 0;
    @:allow(neoart.flod.fred) var attackSpeed   : Int = 0;
    @:allow(neoart.flod.fred) var attackVol     : Int = 0;
    @:allow(neoart.flod.fred) var decaySpeed    : Int = 0;
    @:allow(neoart.flod.fred) var decayVol      : Int = 0;
    @:allow(neoart.flod.fred) var sustainTime   : Int = 0;
    @:allow(neoart.flod.fred) var releaseSpeed  : Int = 0;
    @:allow(neoart.flod.fred) var releaseVol    : Int = 0;
    @:allow(neoart.flod.fred) var arpeggio      : Vector<Int>;
    @:allow(neoart.flod.fred) var arpeggioLimit : Int = 0;
    @:allow(neoart.flod.fred) var arpeggioSpeed : Int = 0;
    @:allow(neoart.flod.fred) var vibratoDelay  : Int = 0;
    @:allow(neoart.flod.fred) var vibratoDepth  : Int = 0;
    @:allow(neoart.flod.fred) var vibratoSpeed  : Int = 0;
    @:allow(neoart.flod.fred) var pulseCounter  : Int = 0;
    @:allow(neoart.flod.fred) var pulseDelay    : Int = 0;
    @:allow(neoart.flod.fred) var pulsePosL     : Int = 0;
    @:allow(neoart.flod.fred) var pulsePosH     : Int = 0;
    @:allow(neoart.flod.fred) var pulseSpeed    : Int = 0;
    @:allow(neoart.flod.fred) var pulseRateNeg  : Int = 0;
    @:allow(neoart.flod.fred) var pulseRatePos  : Int = 0;
    @:allow(neoart.flod.fred) var blendCounter  : Int = 0;
    @:allow(neoart.flod.fred) var blendDelay    : Int = 0;
    @:allow(neoart.flod.fred) var blendRate     : Int = 0;

    public function new() {
      arpeggio = new Vector<Int>(16, true);
    }
  }
