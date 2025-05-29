package;

import flixel.FlxG;
import flixel.input.keyboard.FlxKey;
import flixel.input.FlxInput;

class InputCoolio
{
	static var keybinds:Array<Map<String, String>>= [
	[
		"left" => "LEFT",
		"down" => "DOWN",
		"up" => "UP",
		"right" => "RIGHT",
		"jump" => "Z",
		"basic" => "X",
		"special" => "C",
		"dodge" => "A"
	],
	[
		"left" => "NONE",
		"down" => "NONE",
		"up" => "NONE",
		"right" => "NONE",
		"jump" => "NONE",
		"basic" => "NONE",
		"special" => "NONE",
		"dodge" => "NONE"
	],
	[
		"left" => "NONE",
		"down" => "NONE",
		"up" => "NONE",
		"right" => "NONE",
		"jump" => "NONE",
		"basic" => "NONE",
		"special" => "NONE",
		"dodge" => "NONE"
	],
	[
		"left" => "NONE",
		"down" => "NONE",
		"up" => "NONE",
		"right" => "NONE",
		"jump" => "NONE",
		"basic" => "NONE",
		"special" => "NONE",
		"dodge" => "NONE"
	]
	];

	public static function key(binds:Int, key:String, ?mode:String = 'normal'):Bool
	{
		if (keybinds[binds][key] == "NONE" || keybinds[binds][key] == "") return false;
		switch (mode) {
			case 'press':
				return FlxG.keys.checkStatus(FlxKey.fromString(keybinds[binds][key]), FlxInputState.JUST_PRESSED);
			case 'release':
				return FlxG.keys.checkStatus(FlxKey.fromString(keybinds[binds][key]), FlxInputState.JUST_RELEASED);
			default:
				return FlxG.keys.checkStatus(FlxKey.fromString(keybinds[binds][key]), FlxInputState.PRESSED);
		}
		return false;
	}
	
	public static function keyBinary(binds:Int, key:String, ?mode:String = 'normal'):Int
	{
		if (keybinds[binds][key] == "NONE" || keybinds[binds][key] == "") return 0;
		switch (mode) {
			case 'press':
				return (FlxG.keys.checkStatus(FlxKey.fromString(keybinds[binds][key]), FlxInputState.JUST_PRESSED) ? 1 : 0);
			case 'release':
				return (FlxG.keys.checkStatus(FlxKey.fromString(keybinds[binds][key]), FlxInputState.JUST_RELEASED) ? 1 : 0);
			default:
				return (FlxG.keys.checkStatus(FlxKey.fromString(keybinds[binds][key]), FlxInputState.PRESSED) ? 1 : 0);
		}
		return 0;
	}
}
