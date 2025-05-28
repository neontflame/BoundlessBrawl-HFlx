package objects;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxDirectionFlags;
import flixel.util.FlxTimer;
import flixel.util.FlxTimer.FlxTimerManager;
import flixel.math.FlxMath;
import flixel.math.FlxAngle;

import backend.IrisHandler;

import objects.FighterSprite;
import objects.Hitbox;

class Fighter extends FlxSpriteGroup
{
	public var fitScript:IrisHandler;
	
	public var fitSprite:FighterSprite;
	public var hitbox:Hitbox;

	public var TIMER_MANAGER:FlxTimerManager;
	
	// MAIN STATS
	public var WALK_SPEED:Float = 500;
	public var RUN_SPEED:Float = 700;
	public var HORIZONTAL_ACCEL:Float = 500;
	public var JUMP_STRENGTH:Float = 600;
	public var WEIGHT:Float = 2000;
	
	public var FLOOR_FRICTION:Float = 6;
	public var AIRDODGE_COEFFICIENT:Float = 4.5;
	public var AIR_MOVEMENT_COEFFICIENT:Float = 5;
	
	public var RUNNING:Bool = false;
	
	public function new(x:Float, y:Float, ?fitName:String = 'sonic') {
		super(x, y);
		
		// SETUP
		trace('NEW FIGHTER: ' + fitName);
		TIMER_MANAGER = new FlxTimerManager();
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
		hitbox.gravValue = WEIGHT;

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
	// [-] basic movement
	//		[v] running
	//		[v] airdodging
	//		[ ] damage
	// [v] attacks (its literally just a callback this Shit is Not to be made up .)
	
	public var controlOnAttack:Bool = false;
	public var status:String = "default";
	public var curAnim:String = "default";
	
	public var dmgPercent:Float = 0;
	var runTimer:Float = 0;
	
	public var jumped:Bool = false;
	public var airdodged:Bool = true;
	
	public var horizontalDI:Float = 0;
	public var verticalDI:Float = 0;
	
	public var hitstun:Float = 0;
	public var hurtTimer:Float = 0;
	
	var airdodgeTimer:FlxTimer;
	
	override public function update(elapsed:Float)
	{
		fitScript.call('update', [elapsed]);
		
		TIMER_MANAGER.update(elapsed);
		
		hitStunner();
		DImanager();
		if (hitstun <= 0)
			playerMovement();
			
		super.update(elapsed);
		
		fitScript.call('updatePost', [elapsed]);
		
	}
	
	function DImanager() {
		if (status != "airdodge") {
			horizontalDI = InputCoolio.keyBinary('right') - InputCoolio.keyBinary('left');
			verticalDI = InputCoolio.keyBinary('down') - InputCoolio.keyBinary('up');
		}
		
	}
	
	function hitStunner() {
		if (hitstun > 0) {
			hitbox.velocity.x = 0;
			hitbox.velocity.y = 0;
			hitbox.acceleration.y = 0;
			hitbox.acceleration.x = 0;
			
			hitstun -= 1;
		}
	}
	
	var airvel:Float = 0;
	var horvel:Float = 0;
	
	function playerMovement() {
		// running timer
		if (runTimer > 0) {
			runTimer -= 1;
		} else {
			RUNNING = false;
		}
		
		// start player movement
		switch (status) {
			case "dmg" | "dmgcontrollable": 
				// dmg/dmgcont
				// they share much of the same code, it's just now we gotta figure out what DMG and DMGControllable do specifically
				
				if (!hitbox.isTouching(FlxDirectionFlags.FLOOR)) {
					airvel = hitbox.velocity.y;
				}
				if (!hitbox.isTouching(FlxDirectionFlags.WALL)) {
					horvel = hitbox.velocity.x;
				}
				if (hitbox.isTouching(FlxDirectionFlags.CEILING)) {
					hitbox.velocity.y = Math.abs(airvel) * 0.95; // this one is the only one that gets stronger cuz i thought itd be funny
				} 
				
				if (hitbox.isTouching(FlxDirectionFlags.LEFT)) {
					hitbox.velocity.x = Math.abs(horvel) * 0.75;
				} 
				if (hitbox.isTouching(FlxDirectionFlags.RIGHT)) {
					hitbox.velocity.x = -Math.abs(horvel) * 0.95;
				} 
				
				if (status == 'dmg') {
					hitbox.maxVelocity.x = 0;
					hitbox.drag.x = 0;
					
					// funny bounce !
					if (hitbox.isTouching(FlxDirectionFlags.FLOOR)) {
						trace('bounce! ' + -Math.abs(airvel) * 0.95);
						hitbox.velocity.y = -Math.abs(airvel) * 0.95;
					} 
					
					// cant move on damage silly boy !
					if (hurtTimer > 0)
						hurtTimer -= 1;
						
					if (hurtTimer <= 0)
						status = 'dmgcontrollable';
				}
				
				if (status == 'dmgcontrollable') {
					hitbox.maxVelocity.x = WALK_SPEED;
					HORIZONTAL_ACCEL = WALK_SPEED * (AIR_MOVEMENT_COEFFICIENT * 0.85);
					hitbox.drag.x = WALK_SPEED;
					hitbox.drag.y = 0;
					
					// no bounce
					if (hitbox.isTouching(FlxDirectionFlags.FLOOR)) {
						status = 'default';
					} 
					
					// can move !
					if (InputCoolio.key('right')) {
						hitbox.acceleration.x = HORIZONTAL_ACCEL;
					} else if (InputCoolio.key('left')) {
						hitbox.acceleration.x = -HORIZONTAL_ACCEL;
					} else {
						hitbox.acceleration.x = 0;
					}
				}
				
			case "airdodge":
				// airdodge
				airdodged = true;
				hitbox.acceleration.y = 0;
				hitbox.acceleration.x = 0;
				hitbox.drag.x = WALK_SPEED * AIRDODGE_COEFFICIENT;
				hitbox.drag.y = WALK_SPEED * AIRDODGE_COEFFICIENT;
				
				if (hitbox.isTouching(FlxDirectionFlags.FLOOR)) {
					status = "default";
					airdodgeTimer.destroy();
				}
				

			case "attack":
				// attacks
				// i Just remembered aerial attacks are a thing fuack
				if (controlOnAttack) {
					hitbox.maxVelocity.x = WALK_SPEED;
					HORIZONTAL_ACCEL = WALK_SPEED * AIR_MOVEMENT_COEFFICIENT;
					// hitbox.drag.x = WALK_SPEED * FLOOR_FRICTION;
					hitbox.drag.y = 0;
					
					if (InputCoolio.key('right')) {
						hitbox.acceleration.x = HORIZONTAL_ACCEL;
					} else if (InputCoolio.key('left')) {
						hitbox.acceleration.x = -HORIZONTAL_ACCEL;
					} else {
						hitbox.acceleration.x = 0;
					}
				}
			default:
				// default player state!
				if (RUNNING) {
					hitbox.maxVelocity.x = RUN_SPEED;
					HORIZONTAL_ACCEL = RUN_SPEED * 8;
				} else {
					hitbox.maxVelocity.x = WALK_SPEED;
					HORIZONTAL_ACCEL = WALK_SPEED * 8;
				}
				hitbox.drag.x = WALK_SPEED * FLOOR_FRICTION;
				hitbox.drag.y = 0;
				
				if (InputCoolio.key('right')) {
					if (RUNNING) 
						runTimer = 7;
					hitbox.acceleration.x = HORIZONTAL_ACCEL;
				} else if (InputCoolio.key('left')) {
					if (RUNNING) 
						runTimer = 7;
					hitbox.acceleration.x = -HORIZONTAL_ACCEL;
				} else {
					hitbox.acceleration.x = 0;
				}
				
				if (hitbox.isTouching(FlxDirectionFlags.FLOOR)) {
					airdodged = false;
					if (InputCoolio.key('right')) {
						fitSprite.flipX = false;
					} else if (InputCoolio.key('left')) {
						fitSprite.flipX = true;
					}
					
					// fall off platforms
					if (InputCoolio.key('down', 'press')) {
						fitScript.call('onFalloffPlat');
						hitbox.jumpthruFalloffTimer = 15;
					}
					
					// jump
					if (InputCoolio.key('jump', 'press')) {
						fitScript.call('onJump');
						hitbox.velocity.y = -JUMP_STRENGTH;
						jumped = true;
					}
					
					// run
					if (InputCoolio.key('right', 'press') || InputCoolio.key('left', 'press')) {
						if (runTimer > 0) {
							if (!RUNNING) {
								RUNNING = true;
								if (InputCoolio.key('right'))
									hitbox.velocity.x = RUN_SPEED;
								if (InputCoolio.key('left'))
									hitbox.velocity.x = -RUN_SPEED;
							}
						} else {
							runTimer = 15;
						}
					}
				}
				
				// AIRDODGE COOLIO
				if (InputCoolio.key('dodge', 'press')) {
					if (!airdodged) {
						fitScript.call('onAirdodge', [horizontalDI, verticalDI]);
						
						status = "airdodge";
						
						hitbox.maxVelocity.x = WALK_SPEED * 1.5;
						
						hitbox.velocity.x = WALK_SPEED * horizontalDI * 1.5;
						hitbox.velocity.y = WALK_SPEED * verticalDI * 1.5;
						hitbox.jumpthruFalloffTimer = 5;
						
						airdodgeTimer = new FlxTimer(TIMER_MANAGER).start(0.5, function(tmr:FlxTimer) {
							status = "default";
						});
					}
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
				case "dmg" | "dmgcontrollable":
					// dmg
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
	
	function damage(angle, damage, knockback, _hurtFrames, _hitstun){
		TIMER_MANAGER.clear();
		
		var the_thing:Float = FlxMath.lerp(dmgPercent, 100, 0.3);

		status = "dmg";
		
		dmgPercent += damage;
		
		hitstun = 10000;
		
		new FlxTimer(TIMER_MANAGER).start(_hitstun, function(tmr:FlxTimer) {
			hitstun = 0;
			hitbox.velocity.x = (the_thing * knockback) * (Math.sin(angle * FlxAngle.TO_RAD) + horizontalDI);
			hitbox.velocity.y = (the_thing * knockback) * ((Math.cos(angle * FlxAngle.TO_RAD) * -1) + verticalDI);
		});
		
		hurtTimer = _hurtFrames;
		
		fitScript.call('onDamage', [angle, damage, knockback, _hurtFrames, _hitstun]);
	}
	
}
