package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.util.FlxDirectionFlags;
import objects.*;

class BattleState extends FlxState
{
	public var fighterlist:Array<Fighter> = [];
	var player0:Fighter;
	var player1:Fighter;
	
	public var floor:FlxSprite;
	public var jumpthru:FlxSprite;
	
	public static var instance:BattleState;
	
	override public function create()
	{
		super.create();
		
		floor = new FlxSprite(0, 400).makeGraphic(500, 25, 0xFFFFFFFF);
		floor.immovable = true;
		
		jumpthru = new FlxSprite(250, 250).makeGraphic(120, 25, 0xFF00FFFF);
		jumpthru.allowCollisions = FlxDirectionFlags.CEILING;
		jumpthru.immovable = true;
		
		add(floor);
		add(jumpthru);
		
		player0 = new Fighter(100, 100, 'sonic', 0);
		add(player0);
		
		fighterlist.push(player0);
		
		
		player1 = new Fighter(200, 100, 'sonic', 1);
		add(player1);
		
		fighterlist.push(player1);
		
		instance = this;
	}

	override public function update(elapsed:Float)
	{
		if (FlxG.keys.justPressed.R)
			FlxG.resetState();
			
		for (fit in fighterlist) {
			fit.posUpdate();
			fit.hitbox.physUpdate(floor, jumpthru);
		}
		
		super.update(elapsed);
	}
}
