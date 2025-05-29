package ui;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;

import flixel.text.FlxText;
import flixel.util.FlxColor;

import backend.IrisHandler;

import objects.fighter.Fighter;

class BattleHUDPortrait extends FlxSpriteGroup
{
	public var hudScript:IrisHandler;
	
	public function new(x:Float, y:Float, fighter:Fighter) {
		super(x, y);

		var nameBack:FlxSprite = new FlxSprite(86, 63).loadGraphic(Paths.asset('nameHolder.png', 'gameplay/hud'));
		nameBack.color = CoolUtil.fitColorById(fighter.FIT_ID);
		var portraitBack:FlxSprite = new FlxSprite(16, 16).loadGraphic(Paths.asset('portraitHolder.png', 'gameplay/hud'));
		var portrait:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.asset('icon.png', fighter.fitSprite.fitFolder));
		
		var name:FlxText = new FlxText(nameBack.x + 4, nameBack.y + 2, nameBack.width, CoolUtil.fitNameById(fighter.FIT_NAME), 18, false);
		name.setFormat(Paths.asset('5by7.ttf', 'fonts'), 18, FlxColor.WHITE, LEFT, OUTLINE, 0x50FFFFFF, false);
		name.borderSize = 1;
		
		add(nameBack);
		add(name);
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
