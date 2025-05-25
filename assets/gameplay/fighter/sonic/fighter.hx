function createPost() {
	fit.hitbox.changeSize(59, 105);
	fit.fitSprite.hitboxOffset = [0, 14];
	trace(fit.hitbox);
}

function loadAnims() {
	fit.fitSprite.animAdd('idle', 'sonic idle', [0, 0]);
	fit.fitSprite.animAdd('walk', 'sonic walk', [0, 0]);
	fit.fitSprite.animAdd('run', 'sonic run', [0, 0], 24, true);
	
	fit.fitSprite.animAdd('jump', 'sonic spin', [0, 0], 30);
	fit.fitSprite.animAdd('fall', 'sonic fall', [0, 0]);
	
	fit.fitSprite.animPlay('idle');
}