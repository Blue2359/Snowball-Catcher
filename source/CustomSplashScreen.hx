package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import SettingsSystem;

class CustomSplashScreen extends FlxState
{
	var _splash_text:FlxText;
	var _haxe_jam_logo:FlxSprite;

	override function create()
	{
		super.create();

		SettingsSystem.load_settings();

		if (!SettingsSystem.skip_intro)
		{
			FlxG.camera.bgColor = 0xff000000;

			_splash_text = new FlxText(5, 0, FlxG.width, "Made by Blue2359 for", 24);
			_splash_text.setBorderStyle(FlxTextBorderStyle.SHADOW, 0xffffa55b, 4);
			_splash_text.size = 24;
			_splash_text.alpha = 0;
			_splash_text.color = 0xffffe261;
			_splash_text.alignment = CENTER;
			_splash_text.screenCenter();
			_splash_text.y -= 150;
			#if desktop
			_splash_text.antialiasing = true;
			#end
			add(_splash_text);

			_haxe_jam_logo = new FlxSprite().loadGraphic("assets/images/logo/logo-with-text.png");
			_haxe_jam_logo.screenCenter();
			_haxe_jam_logo.y += 50;
			_haxe_jam_logo.scale.set(0.5, 0.5);
			_haxe_jam_logo.alpha = 0;
			#if (desktop || html5)
			_haxe_jam_logo.antialiasing = true;
			#end
			add(_haxe_jam_logo);

			// tween in
			FlxTween.tween(_splash_text, {alpha: 1}, 1, {ease: FlxEase.cubeInOut, startDelay: 0.7});
			FlxTween.tween(_haxe_jam_logo, {alpha: 1}, 1, {ease: FlxEase.cubeInOut, startDelay: 0.7});
			// tween out
			FlxTween.tween(_splash_text, {alpha: 0}, 1, {ease: FlxEase.cubeInOut, startDelay: 4});
			FlxTween.tween(_haxe_jam_logo, {alpha: 0}, 1, {ease: FlxEase.cubeInOut, startDelay: 4});

			new FlxTimer().start(7, function(tmr:FlxTimer)
			{
				FlxG.switchState(new MainMenuState());
			});
		}
		else
		{
			FlxG.switchState(new MainMenuState());
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
