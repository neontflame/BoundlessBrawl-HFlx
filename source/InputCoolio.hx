package;

import flixel.FlxG;

class InputCoolio
{
	public static function key(key:String, ?justPressed:Bool = false):Bool
	{
		switch (key) {
			case 'left':
				return (justPressed ? FlxG.keys.justPressed.LEFT : FlxG.keys.pressed.LEFT);
			case 'down':
				return (justPressed ? FlxG.keys.justPressed.DOWN : FlxG.keys.pressed.DOWN);
			case 'up':
				return (justPressed ? FlxG.keys.justPressed.UP : FlxG.keys.pressed.UP);
			case 'right':
				return (justPressed ? FlxG.keys.justPressed.RIGHT : FlxG.keys.pressed.RIGHT);
			case 'jump':
				return (justPressed ? FlxG.keys.justPressed.Z : FlxG.keys.pressed.Z);
			case 'basic':
				return (justPressed ? FlxG.keys.justPressed.X : FlxG.keys.pressed.X);
			case 'special':
				return (justPressed ? FlxG.keys.justPressed.C : FlxG.keys.pressed.C);
			case 'dodge':
				return (justPressed ? FlxG.keys.justPressed.A : FlxG.keys.pressed.A);
			default:
				return false;
		}
	}
}
