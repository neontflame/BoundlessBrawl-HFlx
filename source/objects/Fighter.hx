package objects;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;

import backend.IrisHandler;

import objects.FighterSprite;
import objects.Hitbox;

class Fighter extends FlxSpriteGroup
{
	public var fitScript:IrisHandler;
	
	public var fitSprite:FighterSprite;
	public var hitbox:Hitbox;
	
	public function new(x:Float, y:Float, ?fitName:String = 'sonic') {
		super(x, y);
		
		// SETUP
		// SPRITE
		fitSprite = new FighterSprite(x, y, fitName);
		add(fitSprite);
		
		// SCRIPT
		fitScript = new IrisHandler();

		var file:String = Paths.script('fighter', fitSprite.fitFolder);
		trace(file);

		if (CoolUtil.fileExists(file))
		{
			trace(fitName + " FIGHTER SCRIPT: " + file);
			fitScript.addByPath(file);
			fitScript.setup();
			fitScript.set('fit', this);
		}
		
		// HITBOX
		hitbox = new Hitbox(x, y, 32, 32);
		add(hitbox);

		loadAnims(fitName); // anims!
		
		fitScript.call('createPost');
	}
	
	public function loadAnims(fit:String)
	{
		fitScript.call('loadAnims');
	}

	public function posUpdate() {
		fitSprite.x = ((hitbox.x + hitbox.origin.x) - fitSprite.width/2) + fitSprite.hitboxOffset[0] + fitSprite.hitboxAnimOffset[0];
		fitSprite.y = ((hitbox.y + hitbox.origin.y) - fitSprite.height) + fitSprite.hitboxOffset[1] + fitSprite.hitboxAnimOffset[1];
	}
	
	override public function update(elapsed:Float)
	{
		fitScript.call('update', [elapsed]);
		
		super.update(elapsed);
		
		fitScript.call('updatePost', [elapsed]);
		
	}
}
