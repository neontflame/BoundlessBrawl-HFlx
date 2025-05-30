package objects;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxColor;

class Hitbox extends FlxSprite
{
	public var gravEnabled:Bool = true;
	public var gravValue:Float = 1000;
	public var gravMultiplier:Float = 1;
	// public var maxGravValue:Float = 1000;
	
	public var fallingOffJumpthru:Bool = false;
	public var jumpthruFalloffTimer:Float = 1;
	
	public function new(x:Float, y:Float, ?wid:Int = 32, ?hei:Int = 32) {
		super(x, y);
		makeGraphic(wid, hei, 0x55FFFFFF);
		updateHitbox(); // i think?
			
		origin.set(wid / 2, hei); // bottom middle origin!
	}
	
	public function changeSize(wid:Int, hei:Int) {
		makeGraphic(wid, hei, 0x55FFFFFF);
		width = wid;
		height = hei;
		updateHitbox();
		
		origin.set(wid / 2, hei);
	}
	
	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		
		if (jumpthruFalloffTimer > 0) {
			jumpthruFalloffTimer -= 1;
		}
	}
	
	public function physUpdate(floor, jumpthru) {
		// maxVelocity.y = maxGravValue;
		
		if (gravEnabled) {
			acceleration.y = gravValue * gravMultiplier;
		} else {
			acceleration.y = 0;
		}
		
		//bump the player up against the level
		FlxG.collide(this, floor);
		if (jumpthruFalloffTimer <= 0) FlxG.collide(this, jumpthru);
	}
}
