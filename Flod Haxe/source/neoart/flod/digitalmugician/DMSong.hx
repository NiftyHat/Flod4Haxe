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

   final class DMSong {
    
    @:allow(neoart.flod.digitalmugician) var title    : String;
    @:allow(neoart.flod.digitalmugician) var speed    : Int = 0;
    @:allow(neoart.flod.digitalmugician) var length   : Int = 0;
    @:allow(neoart.flod.digitalmugician) var loop     : Int = 0;
    @:allow(neoart.flod.digitalmugician) var loopStep : Int = 0;
    @:allow(neoart.flod.digitalmugician) var tracks   : Vector<AmigaStep>;

    public function new() {
      tracks = new Vector<AmigaStep>();
    }
  }