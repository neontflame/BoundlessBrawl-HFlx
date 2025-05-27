function update() {

	if (InputCoolio.key('right') && InputCoolio.key('basic', 'press')) {
	
		// SAMPLE RIGHT ATTACK
		fit.attack(function() {
			fit.fitSprite.animPlay('run');
			fit.hitbox.velocity.x = 100;
			
			new FlxTimer().start(0.25, function(tmr:FlxTimer) {
				fit.status = "default";
			});
		
		});
	}
	
}