package objects.fighter;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxDirectionFlags;
import flixel.util.FlxTimer;
import flixel.util.FlxTimer.FlxTimerManager;
import flixel.math.FlxMath;
import flixel.math.FlxAngle;

import backend.IrisHandler;

import objects.fighter.FighterSprite;
import objects.Hitbox;
import objects.DamageBox;

class Fighter extends FlxSpriteGroup
{
	public var FIT_NAME:String = "";
	public var fitScript:IrisHandler;
	
	public var fitSprite:FighterSprite;
	public var hitbox:Hitbox;

	public var TIMER_MANAGER:FlxTimerManager;
	
	public var dmgboxes:FlxTypedSpriteGroup<DamageBox>;
	
	public var FIT_ID:Int = 1;
	
	// MAIN STATS
	public var WALK_SPEED:Float = 500;
	public var RUN_SPEED:Float = 700;
	public var HORIZONTAL_ACCEL:Float = 500;
	public var JUMP_STRENGTH:Float = 600;
	public var WEIGHT:Float = 2000;
	public var MIDAIR_JUMPS:Int = 2;
	
	public var FLOOR_FRICTION:Float = 6;
	public var AIRDODGE_COEFFICIENT:Float = 4.5;
	public var AIR_MOVEMENT_COEFFICIENT:Float = 5;
	
	public var RUNNING:Bool = false;
	
	public var ATTACK_PRIORITY:Int = -1;
	
	public function new(x:Float, y:Float, ?fitName:String = 'sonic', fitId:Int = 1) {
		super(x, y);
		
		FIT_ID = fitId;
		FIT_NAME = fitName;
		// SETUP
		trace('NEW FIGHTER: ' + fitName);
		TIMER_MANAGER = new FlxTimerManager();
		dmgboxes = new FlxTypedSpriteGroup<DamageBox>();
		add(dmgboxes);
		
		// SPRITE
		fitSprite = new FighterSprite(x, y, fitName);
		add(fitSprite);
		
		// SCRIPT
		fitScript = new IrisHandler();
		
		fitScript.addByPath(Paths.script('global', 'gameplay/fighter'));
		fitScript.setup();
		fitScript.set('fit', this);
				
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
		fitSprite.sprTracker = hitbox;

		loadAnims(fitName); // anims!
		
		fitScript.call('createPost');
	}
	
	public function loadAnims(fit:String)
	{
		fitScript.call('loadAnims');
	}

	public function posUpdate() {
		// position shittery!
		fitSprite.generalOffset[0] = FlxG.random.float(-hitstun / 10, hitstun / 10);
	}
	
	// CHAR CONTROLLER WHAAAAAAAAAAAATTTT
	// [v] basic movement
	//		[v] running
	//		[v] airdodging
	//		[v] damage
	// [v] attacks (its literally just a callback this Shit is Not to be made up .)
	
	public var controlOnAttack:Bool = false;
	public var status:String = "default";
	public var curAnim:String = "default";
	
	public var dmgPercent:Float = 0;
	var runTimer:Float = 0;
	
