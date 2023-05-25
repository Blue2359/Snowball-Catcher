package;

import flixel.FlxG;
import flixel.FlxSprite;

enum SnowballType
{
	NORMAL;
	DEADLY;
}

class SnowBall extends FlxSprite
{
	public var _snowball_type:SnowballType;

	public function new(x:Float = 0, y:Float = 0, type:SnowballType)
	{
		super(x, y);

		_snowball_type = type;
		var _type_graphic = (type == DEADLY ? "assets/images/game/snowball_DEADLY.png" : "assets/images/game/snowball.png");
		loadGraphic(_type_graphic);
		scale.set(0.2, 0.2);
		antialiasing = false;
		updateHitbox();
		
		type == DEADLY ? velocity.y = 350 : velocity.y = FlxG.random.int(180, 250);
		
		angle = FlxG.random.int(0, 35);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		// rotate.
		angle -= 40 * elapsed;
	}

	// kills/destroys the snowball.
	override public function kill()
	{
		super.kill();
		destroy();
	}
}
