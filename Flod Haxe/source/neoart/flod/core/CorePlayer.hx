/*
  Flod 4.1
  2012/04/30
  Christian Corti
  Neoart Costa Rica

  Last Update: Flod 4.0 - 2012/03/09

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
  LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR
  IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

  This work is licensed under the Creative Commons Attribution-Noncommercial-Share Alike 3.0 Unported License.
  To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/3.0/ or send a letter to
  Creative Commons, 171 Second Street, Suite 300, San Francisco, California, 94105, USA.
*/
package neoart.flod.core ;
  import flash.events.*;
  import flash.media.*;
  import flash.utils.*;
  import neoart.flip.*;

   class CorePlayer extends EventDispatcher {
    
    public static inline final ENCODING = "us-ascii";
    
    public var quality   : Int = 0;
    public var record    : Int = 0;
    public var playSong  : Int = 0;
    public var lastSong  : Int = 0;
    public var version   : Int = 0;
    public var variant   : Int = 0;
    public var title     : String = "";
    public var channels  : Int = 0;
    public var loopSong  : Int = 0;
    public var speed     : Int = 0;
    public var tempo     : Int = 0;
    
    var hardware  : CoreMixer;
    var sound     : Sound;
    var soundChan : SoundChannel;
    var soundPos  : Float = 0.0;
    var endian    : String;
    var tick      : Int = 0;

    public function new(hardware:CoreMixer) {
      super();
      hardware.player = this;
      this.hardware = hardware;
    }

    public var force(never,set):Int;
function  set_force(value:Int):Int{
      version = 0;
return value;
    }

    public var ntsc(never,set):Int;
function  set_ntsc(value:Int):Int{ return value;
}

    public var stereo(never,set):Float;
function  set_stereo(value:Float):Float{ return value;
}

    public var volume(never,set):Float;
function  set_volume(value:Float):Float{ return value;
}

    public var waveform(get,never):ByteArray;
function  get_waveform():ByteArray {
      return hardware.waveform();
    }

    public function toggle(index:Int) { }

    public function load(stream:ByteArray):Int {
      var zip:ZipFile;
      hardware.reset();
      stream.position = 0;

      version  = 0;
      playSong = 0;
      lastSong = 0;

      if (stream.readUnsignedInt() == 67324752) {
        zip = new ZipFile(stream);
        stream = zip.uncompress(zip.entries[0]);
      }

      if (stream != null) {
        stream.endian = endian;
        stream.position = 0;
        loader(stream);
        if (version != 0) setup();
      }
      return version;
    }

    public function play(processor:Sound = null):Int {
      if (version == 0) return 0;
      if (soundPos == 0.0) initialize();
      sound = if (processor != null) processor else new Sound();

      if (quality != 0 && Std.is(hardware , Soundblaster)) {
        sound.addEventListener(SampleDataEvent.SAMPLE_DATA, hardware.accurate);
      } else {
        sound.addEventListener(SampleDataEvent.SAMPLE_DATA, hardware.fast);
      }

      soundChan = sound.play(soundPos);
      soundChan.addEventListener(Event.SOUND_COMPLETE, completeHandler);
      soundPos = 0.0;
      return 1;
    }

    public function pause() {
      if (version == 0 || soundChan == null) return;
      soundPos = soundChan.position;
      removeEvents();
    }

    public function stop() {
      if (version == 0) return;
      if (soundChan != null) removeEvents();
      soundPos = 0.0;
      reset();
    }

    public function process() { }

    public function fast() { }

    public function accurate() { }

    function setup() { }

    //js function reset
    function initialize() {
      tick = 0;
      hardware.initialize();
      hardware.samplesTick = Std.int(110250 / tempo);
    }

    function reset() { }

    function loader(stream:ByteArray) { }

    function completeHandler(e:Event) {
      stop();
      dispatchEvent(e);
    }

    function removeEvents() {
      soundChan.stop();
      soundChan.removeEventListener(Event.SOUND_COMPLETE, completeHandler);
      soundChan.dispatchEvent(new Event(Event.SOUND_COMPLETE));

      if (quality != 0) {
        sound.removeEventListener(SampleDataEvent.SAMPLE_DATA, hardware.accurate);
      } else {
        sound.removeEventListener(SampleDataEvent.SAMPLE_DATA, hardware.fast);
      }
    }
  }
