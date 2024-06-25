/*
  Flod 4.1
  2012/04/30
  Christian Corti
  Neoart Costa Rica

  Last Update: Flod 4.1 - 2012/04/09

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
  LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR
  IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

  This work is licensed under the Creative Commons Attribution-Noncommercial-Share Alike 3.0 Unported License.
  To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/3.0/ or send a letter to
  Creative Commons, 171 Second Street, Suite 300, San Francisco, California, 94105, USA.
*/
package neoart.flod.core ;

   final class AmigaChannel {
    
     public var next    : AmigaChannel;
     public var mute    : Int = 0;
     public var panning : Float = 1.0;
     public var delay   : Int = 0;
     public var pointer : Int = 0;
     public var length  : Int = 0;
   
      @:allow(neoart.flod.core) var audena  : Int = 0;
      @:allow(neoart.flod.core) var audcnt  : Int = 0;
      @:allow(neoart.flod.core) var audloc  : Int = 0;
      @:allow(neoart.flod.core) var audper  : Int = 0;
      @:allow(neoart.flod.core) var audvol  : Int = 0;
      @:allow(neoart.flod.core) var timer   : Float = Math.NaN;
      @:allow(neoart.flod.core) var level   : Float = Math.NaN;
      @:allow(neoart.flod.core) var ldata   : Float = Math.NaN;
      @:allow(neoart.flod.core) var rdata   : Float = Math.NaN;

    public function new(index:Int) {
      if ((++index & 2) == 0) panning = -panning;
      level = panning;
    }

    
    public var enabled(get,set):Int;
function  get_enabled():Int { return audena; }
function  set_enabled(value:Int):Int{
      if (value == audena) return value;

      audena = value;
      audloc = pointer;
      audcnt = pointer + length;

      timer = 1.0;
      if (value != 0) delay += 2;
return value;
    }

    public var period(never,set):Int;
function  set_period(value:Int):Int{
      if (value < 0) {
		value = 0;
	  }
        else if (value > 65535) {
			value = 65535;
		}

      return audper = value;
    }

    public var volume(never,set):Int;
function  set_volume(value:Int):Int{
      if (value < 0) {
	  value = 0;
	  }
        else if (value > 64) {
			value = 64;
		}

      return audvol = value;
    }

    public function resetData() {
      ldata = 0.0;
      rdata = 0.0;
    }

    @:allow(neoart.flod.core) function initialize() {
      audena = 0;
      audcnt = 0;
      audloc = 0;
      audper = 50;
      audvol = 0;

      timer = 0.0;
      ldata = 0.0;
      rdata = 0.0;

      delay   = 0;
      pointer = 0;
      length  = 0;
    }
  }
