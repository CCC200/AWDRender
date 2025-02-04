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
import CameraEvent;

@:build(haxe.ui.ComponentBuilder.build("assets/filemenu.xml"))
class FileMenu extends MenuBar {

    var awd:File = new File();
    var filter:FileFilter = new FileFilter("AwayBuilder", "*.awd");

    public function new() {
        super();
        awd.addEventListener(Event.SELECT, onFileSelect);
    }

    public function triggerFileOpen() {
        awd.browseForOpen("Open AWD", [filter]);
    }

    @:bind(open, MouseEvent.CLICK)
    private function onMenuOpen(e:MouseEvent) {
        triggerFileOpen();
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

    @:bind(reset, MouseEvent.CLICK)
    private function onMenuReset(e:MouseEvent) {
        // dispatch for main
        var event:CameraEvent = new CameraEvent(CameraEvent.CAMERA_RESET);
        dispatchEvent(event);
    }
    
}
