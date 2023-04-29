package;

import flixel.FlxG;
import flixel.FlxSprite;

enum CheckboxType
{
	ACTIVE;
	DEACTIVE;
}

class CheckBox extends FlxSprite
{
	public var type:CheckboxType;

	public function new(x:Float = 0, y:Float = 0, type:CheckboxType)
	{
		super(x, y);

		this.type = type;

		loadGraphic("assets/images/game/checkbox.png", true, 240, 240);
		animation.add("active", [0], 1, true);
		animation.add("deactive", [1], 1, true);
		scale.set(0.2, 0.2);
		antialiasing = false;
		color = 0xffFFF8D5;
		updateHitbox();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		type == DEACTIVE ? animation.play("deactive", true) : animation.play("active", true);
	}
}
