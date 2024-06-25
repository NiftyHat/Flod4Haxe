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
package neoart.flod.fasttracker;

import flash.Vector;

final class F2Instrument
{
	@:allow(neoart.flod.fasttracker) var name:String = "";
	@:allow(neoart.flod.fasttracker) var samples:Vector<F2Sample>;
	@:allow(neoart.flod.fasttracker) var noteSamples:Vector<Int>;
	@:allow(neoart.flod.fasttracker) var fadeout:Int = 0;
	@:allow(neoart.flod.fasttracker) var volData:F2Data;
	@:allow(neoart.flod.fasttracker) var volEnabled:Int = 0;
	@:allow(neoart.flod.fasttracker) var panData:F2Data;
	@:allow(neoart.flod.fasttracker) var panEnabled:Int = 0;
	@:allow(neoart.flod.fasttracker) var vibratoType:Int = 0;
	@:allow(neoart.flod.fasttracker) var vibratoSweep:Int = 0;
	@:allow(neoart.flod.fasttracker) var vibratoSpeed:Int = 0;
	@:allow(neoart.flod.fasttracker) var vibratoDepth:Int = 0;

	public function new()
	{
		noteSamples = new Vector<Int>(96, true);
		volData = new F2Data();
		panData = new F2Data();
	}
}
