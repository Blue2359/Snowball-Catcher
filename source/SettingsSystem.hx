package;

import flixel.FlxG;
import flixel.util.FlxSave;

class SettingsSystem
{
    public static var skip_intro:Bool = false;
	public static var background_visibility:Bool = true;
	public static var particles_visibility:Bool = true;
	public static var endless_mode:Bool = false;

	public static function load_settings()
	{
        if (FlxG.save.data.skip_intro != null)
			skip_intro = FlxG.save.data.skip_intro;
		if (FlxG.save.data.background_visibility != null)
			background_visibility = FlxG.save.data.background_visibility;
		if (FlxG.save.data.particles_visibility != null)
			particles_visibility = FlxG.save.data.particles_visibility;
		if (FlxG.save.data.endless_mode != null)
			endless_mode = FlxG.save.data.endless_mode;

		// load settings.
		var save:FlxSave = new FlxSave();
		save.bind('_game_settings', 'blue2359_snowball_catcher');
		trace("loaded game settings.");
	}

	public static function save_settings()
	{
        FlxG.save.data.skip_intro = skip_intro;
		FlxG.save.data.background_visibility = background_visibility;
		FlxG.save.data.particles_visibility = particles_visibility;
		FlxG.save.data.endless_mode = endless_mode;

		FlxG.save.flush();

		// save settings.
		var save:FlxSave = new FlxSave();
		save.bind('_game_settings', 'blue2359_snowball_catcher');
		save.flush();
		trace("game settings saved.");
	}
}