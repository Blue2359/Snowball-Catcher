package;

import flash.system.System;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class MainMenuState extends FlxState
{
	var _ice:FlxSprite;
	var _title_logo:FlxSprite;
	var _selection:Int = 0;
	var _selector:FlxText;
	var _menu_buttons:Array<Int> = [0, 1, 2];
	var _menu_button:FlxTypedGroup<FlxSprite>;
	var _buttons:FlxSprite;

	override public function create()
	{
		super.create();

		FlxG.camera.bgColor = 0xff56628a;

		_title_logo = new FlxSprite().loadGraphic("assets/images/game/title.png");
		_title_logo.screenCenter(Y);
		_title_logo.x += 75;
		_title_logo.y -= 110;
		add(_title_logo);
		FlxTween.tween(_title_logo, {y: _title_logo.y + 10}, 1.5, {ease: FlxEase.quadInOut, type: PINGPONG});

		_ice = new FlxSprite().loadGraphic("assets/images/game/screen_ice.png");
		_ice.screenCenter();
		add(_ice);

		_menu_button = new FlxTypedGroup<FlxSprite>();
		add(_menu_button);

		for (i in 0..._menu_buttons.length)
		{
			_buttons = new FlxSprite(FlxG.width / 2, FlxG.height / 2).loadGraphic('assets/images/game/buttons/button${_menu_buttons[i]}.png');
			_buttons.ID = i;
			_buttons.y += (i * 70) + 55;
			_buttons.x -= 55;
			_menu_button.add(_buttons);

			switch (i)
			{
				case 1:
					_buttons.x -= 15;
				#if html5
				case 2:
					_buttons.color = 0xff878371;
				#end
			}
		}

		_selector = new FlxText(_buttons.x - 30, _buttons.y - 125, ">", 32);
		_selector.color = 0xffFFF8D5;
		_selector.antialiasing = false;
		_selector.scrollFactor.set();
		add(_selector);

		change_selection();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		#if (desktop || html5)
		if (FlxG.keys.anyJustPressed([UP, W]))
			change_selection(-1);
		if (FlxG.keys.anyJustPressed([DOWN, S]))
			change_selection(1);

		if (FlxG.keys.anyJustPressed([ENTER, SPACE]))
		{
			switch (_menu_buttons[_selection]) // do an action for each different chosen button.
			{
				case 0:
					FlxG.switchState(new PlayState());
				case 1:
					FlxG.switchState(new SettingsMenu());
				#if !html5
				case 2:
					System.exit(0);
				#end
			}
					
			trace('chosen option: ${_menu_buttons[_selection]}');
		}
		#end
	}

	function change_selection(_option:Int = 0)
	{
		_selection += _option;

		#if html5
		if (_selection < 0)
			_selection = _menu_buttons.length - 2;
		else if (_selection >= _menu_buttons.length - 1)
			_selection = 0;
		#else
		if (_selection < 0)
			_selection = _menu_buttons.length - 1;
		else if (_selection >= _menu_buttons.length)
			_selection = 0;
		#end

		// TODO: Do this with math instead of manually positiong per item.
		switch (_menu_buttons[_selection]) // re-position _selector.
		{
			case 0:
				_selector.y = _buttons.y - 125;
				_selector.x = _buttons.x - 30;
			case 1:
				_selector.y = _buttons.y - 65;
				_selector.x = _buttons.x - 50;
			#if !html5
			case 2:
				_selector.y = _buttons.y;
				_selector.x = _buttons.x - 35;
			#end
		}

		trace('selected option: ${_menu_buttons[_selection]}');
	}
}
