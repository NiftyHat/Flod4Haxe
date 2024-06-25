/*
	Flod 4.1
	2012/04/30
	Christian Corti
	Neoart Costa Rica

	Last Update: Flod 4.1 - 2012/04/21

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
	OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
	LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR
	IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

	This work is licensed under the Creative Commons Attribution-Noncommercial-Share Alike 3.0 Unported License.
	To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/3.0/ or send a letter to
	Creative Commons, 171 Second Street, Suite 300, San Francisco, California, 94105, USA.
 */
package neoart.flod.core;

import flash.Vector;

class SBPlayer extends CorePlayer
{
	public var mixer:Soundblaster;
	public var length:Int = 0;
	public var restart:Int = 0;
	public var track:Vector<Int>;

	var timer:Int = 0;
	var master:Int = 0;

	public function new(mixer:Soundblaster = null)
	{
		this.mixer = if (mixer != null) mixer else new Soundblaster();
		super(this.mixer);

		endian = "littleEndian";
		quality = 1;
	}

	override function set_volume(value:Float):Float
	{
		if (value < 0.0)
		{
			value = 0.0;
		}
		else if (value > 1.0)
		{
			value = 1.0;
		}

		master = Std.int(value * 64);
		return value;
	}

	override public function toggle(index:Int)
	{
		mixer.channels[index].mute ^= 1;
	}

	override function setup()
	{
		mixer.setup(channels);
	}

	override function initialize()
	{
		super.initialize();
		timer = speed;
		master = 64;
	}
}
