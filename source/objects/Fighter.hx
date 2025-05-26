package objects;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxDirectionFlags;
import flixel.util.FlxTimer;

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
		trace('NEW FIGHTER: ' + fitName);
		// SPRITE
		fitSprite = new FighterSprite(x, y, fitName);
		add(fitSprite);
		
		// SCRIPT
		fitScript = new IrisHandler();
		
		var filenames:Array<String> = ['fighter', 'init', 'attacks', 'misc'];
		
		for (filery in filenames) { 
			var file:String = Paths.script(filery, fitSprite.fitFolder);

			if (CoolUtil.fileExists(file))
			{
				trace(fitName + " | " + filery.toUpperCase() + " SCRIPT: " + file);
				fitScript.addByPath(file);
				fitScript.setup();
				fitScript.set('fit', this);
			}
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
		// position shittery!
		fitSprite.x = ((hitbox.x + hitbox.origin.x) - fitSprite.width/2) + fitSprite.hitboxOffset[0] + fitSprite.hitboxAnimOffset[0];
		fitSprite.y = ((hitbox.y + hitbox.origin.y) - fitSprite.height) + fitSprite.hitboxOffset[1] + fitSprite.hitboxAnimOffset[1];
	}
	
	// CHAR CONTROLLER WHAAAAAAAAAAAATTTT
	// [ ] basic movement
	//		[ ] running
	//		[ ] airdodging
	//		[ ] damage
	// [ ] attacks
	
	public var controllable:Bool = true;
	public var status:String = "default";
	public var curAnim:String = "default";
	
	public var dmgPercent:Float = 0;
	
	public var WALK_SPEED:Float = 500;
	public var RUN_SPEED:Float = 0;
	public var HORIZONTAL_ACCEL:Float = 500;
	
	public var JUMP_HEIGHT:Float = 500;
	
	public var jumped:Bool = false;
	
	public var horizontalDI:Float = 0;
	public var verticalDI:Float = 0;
	
	var airdodgeTimer:FlxTimer;
	
	override public function update(elapsed:Float)
	{
		fitScript.call('update', [elapsed]);
		
		playerMovement();
		super.update(elapsed);
		
		fitScript.call('updatePost', [elapsed]);
		
	}
	
	function playerMovement() {
		if (status != "airdodge") {
			horizontalDI = InputCoolio.keyBinary('right') - InputCoolio.keyBinary('left');
			verticalDI = InputCoolio.keyBinary('down') - InputCoolio.keyBinary('up');
		}
		
		// start player movement
		switch (status) {
			case "dmg":
				// dmg
			case "dmgcontrollable":
				// dmgcontrollable
			case "airdodge":
				// airdodge
				hitbox.acceleration.y = 0;
				hitbox.acceleration.x = 0;
				hitbox.drag.x = WALK_SPEED * 4;
				hitbox.drag.y = WALK_SPEED * 4;
				
				if (hitbox.isTouching(FlxDirectionFlags.FLOOR)) {
					status = "default";
					airdodgeTimer.destroy();
				}
				

			case "attack":
				// attacks
			default:
				// default player state!
				hitbox.maxVelocity.x = WALK_SPEED;
				HORIZONTAL_ACCEL = WALK_SPEED * 8;
				hitbox.drag.x = WALK_SPEED * 6;
				hitbox.drag.y = 0;
				
				if (InputCoolio.key('right')) {
					hitbox.acceleration.x = HORIZONTAL_ACCEL;
				} else if (InputCoolio.key('left')) {
					hitbox.acceleration.x = -HORIZONTAL_ACCEL;
				} else {
					hitbox.acceleration.x = 0;
				}
				
				if (hitbox.isTouching(FlxDirectionFlags.FLOOR)) {
					if (InputCoolio.key('right')) {
						fitSprite.flipX = false;
					} else if (InputCoolio.key('left')) {
						fitSprite.flipX = true;
					}
					
					if (InputCoolio.key('jump', true)) {
						hitbox.velocity.y = -JUMP_HEIGHT;
						jumped = true;
					}
				}
				
				// AIRDODGE COOLIO
				if (InputCoolio.key('dodge', true)) {
					hitbox.velocity.x = WALK_SPEED * horizontalDI;
					hitbox.velocity.y = WALK_SPEED * verticalDI;
				
					airdodgeTimer = new FlxTimer().start(0.5, function(tmr:FlxTimer) {
						status = "default";
					});
					
					status = "airdodge";
				}
				
		}
		
		// end player movement
		playerDefaultAnim(status);
	}
	
	public var exoticDefaultAnims:Bool = false;
	
	function playerDefaultAnim(status:String) {
		fitScript.call('playerDefaultAnim');
		
		if (!exoticDefaultAnims) {
			// start switch
			switch (status) {
				case "dmg":
					// dmg
				case "dmgcontrollable":
					// dmgcontrollable
				case "airdodge":
					// airdodge
					fitSprite.animPlay('airdodge');
				case "attack":
					// there is nothing.
					// attack info goes on the character's very own fighter.hx
				default:
					// floor anims
					if (hitbox.isTouching(FlxDirectionFlags.FLOOR)) {
						// walk anim
						if (Math.abs(hitbox.velocity.x) > 10) {
							if (Math.abs(hitbox.velocity.x) > WALK_SPEED)
								fitSprite.animPlay('run');
							else
								fitSprite.animPlay('walk');
						} else {
							fitSprite.animPlay('idle');
						}
					// air anims
					} else {
						// jump
						if (jumped) {
							if (hitbox.velocity.y < 0)
								fitSprite.animPlay('jump');
						}
						
						// fall
						if (hitbox.velocity.y > 0)
							fitSprite.animPlay('fall');
					}
			}
			// end switch
			
		}
	}
	
	function attack(?callback:Dynamic) {
		status = "attack";
		if (callback != null) {
			callback();
		} else {
			trace("You can't attack someone without a function to do so!!");
		}
	}
	
}
