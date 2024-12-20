package;

import openfl.events.Event;
import openfl.utils.ByteArray;

class LoadEvent extends Event
{
    public static inline var LOAD_SCENE:String = "LoadScene";

    public var data:ByteArray;

    public function new(type:String, bubbles:Bool = false, cancelable:Bool = false)
    {
        super(type, bubbles, cancelable);
    }

    public override function clone():Event
    {
        var out:LoadEvent = new LoadEvent(type, bubbles, cancelable);
        out.data = data;
        return out;
    }
}
