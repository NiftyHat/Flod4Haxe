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
package neoart.flod.deltamusic;

import neoart.flod.core.*;
import flash.Vector;

final class D1Sample extends AmigaSample
{
	@:allow(neoart.flod.deltamusic) var synth:Int = 0;
	@:allow(neoart.flod.deltamusic) var attackStep:Int = 0;
	@:allow(neoart.flod.deltamusic) var attackDelay:Int = 0;
	@:allow(neoart.flod.deltamusic) var decayStep:Int = 0;
	@:allow(neoart.flod.deltamusic) var decayDelay:Int = 0;
	@:allow(neoart.flod.deltamusic) var releaseStep:Int = 0;
	@:allow(neoart.flod.deltamusic) var releaseDelay:Int = 0;
	@:allow(neoart.flod.deltamusic) var sustain:Int = 0;
	@:allow(neoart.flod.deltamusic) var arpeggio:Vector<Int>;
	@:allow(neoart.flod.deltamusic) var pitchBend:Int = 0;
	@:allow(neoart.flod.deltamusic) var portamento:Int = 0;
	@:allow(neoart.flod.deltamusic) var table:Vector<Int>;
	@:allow(neoart.flod.deltamusic) var tableDelay:Int = 0;
	@:allow(neoart.flod.deltamusic) var vibratoWait:Int = 0;
	@:allow(neoart.flod.deltamusic) var vibratoStep:Int = 0;
	@:allow(neoart.flod.deltamusic) var vibratoLen:Int = 0;

	public function new()
	{
		super();
		arpeggio = new Vector<Int>(8, true);
		table = new Vector<Int>(48, true);
	}
}
