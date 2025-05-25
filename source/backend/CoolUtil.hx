package backend;

import lime.utils.Assets;
import openfl.utils.Assets as OpenFLAssets;
import openfl.system.System;
import flixel.sound.FlxSound;
import flixel.system.FlxAssets.FlxSoundAsset;

using StringTools;

#if sys
import sys.FileSystem;
#end

class CoolUtil {
	public static function coolTextFile(path:String):Array<String> {
		var daList:Array<String> = Assets.getText(path).trim().split('\n');

		for (i in 0...daList.length) {
			daList[i] = daList[i].trim();
		}

		return daList;
	}

	public static function numberArray(max:Int, ?min = 0):Array<Int> {
		var dumbArray:Array<Int> = [];
		for (i in min...max) {
			dumbArray.push(i);
		}
		return dumbArray;
	}
	
	public static function fileExists(path):Bool {
		#if sys
		return sys.FileSystem.exists(path);
		#else
		return OpenFLAssets.exists(path);
		#end
	}
	
	/**
	 * Clears all images and sounds from the cache.
	 * @author swordcube
	 */
	public inline static function clearCache(assets:Bool = true, bitmaps:Bool = true, sounds:Bool = false) {
		
		if (assets) {
			// Clear OpenFL & Lime Assets
			OpenFLAssets.cache.clear();
			Assets.cache.clear();
			trace('asset cache cleared');
		} 
		
		if (bitmaps) {
			// Clear all Flixel bitmaps
			FlxG.bitmap.dumpCache();
			FlxG.bitmap.clearCache();
			trace('bitmap cache cleared');
		}
		
		if (sounds) {
			// Clear all Flixel sounds
			FlxG.sound.list.forEach((sound:FlxSound) -> {
				sound.stop();
				sound.kill();
				sound.destroy();
				trace('fuck you sound');
			});
			FlxG.sound.list.clear();
			FlxG.sound.destroy(false);
		trace('sound cache cleared');
		}
		
		// Run garbage collector just in case none of that worked
		System.gc();
		trace('garb collect');
	}

}
