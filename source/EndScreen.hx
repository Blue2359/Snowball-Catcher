package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class EndScreen extends FlxSubState
{
	var _bg_sprite:FlxSprite;
	var _top_text:FlxText;
	var _text_ONE:FlxText;
	var _text_TWO:FlxText;
	var _text_score:FlxText;
	var _can_change:Bool = false;

    var _menu_buttons:Array<Int> = [0, 1];
    var _strings:Array<String> = ["Play Again", "Go to Menu"];
	var _menu_button:FlxTypedGroup<FlxText>;
	var _buttons:FlxText;
	var _selection:Int = 0;
	var _selector:FlxText;

	override public function create()
	{
		super.create();

		_bg_sprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		_bg_sprite.alpha = 0;
		_bg_sprite.scrollFactor.set(0, 0);
		add(_bg_sprite);

		_top_text = new FlxText(0, 0, FlxG.width, "Times Up!", 48);
		_top_text.setFormat(null, 48, FlxColor.WHITE, CENTER);
		_top_text.setBorderStyle(OUTLINE, FlxColor.BLACK, 1);
		_top_text.screenCenter();
		_top_text.scrollFactor.set(0, 0);
		_top_text.y -= 240;
		_top_text.borderSize = 1.3;
		_top_text.alpha = 0;
		#if desktop
		_top_text.antialiasing = true;
		#end
		add(_top_text);

		FlxTween.tween(_bg_sprite, {alpha: 0.3}, 0.3, {ease: FlxEase.quadInOut});
		FlxTween.tween(_top_text, {alpha: 1}, 0.5, {ease: FlxEase.quadInOut});
		FlxTween.tween(_top_text, {y: _top_text.y + 50}, 0.5, {ease: FlxEase.quadInOut});

		_text_ONE = new FlxText(0, 0, FlxG.width, "Total Snowballs Caught: " + PlayState._total_snowballs, 18);
		_text_ONE.setFormat(null, 18, FlxColor.WHITE, CENTER);
		_text_ONE.setBorderStyle(OUTLINE, FlxColor.BLACK, 1);
		_text_ONE.screenCenter();
		_text_ONE.scrollFactor.set(0, 0);
		_text_ONE.y -= 80;
		_text_ONE.alpha = 0;
		#if desktop
		_text_ONE.antialiasing = true;
		#end
		add(_text_ONE);

		_text_TWO = new FlxText(0, 0, FlxG.width, "Total Harmful Snowballs Caught: " + PlayState._total_snowballs_DEADLY, 18);
		_text_TWO.setFormat(null, 18, FlxColor.WHITE, CENTER);
		_text_TWO.setBorderStyle(OUTLINE, FlxColor.BLACK, 1);
		_text_TWO.screenCenter();
		_text_TWO.scrollFactor.set(0, 0);
		_text_TWO.y -= 40;
		_text_TWO.alpha = 0;
		#if desktop
		_text_TWO.antialiasing = true;
		#end
		add(_text_TWO);

		_text_score = new FlxText(0, 0, FlxG.width, "Total Score: " + PlayState._total_score, 18);
		_text_score.setFormat(null, 18, FlxColor.WHITE, CENTER);
		_text_score.setBorderStyle(OUTLINE, FlxColor.BLACK, 1);
		_text_score.screenCenter();
		_text_score.scrollFactor.set(0, 0);
		_text_score.alpha = 0;
		#if desktop
		_text_score.antialiasing = true;
		#end
		add(_text_score);

		FlxTween.tween(_text_ONE, {alpha: 1}, 0.5, {ease: FlxEase.quadInOut, startDelay: 0.4});
		FlxTween.tween(_text_ONE, {y: _text_ONE.y + 20}, 0.5, {ease: FlxEase.quadInOut, startDelay: 0.4});
		FlxTween.tween(_text_TWO, {alpha: 1}, 0.5, {ease: FlxEase.quadInOut, startDelay: 0.8});
		FlxTween.tween(_text_TWO, {y: _text_TWO.y + 20}, 0.5, {ease: FlxEase.quadInOut, startDelay: 0.8});
		FlxTween.tween(_text_score, {alpha: 1}, 0.5, {ease: FlxEase.quadInOut, startDelay: 1.2});
		FlxTween.tween(_text_score, {y: _text_score.y + 20}, 0.5, {ease: FlxEase.quadInOut, startDelay: 1.2});

		_menu_button = new FlxTypedGroup<FlxText>();
		add(_menu_button);

		for (i in 0..._menu_buttons.length)
		{
			_buttons = new FlxText(0, 0, _strings[i], 20);
			_buttons.ID = i;
			_buttons.borderStyle = OUTLINE;
			_buttons.borderColor = FlxColor.BLACK;
			_buttons.screenCenter();
			_buttons.y += (i * 40) + 90;
            _buttons.scrollFactor.set(0, 0);
			#if desktop
			_buttons.antialiasing = true;
			#end
			_menu_button.add(_buttons);
		}

		_selector = new FlxText(_buttons.x - 33, _buttons.y, ">", 20);
		_selector.antialiasing = false;
		_selector.borderStyle = OUTLINE;
		_selector.borderColor = FlxColor.BLACK;
		_selector.scrollFactor.set(0, 0);
		#if desktop
		_selector.antialiasing = true;
		#end
		add(_selector);
        FlxTween.tween(_selector, {x: _selector.x + 6}, 1.5, {ease: FlxEase.quadInOut, type: PINGPONG});

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
			switch (_menu_buttons[_selection]) // do an action for each different selected button.
			{
				case 0:
					FlxG.resetState();
					trace("case 0");
				case 1:
					FlxG.switchState(new MainMenuState());
					trace("case 1");
			}
		}
		#end
	}

	function change_selection(_option:Int = 0)
	{
		_selection += _option;

		if (_selection < 0)
			_selection = _menu_buttons.length - 1;
		if (_selection >= _menu_buttons.length)
			_selection = 0;

		switch (_menu_buttons[_selection]) // re-position _selector.
		{
			case 0:
				_selector.y = _buttons.y - 40;
			case 1:
				_selector.y = _buttons.y;
		}

		#if debug
		trace("chosen option: " + _menu_buttons[_selection]);
		#end
	}
}
