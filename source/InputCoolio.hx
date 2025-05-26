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
	
	public static function keyBinary(key:String, ?justPressed:Bool = false):Int
	{
		switch (key) {
			case 'left':
				return (justPressed ? (FlxG.keys.justPressed.LEFT ? 1 : 0) : (FlxG.keys.pressed.LEFT ? 1 : 0));
			case 'down':
				return (justPressed ? (FlxG.keys.justPressed.DOWN ? 1 : 0) : (FlxG.keys.pressed.DOWN ? 1 : 0));
			case 'up':
				return (justPressed ? (FlxG.keys.justPressed.UP ? 1 : 0) : (FlxG.keys.pressed.UP ? 1 : 0));
			case 'right':
				return (justPressed ? (FlxG.keys.justPressed.RIGHT ? 1 : 0) : (FlxG.keys.pressed.RIGHT ? 1 : 0));
			case 'jump':
				return (justPressed ? (FlxG.keys.justPressed.Z ? 1 : 0) : (FlxG.keys.pressed.Z ? 1 : 0));
			case 'basic':
				return (justPressed ? (FlxG.keys.justPressed.X ? 1 : 0) : (FlxG.keys.pressed.X ? 1 : 0));
			case 'special':
				return (justPressed ? (FlxG.keys.justPressed.C ? 1 : 0) : (FlxG.keys.pressed.C ? 1 : 0));
			case 'dodge':
				return (justPressed ? (FlxG.keys.justPressed.A ? 1 : 0) : (FlxG.keys.pressed.A ? 1 : 0));
			default:
				return 0;
		}
	}
}
