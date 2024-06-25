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
package neoart.flod.digitalmugician ;
  import neoart.flod.core.*;

   final class DMVoice {
    
    @:allow(neoart.flod.digitalmugician) var channel      : AmigaChannel;
    @:allow(neoart.flod.digitalmugician) var sample       : DMSample;
    @:allow(neoart.flod.digitalmugician) var step         : AmigaStep;
    @:allow(neoart.flod.digitalmugician) var note         : Int = 0;
    @:allow(neoart.flod.digitalmugician) var period       : Int = 0;
    @:allow(neoart.flod.digitalmugician) var val1         : Int = 0;
    @:allow(neoart.flod.digitalmugician) var val2         : Int = 0;
    @:allow(neoart.flod.digitalmugician) var finalPeriod  : Int = 0;
    @:allow(neoart.flod.digitalmugician) var arpeggioStep : Int = 0;
    @:allow(neoart.flod.digitalmugician) var effectCtr    : Int = 0;
    @:allow(neoart.flod.digitalmugician) var pitch        : Int = 0;
    @:allow(neoart.flod.digitalmugician) var pitchCtr     : Int = 0;
    @:allow(neoart.flod.digitalmugician) var pitchStep    : Int = 0;
    @:allow(neoart.flod.digitalmugician) var portamento   : Int = 0;
    @:allow(neoart.flod.digitalmugician) var volume       : Int = 0;
    @:allow(neoart.flod.digitalmugician) var volumeCtr    : Int = 0;
    @:allow(neoart.flod.digitalmugician) var volumeStep   : Int = 0;
    @:allow(neoart.flod.digitalmugician) var mixMute      : Int = 0;
    @:allow(neoart.flod.digitalmugician) var mixPtr       : Int = 0;
    @:allow(neoart.flod.digitalmugician) var mixEnd       : Int = 0;
    @:allow(neoart.flod.digitalmugician) var mixSpeed     : Int = 0;
    @:allow(neoart.flod.digitalmugician) var mixStep      : Int = 0;
    @:allow(neoart.flod.digitalmugician) var mixVolume    : Int = 0;

    @:allow(neoart.flod.digitalmugician) function initialize() {
      sample       = null;
      step         = null;
      note         = 0;
      period       = 0;
      val1         = 0;
      val2         = 0;
      finalPeriod  = 0;
      arpeggioStep = 0;
      effectCtr    = 0;
      pitch        = 0;
      pitchCtr     = 0;
      pitchStep    = 0;
      portamento   = 0;
      volume       = 0;
      volumeCtr    = 0;
      volumeStep   = 0;
      mixMute      = 1;
      mixPtr       = 0;
      mixEnd       = 0;
      mixSpeed     = 0;
      mixStep      = 0;
      mixVolume    = 0;
    }
public function new(){}
  }
