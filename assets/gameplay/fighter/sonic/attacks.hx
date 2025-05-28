function update() {
	if (InputCoolio.key('special', 'press')) {
		// angle, damage, knockback, _hurtFrames, _hitstun
		fit.damage(45, 12, 10, 100, 1);
		trace(fit.hitbox.velocity);
	}
	if (InputCoolio.key('right') && InputCoolio.key('basic', 'press')) {
	
		// SAMPLE RIGHT ATTACK
		fit.attack(function() {
			fit.fitSprite.animPlay('run');
			// offX, offY, size, angle, damage, knockback, _hurtFrames, _hitstun, type
			fit.createHitbox(30, -20 32, 25, 15, 10, 20, 0.05, "multiDamage");
			fit.hitbox.velocity.x = 100;
			
			new FlxTimer(fit.TIMER_MANAGER).start(0.25, function(tmr:FlxTimer) {
				fit.status = "default";
				fit.eraseHitbox();
			});
		
		});
	}
	
}