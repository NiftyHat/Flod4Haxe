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
package neoart.flod.sidmon ;
  import neoart.flod.core.*;

   final class S2Instrument {
    
    @:allow(neoart.flod.sidmon) var wave           : Int = 0;
    @:allow(neoart.flod.sidmon) var waveLen        : Int = 0;
    @:allow(neoart.flod.sidmon) var waveDelay      : Int = 0;
    @:allow(neoart.flod.sidmon) var waveSpeed      : Int = 0;
    @:allow(neoart.flod.sidmon) var arpeggio       : Int = 0;
    @:allow(neoart.flod.sidmon) var arpeggioLen    : Int = 0;
    @:allow(neoart.flod.sidmon) var arpeggioDelay  : Int = 0;
    @:allow(neoart.flod.sidmon) var arpeggioSpeed  : Int = 0;
    @:allow(neoart.flod.sidmon) var vibrato        : Int = 0;
    @:allow(neoart.flod.sidmon) var vibratoLen     : Int = 0;
    @:allow(neoart.flod.sidmon) var vibratoDelay   : Int = 0;
    @:allow(neoart.flod.sidmon) var vibratoSpeed   : Int = 0;
    @:allow(neoart.flod.sidmon) var pitchBend      : Int = 0;
    @:allow(neoart.flod.sidmon) var pitchBendDelay : Int = 0;
    @:allow(neoart.flod.sidmon) var attackMax      : Int = 0;
    @:allow(neoart.flod.sidmon) var attackSpeed    : Int = 0;
    @:allow(neoart.flod.sidmon) var decayMin       : Int = 0;
    @:allow(neoart.flod.sidmon) var decaySpeed     : Int = 0;
    @:allow(neoart.flod.sidmon) var sustain        : Int = 0;
    @:allow(neoart.flod.sidmon) var releaseMin     : Int = 0;
    @:allow(neoart.flod.sidmon) var releaseSpeed   : Int = 0;
public function new(){}
  }
