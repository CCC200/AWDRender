package;

import haxe.ui.containers.menus.MenuBar;
import haxe.ui.events.MouseEvent;

import openfl.filesystem.File;
import openfl.filesystem.FileStream;
import openfl.filesystem.FileMode;
import openfl.events.Event;
import openfl.net.FileFilter;
import openfl.utils.ByteArray;

import LoadEvent;

@:build(haxe.ui.ComponentBuilder.build("assets/filemenu.xml"))
class FileMenu extends MenuBar {

    var awd:File = new File();
    var filter:FileFilter = new FileFilter("AwayBuilder", "*.awd");

    public function new() {
        super();
    }

    @:bind(open, MouseEvent.CLICK)
    private function onMenuOpen(e:MouseEvent) {
        awd.browseForOpen("Open AWD", [filter]);
        awd.addEventListener(Event.SELECT, onFileSelect);
    }

    private function onFileSelect(e:Event) {
        var stream:FileStream = new FileStream();
        var _data:ByteArray = new ByteArray();
        // read scene data
        stream.open(e.target, FileMode.READ);
        stream.readBytes(_data, 0, stream.bytesAvailable);
        stream.close();
        // dispatch for main
        var event:LoadEvent = new LoadEvent(LoadEvent.LOAD_SCENE);
        event.data = _data;
        dispatchEvent(event);
    }

    @:bind(exit, MouseEvent.CLICK)
    private function onMenuExit(e:MouseEvent) {
        Sys.exit(0);
    }
    
}
