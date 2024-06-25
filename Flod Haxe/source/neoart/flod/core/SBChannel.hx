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

   final class SBChannel {
    
    public var next        : SBChannel;
    public var mute        : Int = 0;
    public var enabled     : Int = 0;
    public var sample      : SBSample;
    public var length      : Int = 0;
    public var index       : Int = 0;
    public var pointer     : Int = 0;
    public var delta       : Int = 0;
    public var fraction    : Float = Math.NaN;
    public var speed       : Float = Math.NaN;
    public var dir         : Int = 0;
    public var oldSample   : SBSample;
    public var oldLength   : Int = 0;
    public var oldPointer  : Int = 0;
    public var oldFraction : Float = Math.NaN;
    public var oldSpeed    : Float = Math.NaN;
    public var oldDir      : Int = 0;
    public var volume      : Float = Math.NaN;
    public var lvol        : Float = Math.NaN;
    public var rvol        : Float = Math.NaN;
    public var panning     : Int = 0;
    public var lpan        : Float = Math.NaN;
    public var rpan        : Float = Math.NaN;
    public var ldata       : Float = Math.NaN;
    public var rdata       : Float = Math.NaN;
    public var mixCounter  : Int = 0;
    public var lmixRampU   : Float = Math.NaN;
    public var lmixDeltaU  : Float = Math.NaN;
    public var rmixRampU   : Float = Math.NaN;
    public var rmixDeltaU  : Float = Math.NaN;
    public var lmixRampD   : Float = Math.NaN;
    public var lmixDeltaD  : Float = Math.NaN;
    public var rmixRampD   : Float = Math.NaN;
    public var rmixDeltaD  : Float = Math.NaN;
    public var volCounter  : Int = 0;
    public var lvolDelta   : Float = Math.NaN;
    public var rvolDelta   : Float = Math.NaN;
    public var panCounter  : Int = 0;
    public var lpanDelta   : Float = Math.NaN;
    public var rpanDelta   : Float = Math.NaN;

    @:allow(neoart.flod.core) function initialize() {
      enabled     = 0;
      sample      = null;
      length      = 0;
      index       = 0;
      pointer     = 0;
      delta       = 0;
      fraction    = 0.0;
      speed       = 0.0;
      dir         = 0;
      oldSample   = null;
      oldLength   = 0;
      oldPointer  = 0;
      oldFraction = 0.0;
      oldSpeed    = 0.0;
      oldDir      = 0;
      volume      = 0.0;
      lvol        = 0.0;
      rvol        = 0.0;
      panning     = 128;
      lpan        = 0.5;
      rpan        = 0.5;
      ldata       = 0.0;
      rdata       = 0.0;
      mixCounter  = 0;
      lmixRampU   = 0.0;
      lmixDeltaU  = 0.0;
      rmixRampU   = 0.0;
      rmixDeltaU  = 0.0;
      lmixRampD   = 0.0;
      lmixDeltaD  = 0.0;
      rmixRampD   = 0.0;
      rmixDeltaD  = 0.0;
      volCounter  = 0;
      lvolDelta   = 0.0;
      rvolDelta   = 0.0;
      panCounter  = 0;
      lpanDelta   = 0.0;
      rpanDelta   = 0.0;
    }
public function new(){}
  }
