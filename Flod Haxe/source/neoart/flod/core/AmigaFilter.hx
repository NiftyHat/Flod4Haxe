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
package neoart.flod.core ;

   final class AmigaFilter {
    
    public static inline final  AUTOMATIC =  0;
    public static inline final  FORCE_ON  =  1;
    public static inline final  FORCE_OFF = -1;
   
     public var  active    : Int = 0;
     public var  forced    : Int = FORCE_OFF;
   
      var l0        : Float = Math.NaN;
      var l1        : Float = Math.NaN;
      var l2        : Float = Math.NaN;
     var  l3        : Float = Math.NaN;
     var  l4        : Float = Math.NaN;
      var r0        : Float = Math.NaN;
      var r1        : Float = Math.NaN;
      var r2        : Float = Math.NaN;
      var r3        : Float = Math.NaN;
      var r4        : Float = Math.NaN;

    @:allow(neoart.flod.core) function initialize() {
      l0 = l1 = l2 = l3 = l4 = 0.0;
      r0 = r1 = r2 = r3 = r4 = 0.0;
    }

    @:allow(neoart.flod.core) function process(model:Int, sample:Sample) {
      var FL= 0.5213345843532200;
	  var P0= 0.4860348337215757;
	  var P1= 0.9314955486749749; 
	  var d= 1.0 - P0;

      if (model == 0) 
	  {

        l0 = P0 * sample.l + d * l0 + 1.0e-18 - 1.0e-18;
        r0 = P0 * sample.r + d * r0 + 1.0e-18 - 1.0e-18;
        d = 1 - P1;
        sample.l = l1 = P1 * l0 + d * l1;
        sample.r = r1 = P1 * r0 + d * r1;
      }

      if ((active | forced) > 0) {
        d = 1 - FL;
        l2 = FL * sample.l + d * l2 + 1.0e-18 - 1.0e-18;
        r2 = FL * sample.r + d * r2 + 1.0e-18 - 1.0e-18;
        l3 = FL * l2 + d * l3;
        r3 = FL * r2 + d * r3;
        sample.l = l4 = FL * l3 + d * l4;
        sample.r = r4 = FL * r3 + d * r4;
      }

      if (sample.l > 1.0) {sample.l = 1.0;}
        else if (sample.l < -1.0) {
			sample.l = -1.0;
		}

      if (sample.r > 1.0) {
		  sample.r = 1.0;
	  }
        else if (sample.r < -1.0) {
			sample.r = -1.0;
		}
    }
public function new(){}
  }
