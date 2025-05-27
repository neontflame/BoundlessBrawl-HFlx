package;

import flixel.FlxG;
import flixel.input.keyboard.FlxKey;
import flixel.input.FlxInput;

class InputCoolio
{
	static var keybinds:Map<String, String> = [
		"left" => "LEFT",
		"down" => "DOWN",
		"up" => "UP",
		"right" => "RIGHT",
		"jump" => "Z",
		"basic" => "X",
		"special" => "C",
		"dodge" => "A"
	];

	public static function key(key:String, ?mode:String = 'normal'):Bool
	{
		switch (mode) {
			case 'press':
				return FlxG.keys.checkStatus(FlxKey.fromString(keybinds[key]), FlxInputState.JUST_PRESSED);
			case 'release':
				return FlxG.keys.checkStatus(FlxKey.fromString(keybinds[key]), FlxInputState.JUST_RELEASED);
			default:
				return FlxG.keys.checkStatus(FlxKey.fromString(keybinds[key]), FlxInputState.PRESSED);
		}
		return false;
	}
	
	public static function keyBinary(key:String, ?mode:String = 'normal'):Int
	{
		switch (mode) {
			case 'press':
				return (FlxG.keys.checkStatus(FlxKey.fromString(keybinds[key]), FlxInputState.JUST_PRESSED) ? 1 : 0);
			case 'release':
				return (FlxG.keys.checkStatus(FlxKey.fromString(keybinds[key]), FlxInputState.JUST_RELEASED) ? 1 : 0);
			default:
				return (FlxG.keys.checkStatus(FlxKey.fromString(keybinds[key]), FlxInputState.PRESSED) ? 1 : 0);
		}
		return 0;
	}
}
