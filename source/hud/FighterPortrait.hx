package hud;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxDirectionFlags;
import flixel.util.FlxTimer;
import flixel.util.FlxTimer.FlxTimerManager;
import flixel.math.FlxMath;
import flixel.math.FlxAngle;

import backend.IrisHandler;

import objects.fighter.Fighter;

class FighterPortrait extends FlxSpriteGroup
{
	public var hudScript:IrisHandler;
	
	public function new(x:Float, y:Float, fighter:Fighter) {
		super(x, y);

		var nameBack:FlxSprite = new FlxSprite(86, 63).loadGraphic(Paths.asset('nameHolder.png', 'gameplay/hud'));
		nameBack.color = CoolUtil.fitColorById(fighter.FIT_ID);
		var portraitBack:FlxSprite = new FlxSprite(16, 16).loadGraphic(Paths.asset('portraitHolder.png', 'gameplay/hud'));
		var portrait:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.asset('icon.png', fighter.fitSprite.fitFolder));
		
		add(nameBack);
		add(portraitBack);
		add(portrait);
	
		hudScript = new IrisHandler();
		
		var file:String = Paths.script('hud', fighter.fitSprite.fitFolder);

		if (CoolUtil.fileExists(file))
		{
			trace(fighter.FIT_NAME + " | HUD SCRIPT: " + file);
			hudScript.addByPath(file);
			hudScript.setup();
			hudScript.set('hud', this);
			hudScript.set('fit', fighter);
		}
		
		hudScript.call('createPost');
	}
	
	override public function update(elapsed:Float)
	{
		hudScript.call('update', [elapsed]);
			
		super.update(elapsed);
		
		hudScript.call('updatePost', [elapsed]);
		
	}
}
