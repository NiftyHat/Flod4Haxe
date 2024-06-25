/*
  Flod 4.1
  2012/04/30
  Christian Corti
  Neoart Costa Rica

  Last Update: Flod 4.0 - 2012/03/10

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
  LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR
  IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

  This work is licensed under the Creative Commons Attribution-Noncommercial-Share Alike 3.0 Unported License.
  To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/3.0/ or send a letter to
  Creative Commons, 171 Second Street, Suite 300, San Francisco, California, 94105, USA.

  ---

  This is a simple demo showing how to use the FileLoader class to play a module, in any of the supported
  formats, loaded from the client.

*/
package demos ;
  import flash.display.*;
  import flash.events.*;
  import flash.net.*;
  import neoart.flod.*;
  import neoart.flod.core.*;

   final class Demo1 extends Sprite {
    var  file   : FileReference;
    var   loader : FileLoader;
    var   player : CorePlayer;

    public function new(stage:Stage) {
      super();
      loader = new FileLoader();

      stage.addEventListener(MouseEvent.CLICK, function(e:MouseEvent) {
        file = new FileReference();
        file.addEventListener(Event.CANCEL, cancelHandler);
        file.addEventListener(Event.SELECT, selectHandler);
        file.browse();
      });
    }

    function cancelHandler(e:Event) {
      file.removeEventListener(Event.CANCEL, cancelHandler);
      file.removeEventListener(Event.SELECT, selectHandler);
    }

    function selectHandler(e:Event) {
      cancelHandler(e);
      if (player != null) player.stop();
      file.addEventListener(Event.COMPLETE, completeHandler);
      file.load();
    }

    function completeHandler(e:Event) {
      file.removeEventListener(Event.COMPLETE, completeHandler);
      player = loader.load(file.data);
      if (player != null && player.version != 0) player.play();
    }
  }
