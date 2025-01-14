package;

import openfl.events.Event;
import openfl.utils.ByteArray;

class CameraEvent extends Event
{
    public static inline var CAMERA_RESET:String = "CameraReset";

    public function new(type:String, bubbles:Bool = false, cancelable:Bool = false)
    {
        super(type, bubbles, cancelable);
    }

    public override function clone():Event
    {
        var out:CameraEvent = new CameraEvent(type, bubbles, cancelable);
        return out;
    }
}
