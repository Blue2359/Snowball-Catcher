package;

import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxState;
import openfl.display.FPS;
import openfl.display.Sprite;

class Main extends Sprite
{
	var state:Class<FlxState> = CustomSplashScreen;
	var skipHFsplash:Bool = true;
	var game_width:Int = 500;
	var game_height:Int = 660;
	var zoom:Float = 1.0;
	var fps:Int = 60;

	public function new()
	{
		super();
		addChild(new FlxGame(game_width, game_height, state, zoom, fps, fps, skipHFsplash));

		#if (desktop || html5)
		FlxG.mouse.useSystemCursor = true;
		FlxG.autoPause = false;
		#end
	}
}
