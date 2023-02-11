package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxStringUtil;
import flixel.addons.display.FlxBackdrop;
import flixel.effects.particles.FlxEmitter;
import SettingsSystem;

class PlayState extends FlxState
{
	var _background:FlxSprite;
	var _clouds_backdrop:FlxBackdrop;

	var _snowball1:SnowBall;
	var _snowball2:SnowBall;
	var _snowball3:SnowBall;
	
	var _catcher:FlxSprite;
	var _score_text:FlxText;
	var _score:Int;

	// for end screen.
	public static var _total_score:Int;
	public static var _total_snowballs:Int;
	public static var _total_snowballs_DEADLY:Int;

	var _timer:Float;
	var _timer_text:FlxText;

	override public function create()
	{
		super.create();

		FlxG.camera.bgColor = 0xffA9D1FF;

		// reset variables when entered the state.
		_score = 0;
		_total_score = 0;
		_total_snowballs = 0;
		_total_snowballs_DEADLY = 0;
		
		if (!SettingsSystem.endless_mode)
			_timer = 120; // 2 minutes.

		_background = new FlxSprite().loadGraphic("assets/images/game/background.png");
		_background.screenCenter();
		add(_background);

		_clouds_backdrop = new FlxBackdrop("assets/images/game/clouds.png", 0, 0, true, true, 150, 500);
		_clouds_backdrop.x -= FlxG.random.int(240, 360);
		_clouds_backdrop.y -= 240;
		_clouds_backdrop.scale.set(1.5, 1.5);
		_clouds_backdrop.velocity.set(25, 0);
		_clouds_backdrop.updateHitbox();
		add(_clouds_backdrop);

		if (SettingsSystem.background_visibility)
		{
			_background.visible = true;
			_clouds_backdrop.visible = true;
		}	
		else
		{
			_background.visible = false;
			_clouds_backdrop.visible = false;
		}	

		add(_snowball1 = new SnowBall(FlxG.random.int(20, 120), -70, NORMAL));
		add(_snowball2 = new SnowBall(FlxG.random.int(190, 240), -70, NORMAL));
		add(_snowball3 = new SnowBall(FlxG.random.int(350, 440), -70, NORMAL));

		add(_catcher = new FlxSprite().makeGraphic(150, 20, 0xffffffff));
		_catcher.screenCenter();
		_catcher.y += 170;
		_catcher.immovable = true;

		_score_text = new FlxText(0, 0, FlxG.width, "Hello World!", 36);
		_score_text.setFormat(null, 36, FlxColor.WHITE, CENTER);
		_score_text.setBorderStyle(OUTLINE, FlxColor.BLACK, 1);
		_score_text.screenCenter();
		_score_text.y -= 250;
		#if desktop
		_score_text.antialiasing = true;
		#end
		add(_score_text);

		_timer_text = new FlxText(10, 10, FlxG.width, "", 14);
		_timer_text.setFormat(null, 14, FlxColor.WHITE, LEFT);
		_timer_text.setBorderStyle(OUTLINE, FlxColor.BLACK, 0.75);
		#if desktop
		_timer_text.antialiasing = true;
		#end
		add(_timer_text);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (!SettingsSystem.endless_mode)
		{
			_timer -= elapsed;

			_timer_text.text = "Time Remaining: " + FlxStringUtil.formatTime(_timer, false);

			if (_timer < 0)
				openSubState(new EndScreen());
		}

		#if (desktop || html5)
		if (FlxG.keys.anyJustPressed([ESCAPE, BACKSPACE]))
			FlxG.switchState(new MainMenuState());

		if (FlxG.keys.anyPressed([LEFT, A]))
			_catcher.x -= 180 * elapsed; // move _catcher to the left.
		if (FlxG.keys.anyPressed([RIGHT, D]))
			_catcher.x += 180 * elapsed; // move _catcher to the right.
		#end

		// don't allow the _catcher to go off view.
		if (_catcher.x <= 0)
		{
			_catcher.x = 0;
		}
		if ((_catcher.x + _catcher.width) > FlxG.width)
		{
			_catcher.x = FlxG.width - _catcher.width;
		}

		FlxG.collide(_snowball1, _catcher, collected_snowball);
		FlxG.collide(_snowball2, _catcher, collected_snowball);
		FlxG.collide(_snowball3, _catcher, collected_snowball);

		spawn_snowball();
		kill_snowball();

		// update _score_text.
		_score_text.text = Std.string(_score);

		if (_score < 0) // don't let it go below 0.
			_score = 0;

		// FlxG.watch.add(_snowball1, "alive", "_snowball1 alive?");
		// FlxG.watch.add(_snowball2, "alive", "_snowball2 alive?");
		// FlxG.watch.add(_snowball3, "alive", "_snowball3 alive?");
	}

	function spawn_snowball()
	{
		if (!_snowball1.alive)
		{
			if (FlxG.random.bool(30))
				add(_snowball1 = new SnowBall(FlxG.random.int(20, 120), -70, DEADLY));
			else
				add(_snowball1 = new SnowBall(FlxG.random.int(20, 120), -70, NORMAL));
		}
		if (!_snowball2.alive)
		{
			if (FlxG.random.bool(30))
				add(_snowball2 = new SnowBall(FlxG.random.int(190, 240), -70, DEADLY));
			else
				add(_snowball2 = new SnowBall(FlxG.random.int(190, 240), -70, NORMAL));
		}
		if (!_snowball3.alive)
		{
			if (FlxG.random.bool(30))
				add(_snowball3 = new SnowBall(FlxG.random.int(350, 440), -70, DEADLY));
			else
				add(_snowball3 = new SnowBall(FlxG.random.int(350, 440), -70, NORMAL));
		}
	}

	function collected_snowball(objA:SnowBall, objB:FlxSprite)
	{
		if (objA.justTouched(FLOOR))
		{
			objA.kill();

			if (objA._snowball_type == DEADLY)
			{
				if (_score > 0 || _score != 0)
					_score -= 5;

				FlxG.camera.shake(0.03, 0.08);
				_total_snowballs_DEADLY++;
			}
			else
			{
				_score++;
				_total_snowballs++;
			}

			if (!SettingsSystem.endless_mode)
				_total_score++; // add up the total score you have instead of your game score.

			if (SettingsSystem.particles_visibility)
			{
				var _type_graphic = (if (objA._snowball_type == DEADLY) "assets/images/game/snowball_particles_DEADLY.png" else "assets/images/game/snowball_particles.png");
				var _snowball_particle:FlxEmitter = new FlxEmitter().loadParticles(_type_graphic, 60, 29, true);
				_snowball_particle.velocity.set(-200, -200, 200, 200);
				_snowball_particle.angularVelocity.set(-500, 500);
				_snowball_particle.acceleration.set(0, 250);
				add(_snowball_particle);

				if (_snowball_particle != null)
				{
					_snowball_particle.focusOn(objA);
					_snowball_particle.start(true, 1, 8);
				}
			}
		}
	}

	function kill_snowball()
	{
		if (_snowball1.y > FlxG.height + 30)
		{
			_snowball1.kill();
		}
		if (_snowball2.y > FlxG.height + 30)
		{
			_snowball2.kill();
		}
		if (_snowball3.y > FlxG.height + 30)
		{
			_snowball3.kill();
		}
	}
}
