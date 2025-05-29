package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxCamera;

import flixel.util.FlxDirectionFlags;
import flixel.util.FlxColor;

import objects.*;
import objects.fighter.*;
import ui.*;

class BattleState extends FlxState
{
	public var camHUD:FlxCamera;
	public var camGame:FlxCamera;
	
	public var fighterlist:Array<Fighter> = [];
	var player0:Fighter;
	var player1:Fighter;
	
	public var hudlist:Array<BattleHUDPortrait> = [];
	
	public var floor:FlxSprite;
	public var jumpthru:FlxSprite;
	
	public static var instance:BattleState;
	
	override public function create()
	{
		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camHUD.bgColor = FlxColor.TRANSPARENT;
		
		super.create();
		
		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD, false);
		
		floor = new FlxSprite(0, 400).makeGraphic(500, 25, 0xFFFFFFFF);
		floor.immovable = true;
		
		jumpthru = new FlxSprite(250, 250).makeGraphic(120, 25, 0xFF00FFFF);
		jumpthru.allowCollisions = FlxDirectionFlags.CEILING;
		jumpthru.immovable = true;
		
		add(floor);
		add(jumpthru);
		
		// players
		player0 = new Fighter(100, 100, 'sonic', 0);
		add(player0);
		player1 = new Fighter(200, 100, 'sonic', 1);
		add(player1);
		
		fighterlist.push(player0);
		fighterlist.push(player1);
		
		// player huds
		for (fit in fighterlist) {
			var pHUD:BattleHUDPortrait = new BattleHUDPortrait(fit.FIT_ID * 210, 375, fit);
			pHUD.cameras = [camHUD];
			add(pHUD);
			hudlist.push(pHUD);
			
			fit.fitScript.set('hud', pHUD);
		}
		
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
