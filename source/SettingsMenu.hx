package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import SettingsSystem;
import CheckBox;

class SettingsMenu extends FlxState
{
    var _ice:FlxSprite;
    var _settings_title:FlxSprite;
    var _selection:Int = 0;
    var _selector:FlxText;

    var _total_menu_buttons:Array<Int> = [0, 1, 2, 3, 4];
    var _strings:Array<String> = ["Skip Intro", "BG Visible", "Particles", "Endless Mode", "Back"];
	var _menu_button:FlxTypedGroup<FlxText>;
	var _buttons:FlxText;

    var _checkbox_ONE:CheckBox;
    var _checkbox_TWO:CheckBox;
    var _checkbox_THREE:CheckBox;
    var _checkbox_FOUR:CheckBox;

    override public function create():Void
    {
        super.create();

        FlxG.camera.bgColor = 0xff56628a;

        SettingsSystem.load_settings();

        _ice = new FlxSprite().loadGraphic("assets/images/game/screen_ice.png");
		_ice.screenCenter();
		add(_ice);

        _settings_title = new FlxSprite().loadGraphic("assets/images/game/buttons/button1.png");
		_settings_title.screenCenter(Y);
        _settings_title.x += 170;
		_settings_title.y -= 165;
        _settings_title.scale.set(1.6, 1.6);
		add(_settings_title);
        FlxTween.tween(_settings_title, {y: _settings_title.y + 10}, 1.5, {ease: FlxEase.quadInOut, type: PINGPONG});

        _menu_button = new FlxTypedGroup<FlxText>();
		add(_menu_button);

        for (i in 0..._total_menu_buttons.length)
		{
			_buttons = new FlxText(FlxG.width / 2, FlxG.height / 2, _strings[i], 32);
			_buttons.ID = i;
            _buttons.color = 0xffFFF8D5;
			_buttons.y += (i * 70) - 70;
			_buttons.x -= 95;
			_menu_button.add(_buttons);
		}

        // theres probably a better way to do this but whatever :p
        _checkbox_ONE = new CheckBox(85, _buttons.y - 282, null);
        add(_checkbox_ONE);
        _checkbox_TWO = new CheckBox(85, _buttons.y - 212, null);
        add(_checkbox_TWO);
        _checkbox_THREE = new CheckBox(85, _buttons.y - 142, null);
        add(_checkbox_THREE);
        _checkbox_FOUR = new CheckBox(85, _buttons.y - 72, null);
        add(_checkbox_FOUR);
        update_checkboxes();

        _selector = new FlxText(_buttons.x - 110, _buttons.y, ">", 32);
		_selector.color = 0xffFFF8D5;
		_selector.antialiasing = false;
		_selector.scrollFactor.set();
		add(_selector);
        FlxTween.tween(_selector, {x: _selector.x + 6}, 1.5, {ease: FlxEase.quadInOut, type: PINGPONG});

        change_selection();
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);

        #if (desktop || html5)
		if (FlxG.keys.anyJustPressed([UP, W]))
			change_selection(-1);
		if (FlxG.keys.anyJustPressed([DOWN, S]))
			change_selection(1);

            if (FlxG.keys.anyJustPressed([ENTER, SPACE]))
            {
                switch (_total_menu_buttons[_selection]) // do an action for each different chosen button.
                {
                    case 0: // Skip Intro.
                        SettingsSystem.skip_intro = !SettingsSystem.skip_intro;
                        trace("SettingsSystem.skip_intro: " + SettingsSystem.skip_intro);

                    case 1: // BG Visible.
                        SettingsSystem.background_visibility = !SettingsSystem.background_visibility;
                        trace("SettingsSystem.background_visibility: " + SettingsSystem.background_visibility);

                    case 2: // Particles.
                        SettingsSystem.particles_visibility = !SettingsSystem.particles_visibility;
                        trace("SettingsSystem.particles_visibility: " + SettingsSystem.particles_visibility);

                    case 3: // Endless Mode.
                        SettingsSystem.endless_mode = !SettingsSystem.endless_mode;
                        trace("SettingsSystem.endless_mode: " + SettingsSystem.endless_mode);

                    case 4: // Back.
                        FlxG.switchState(new MainMenuState());
                        trace("went back to main menu from settings.");
                }
				
                SettingsSystem.save_settings();
            }
		#end

        update_checkboxes();
    }

    function change_selection(_option:Int = 0)
	{
		_selection += _option;

		if (_selection < 0)
			_selection = _total_menu_buttons.length - 1;
		if (_selection >= _total_menu_buttons.length)
			_selection = 0;

		// TODO: Do this with math instead of manually positiong per item.
		switch (_total_menu_buttons[_selection]) // re-position _selector.
		{
			case 0: // Skip Intro.
				_selector.y = _buttons.y - 280;
            case 1: // BG Visible.
				_selector.y = _buttons.y - 210;
            case 2: // Particles.
				_selector.y = _buttons.y - 140;
            case 3: // Endless Mode.
				_selector.y = _buttons.y - 70;
			case 4: // Back.
				_selector.y = _buttons.y;
		}

		trace('selected option: ${_total_menu_buttons[_selection]}');
	}

    function update_checkboxes()
	{
        // for avoiding that split second-ish animation change for the checkboxes when entered the state.
        
        // checkbox one.
        if (SettingsSystem.skip_intro)
            _checkbox_ONE.type = ACTIVE;
        else
            _checkbox_ONE.type = DEACTIVE;

        // checkbox two.
        if (SettingsSystem.background_visibility)
            _checkbox_TWO.type = ACTIVE;
        else
            _checkbox_TWO.type = DEACTIVE;

        // checkbox three.
        if (SettingsSystem.particles_visibility)
            _checkbox_THREE.type = ACTIVE;
        else
            _checkbox_THREE.type = DEACTIVE;

        // checkbox four.
        if (SettingsSystem.endless_mode)
            _checkbox_FOUR.type = ACTIVE;
        else
            _checkbox_FOUR.type = DEACTIVE;
	}
}
