package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.util.FlxDirectionFlags;
import objects.*;

class BattleState extends FlxState
{
	var player1:Fighter;
	var floor:FlxSprite;
	var jumpthru:FlxSprite;
	
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
		
		player1 = new Fighter(100, 100, 'sonic');
		add(player1);
	}

	override public function update(elapsed:Float)
	{
		player1.posUpdate();
		player1.hitbox.physUpdate(floor, jumpthru);
		
		super.update(elapsed);
	}
}
