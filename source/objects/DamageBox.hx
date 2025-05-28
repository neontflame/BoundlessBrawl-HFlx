package objects;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxColor;

class DamageBox extends FlxSprite
{
	public var sprTracker:Dynamic;
	
	public var damage:Float = 0;
	public var knockback:Float = 0;
	public var hurtFrames:Int = 0;
	public var hitstun:Float = 0;
	public var coolOffset:Array<Float> = [0, 0];
	
	public var type:String = "default"; // just here for posterity in case i wanna do cool shit with it later
	
	public function new(_sprTracker:Dynamic, x:Float, y:Float, size:Int, _angle:Float, _damage:Float, _knockback:Float, _hurtFrames:Int, _hitstun:Float, ?_type:String = "default") {
		super(x, y);
		makeGraphic(size, size, 0x55FFFFFF);
		
		angle = _angle;
		damage = _damage;
		knockback = _knockback;
		hurtFrames = _hurtFrames;
		hitstun = _hitstun; // in seconds!! remember always
		
		sprTracker = _sprTracker;
		
		if (sprTracker != null)
			coolOffset = [x, y];
		
		updateHitbox(); // i think?
			
		origin.set(size / 2, size / 2); // middle origin!

	}
	
	override public function update(elapsed:Float)
	{
		if (sprTracker != null) {
			if (Std.isOfType(sprTracker, Fighter)) {
				var offsetX = (sprTracker.fitSprite.flipX ? -coolOffset[0] : coolOffset[0]);
				setPosition(sprTracker.hitbox.x + offsetX, sprTracker.hitbox.y + coolOffset[1]);
			} else {
				var offsetX = (sprTracker.flipX ? -coolOffset[0] : coolOffset[0]);
				setPosition(sprTracker.x + coolOffset[0], sprTracker.y + coolOffset[1]);
			}
		}
		
		for (fit in BattleState.instance.fighterlist)
		{
			if (FlxG.overlap(this, fit.hitbox) && fit != this.sprTracker)
			{
				checkCollision(fit);
			}
		}
	
		super.update(elapsed);
	}
	
	public function checkCollision(fighter:Fighter) {
		if (FlxG.collide(this, fighter.hitbox)) {
			fighter.damage(angle, damage, knockback, hurtFrames, hitstun);
			destroy();
		}
	}
}
