package objects;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;

class FighterSprite extends FlxSprite
{
	// TECHNICALITIES
	public var fitFolder:String = 'gameplay/fighter'; // FIGHTER FOLDER
	public var fitName:String = 'sonic'; // FIGHTER NAME INTERNALLY
	
	public var animOffsets:Map<String, Array<Dynamic>>; // ANIMATION OFFSETS
	
	public var hitboxOffset:Array<Int> = [0,0]; // HITBOX OFFSETS
	public var hitboxAnimOffset:Array<Float> = [0,0]; // HITBOX OFFSETS
	
	public function new(x:Float, y:Float, ?fitName:String = 'sonic') {
		super(x, y);
		// SETS UP EVERYTHING
		animOffsets = new Map<String, Array<Dynamic>>();
		fitFolder = 'gameplay/fighter/' + fitName;
		
		// SHEET LOADS
		trace('LOADING SPRITESHEET FROM ' + Paths.asset('spritesheet.png', fitFolder));
		frames = Paths.getSparrowAtlas('spritesheet', fitFolder);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
	
	public function animAdd(name:String, internalName:String, offset:Array<Int>, framerate:Int = 24, loop:Bool = false) {
		trace(fitName + ' NEW ANIM: ' + name + ' (' + internalName + ')');
		animation.addByPrefix(name, internalName, framerate, loop);
		animOffsets[name] = [offset[0], offset[1]];
	}

	public function animPlay(animName:String, force:Bool = false, reversed:Bool = false, frame:Int = 0):Void {
		var daOffset = animOffsets.get(animName);
		if (animOffsets.exists(animName)) {
			hitboxAnimOffset = [(flipX ? (daOffset[0] * -1) : daOffset[0]), daOffset[1]];
		} else
			hitboxAnimOffset = [0, 0];
			
		animation.play(animName, force, reversed, frame);
	}
}
