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
package neoart.flod.sidmon;

import neoart.flod.core.*;
import flash.Vector;

final class S1Sample extends AmigaSample
{
	@:allow(neoart.flod.sidmon) var waveform:Int = 0;
	@:allow(neoart.flod.sidmon) var arpeggio:Vector<Int>;
	@:allow(neoart.flod.sidmon) var attackSpeed:Int = 0;
	@:allow(neoart.flod.sidmon) var attackMax:Int = 0;
	@:allow(neoart.flod.sidmon) var decaySpeed:Int = 0;
	@:allow(neoart.flod.sidmon) var decayMin:Int = 0;
	@:allow(neoart.flod.sidmon) var sustain:Int = 0;
	@:allow(neoart.flod.sidmon) var releaseSpeed:Int = 0;
	@:allow(neoart.flod.sidmon) var releaseMin:Int = 0;
	@:allow(neoart.flod.sidmon) var phaseShift:Int = 0;
	@:allow(neoart.flod.sidmon) var phaseSpeed:Int = 0;
	@:allow(neoart.flod.sidmon) var finetune:Int = 0;
	@:allow(neoart.flod.sidmon) var pitchFall:Int = 0;

	public function new()
	{
		super();
		arpeggio = new Vector<Int>(16, true);
	}
}