	public var jumped:Bool = false;
	public var midairJumpsDone:Int = 0;
	public var airdodged:Bool = false;
	
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
			horizontalDI = InputCoolio.keyBinary(FIT_ID, 'right') - InputCoolio.keyBinary(FIT_ID, 'left');
			verticalDI = InputCoolio.keyBinary(FIT_ID, 'down') - InputCoolio.keyBinary(FIT_ID, 'up');
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
					} else {
						// midair jump
						if (InputCoolio.key(FIT_ID, 'jump', 'press') && midairJumpsDone < MIDAIR_JUMPS) {
							fitScript.call('onJump', ['midair']);
							status = 'default';
							hitbox.velocity.y = -JUMP_STRENGTH;
							jumped = true;
							midairJumpsDone += 1;
						}
					}
					
					// can move !
					if (InputCoolio.key(FIT_ID, 'right')) {
						hitbox.acceleration.x = HORIZONTAL_ACCEL;
					} else if (InputCoolio.key(FIT_ID, 'left')) {
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
					
					if (InputCoolio.key(FIT_ID, 'right')) {
						hitbox.acceleration.x = HORIZONTAL_ACCEL;
					} else if (InputCoolio.key(FIT_ID, 'left')) {
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
				
				if (InputCoolio.key(FIT_ID, 'right')) {
					if (RUNNING) 
						runTimer = 7;
					hitbox.acceleration.x = HORIZONTAL_ACCEL;
				} else if (InputCoolio.key(FIT_ID, 'left')) {
					if (RUNNING) 
						runTimer = 7;
					hitbox.acceleration.x = -HORIZONTAL_ACCEL;
				} else {
					hitbox.acceleration.x = 0;
				}
				
				if (hitbox.isTouching(FlxDirectionFlags.FLOOR)) {
					// if is on ground
					airdodged = false;
					if (InputCoolio.key(FIT_ID, 'right')) {
						fitSprite.flipX = false;
					} else if (InputCoolio.key(FIT_ID, 'left')) {
						fitSprite.flipX = true;
					}
					
					// fall off platforms
					if (InputCoolio.key(FIT_ID, 'down', 'press')) {
						fitScript.call('onFalloffPlat');
						hitbox.jumpthruFalloffTimer = 15;
					}
					
					// jump
					midairJumpsDone = 0;
					if (InputCoolio.key(FIT_ID, 'jump', 'press')) {
						fitScript.call('onJump', ['ground']);
						hitbox.velocity.y = -JUMP_STRENGTH;
						jumped = true;
					}
					
					// run
					if (InputCoolio.key(FIT_ID, 'right', 'press') || InputCoolio.key(FIT_ID, 'left', 'press')) {
						if (runTimer > 0) {
							if (!RUNNING) {
								RUNNING = true;
								if (InputCoolio.key(FIT_ID, 'right'))
									hitbox.velocity.x = RUN_SPEED;
								if (InputCoolio.key(FIT_ID, 'left'))
									hitbox.velocity.x = -RUN_SPEED;
							}
						} else {
							runTimer = 15;
						}
					}
				} else {
					// if is on air
					// midair jump
					if (InputCoolio.key(FIT_ID, 'jump', 'press') && midairJumpsDone < MIDAIR_JUMPS) {
						fitScript.call('onJump', ['midair']);
						hitbox.velocity.y = -JUMP_STRENGTH;
						jumped = true;
						midairJumpsDone += 1;
					}
					
				}
				
				// AIRDODGE COOLIO
				if (InputCoolio.key(FIT_ID, 'dodge', 'press')) {
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
	
	/*
	for SOME godforsaken reason this needs to be on hscript. so it goes on hscript
	oh my fjcuuuuckkikingngg god I'm gonna fucking pee man
	
	function createDmgbox(offX:Float, offY:Float, size:Int, angle:Float, damage:Float, knockback:Float, _hurtFrames:Int, _hitstun:Float, type:String = "default"){
		var dmgbox:DamageBox = new DamageBox(offX, offY, size);
		dmgbox.changeInfo(angle, damage, knockback, _hurtFrames, _hitstun, type);
		dmgbox.sprTracker = this;
		dmgboxes.add(dmgbox);
	}
	*/
	public function eraseDmgboxes() {
		for (box in dmgboxes.members) {
			if (box != null) {
				box.destroy();
			}
		}
		dmgboxes.clear();
	}
	
	public function damage(angle:Float, damage:Float, knockback:Float, _hurtFrames:Int, _hitstun:Float){
		TIMER_MANAGER.clear();
		eraseDmgboxes();
		var the_thing:Float = FlxMath.lerp(dmgPercent, 100, 0.3);

		status = "dmg";
		
		dmgPercent += damage;
		
		hitstun = _hitstun * 100;
		
		new FlxTimer(TIMER_MANAGER).start(_hitstun, function(tmr:FlxTimer) {
			hitstun = 0;
			hitbox.velocity.x = (the_thing * knockback) * (Math.sin(angle * FlxAngle.TO_RAD) + horizontalDI);
			hitbox.velocity.y = (the_thing * knockback) * ((Math.cos(angle * FlxAngle.TO_RAD) * -1) + verticalDI);
		});
		
		hurtTimer = _hurtFrames;
		
		fitScript.call('onDamage', [angle, damage, knockback, _hurtFrames, _hitstun]);
	}

}
