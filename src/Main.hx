package;

import openfl.display.Sprite;
import openfl.net.URLRequest;
import openfl.events.Event;
import openfl.geom.Vector3D;
import openfl.Vector;
import openfl.events.MouseEvent;
import openfl.events.KeyboardEvent;
import openfl.ui.Keyboard;

import away3d.containers.View3D;
import away3d.lights.DirectionalLight;
import away3d.materials.lightpickers.StaticLightPicker;
import away3d.entities.Mesh;
import away3d.primitives.SphereGeometry;
import away3d.library.Asset3DLibrary;
import away3d.loaders.parsers.AWDParser;
import away3d.loaders.Loader3D;
import away3d.events.Asset3DEvent;
import away3d.library.assets.IAsset;
import away3d.library.assets.Asset3DType;
import away3d.materials.TextureMaterial;
import away3d.utils.Cast;
import openfl.display.BitmapData;

import openfl.Assets;

class Main extends Sprite
{
	//engine variables
	var _view:View3D;
	
	//light objects
	var _light:DirectionalLight;
	var _lightPicker:StaticLightPicker;
	var _direction:Vector3D;

	//controls
	static inline var MOVESPEED_DEFAULT:Int = 100;
	static inline var TURNSPEED_DEFAULT:Int = 5;
	var _movespeed:Int = MOVESPEED_DEFAULT;
	var _turnspeed:Int = TURNSPEED_DEFAULT;
	var _prevMouseX:Float;
    var _prevMouseY:Float;
    var _mouseMove:Bool;
	
	/**
		Constructor
	*/
	public function new()
	{
		super();
		init();
	}
	
	/**
		Global initialise function
	*/
	private function init():Void
	{
		initEngine();
		initListeners();
	}
	
	/**
		Initialise the engine
	*/
	private function initEngine():Void
	{
		_view = new View3D();
		this.addChild(_view);
		
		//set the background of the view to something suitable
		_view.backgroundColor = 0x1e2125;
		
		//setup camera
		_view.camera.z = -2000;
		_view.camera.y += 300;
		_view.camera.lens.far = 100000;
		
		//stats
		this.addChild(new away3d.debug.AwayFPS(_view, 10, 10, 0xffffff, 1));
	}
	
	/**
		Initialise the listeners
	*/
	private function initListeners():Void
	{
		stage.addEventListener(Event.RESIZE, onResize);
		stage.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, onMouseDown);
        stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
        stage.addEventListener(MouseEvent.RIGHT_MOUSE_UP, onMouseUp);
		stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
		stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyboardDown);
		stage.addEventListener(KeyboardEvent.KEY_UP, onKeyboardUp);
		
		onResize();
		
		addEventListener(Event.ENTER_FRAME, onEnterFrame);
		
		Asset3DLibrary.enableParser(AWDParser);

		var loader:Loader3D = new Loader3D();
		loader.loadData(Assets.getBytes('assets/test.awd'));
		_view.scene.addChild(loader);
	}
	
	/**
		render loop
	*/
	private function onEnterFrame(e:Event):Void
	{	
		_view.render();
	}
	
	/**
		stage listener for resize events
	*/
	private function onResize(e:Event = null):Void
	{
		_view.width = stage.stageWidth;
		_view.height = stage.stageHeight;
	}
	
	/**
		m+kb events
	*/
	private function onMouseDown(e:MouseEvent)
	{
		_prevMouseX = e.stageX;
        _prevMouseY = e.stageY;
        _mouseMove = true;	
	}

	private function onMouseUp(e:MouseEvent)
	{
		_mouseMove = false;
	}

	private function onMouseMove(e:MouseEvent)
	{
		if(_mouseMove) {
			_view.camera.pitch(e.stageY - _prevMouseY);
			_view.camera.yaw(e.stageX - _prevMouseX);
		}
		_prevMouseX = e.stageX;
        _prevMouseY = e.stageY;
	}

	private function onMouseWheel(e:MouseEvent)
	{
		camera_z(e.delta);
	}

	private function onKeyboardDown(e:KeyboardEvent)
	{
		switch(e.keyCode)
		{
			case Keyboard.W:
				camera_z(1);
			case Keyboard.S:
				camera_z(-1);
			case Keyboard.A:
				_view.camera.moveLeft(_movespeed);
			case Keyboard.D:
				_view.camera.moveRight(_movespeed);
			case Keyboard.E:
				_view.camera.y += _movespeed;
			case Keyboard.Q:
				_view.camera.y -= _movespeed;
			case Keyboard.SHIFT:
				_movespeed = 500;
				_turnspeed = 25;
		}
	}

	private function onKeyboardUp(e:KeyboardEvent)
	{
		switch(e.keyCode)
		{
			case Keyboard.SHIFT:
				_movespeed = MOVESPEED_DEFAULT;
				_turnspeed = TURNSPEED_DEFAULT;
		}
	}

	/**
		control functions
	**/
	private function camera_z(delta:Int)
	{
		_view.camera.moveForward(delta * _movespeed);
	}

}

