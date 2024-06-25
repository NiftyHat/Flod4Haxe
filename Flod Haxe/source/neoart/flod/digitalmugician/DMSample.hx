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

   final class DMSample extends AmigaSample {
    
    @:allow(neoart.flod.digitalmugician) var wave        : Int = 0;
    @:allow(neoart.flod.digitalmugician) var waveLen     : Int = 0;
    @:allow(neoart.flod.digitalmugician) var finetune    : Int = 0;
    @:allow(neoart.flod.digitalmugician) var arpeggio    : Int = 0;
    @:allow(neoart.flod.digitalmugician) var pitch       : Int = 0;
    @:allow(neoart.flod.digitalmugician) var pitchDelay  : Int = 0;
    @:allow(neoart.flod.digitalmugician) var pitchLoop   : Int = 0;
    @:allow(neoart.flod.digitalmugician) var pitchSpeed  : Int = 0;
    @:allow(neoart.flod.digitalmugician) var effect      : Int = 0;
    @:allow(neoart.flod.digitalmugician) var effectDone  : Int = 0;
    @:allow(neoart.flod.digitalmugician) var effectStep  : Int = 0;
    @:allow(neoart.flod.digitalmugician) var effectSpeed : Int = 0;
    @:allow(neoart.flod.digitalmugician) var source1     : Int = 0;
    @:allow(neoart.flod.digitalmugician) var source2     : Int = 0;
    @:allow(neoart.flod.digitalmugician) var volumeLoop  : Int = 0;
    @:allow(neoart.flod.digitalmugician) var volumeSpeed : Int = 0;
  }
