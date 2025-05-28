package objects;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import objects.Fighter;
import objects.FighterSprite;
import objects.Hitbox;

class DamageBox extends FlxSprite
{
	public var sprTracker:FlxSprite;
	
	public var damage:Float = 0;
	public var knockback:Float = 0;
	public var hurtFrames:Int = 0;
	public var hitstun:Float = 0;
	public var coolOffset:Array<Float> = [0, 0];
	
	public var type:String = "default"; // just here for posterity in case i wanna do cool shit with it later
	
	public function new(x:Float, y:Float, size:Int) {
		super(x, y);
		makeGraphic(size, size, 0x55FFFFFF);
	
		coolOffset = [x, y];
		
		updateHitbox(); // i think?
			
		origin.set(size / 2, size / 2); // middle origin!

	}
	
	public function changeInfo(_angle:Float, _damage:Float, _knockback:Float, _hurtFrames:Int, _hitstun:Float, ?_type:String = "default") {
		angle = _angle;
		damage = _damage;
		knockback = _knockback;
		hurtFrames = _hurtFrames;
		hitstun = _hitstun; // in seconds!! remember always
		type = _type;
	}
	
	override public function update(elapsed:Float)
	{
		if (sprTracker != null) {
			if (Std.isOfType(sprTracker, Fighter)) {
				var fit = cast(sprTracker, Fighter);
				var offsetX = (fit.fitSprite.flipX ? -coolOffset[0] : coolOffset[0]);
				
				setPosition(fit.hitbox.x + offsetX, fit.hitbox.y + coolOffset[1]);
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
			if (fighter.status != "airdodge") {
				fighter.damage(angle, damage, knockback, hurtFrames, hitstun);
				
				if (type != "multiDamage") {
					destroy();
				}
			}
		}
	}
}
