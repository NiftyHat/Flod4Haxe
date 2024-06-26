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
package neoart.flod.core {

  public final class SBChannel {
    
    public var next        : SBChannel;
    public var mute        : int;
    public var enabled     : int;
    public var sample      : SBSample;
    public var length      : int;
    public var index       : int;
    public var pointer     : int;
    public var delta       : int;
    public var fraction    : Number;
    public var speed       : Number;
    public var dir         : int;
    public var oldSample   : SBSample;
    public var oldLength   : int;
    public var oldPointer  : int;
    public var oldFraction : Number;
    public var oldSpeed    : Number;
    public var oldDir      : int;
    public var volume      : Number;
    public var lvol        : Number;
    public var rvol        : Number;
    public var panning     : int;
    public var lpan        : Number;
    public var rpan        : Number;
    public var ldata       : Number;
    public var rdata       : Number;
    public var mixCounter  : int;
    public var lmixRampU   : Number;
    public var lmixDeltaU  : Number;
    public var rmixRampU   : Number;
    public var rmixDeltaU  : Number;
    public var lmixRampD   : Number;
    public var lmixDeltaD  : Number;
    public var rmixRampD   : Number;
    public var rmixDeltaD  : Number;
    public var volCounter  : int;
    public var lvolDelta   : Number;
    public var rvolDelta   : Number;
    public var panCounter  : int;
    public var lpanDelta   : Number;
    public var rpanDelta   : Number;

    internal function initialize():void {
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
  }
}