package backend;

import flixel.FlxG;
import flixel.graphics.frames.FlxAtlasFrames;
import openfl.utils.AssetType;
import openfl.utils.Assets as OpenFlAssets;

class Paths {
	// inline public static var SOUND_EXT = 'ogg';

	inline static function getPath(file:String) {
		return 'assets/$file';
	}

	inline static public function asset(key:String, ?rootDir:String = '') {
		return getPath('$rootDir/$key');
	}
	
	inline static public function script(key:String, ?rootDir:String = '') {
		var filetypes:Array<String> = ['hx', 'hxs', 'hxc', 'hscript'];
		var existingType:String = 'hx';
		
		for (file in filetypes) {
			if (CoolUtil.fileExists('assets/scripts/$key.$file')) {
				existingType = file;
			}
		}
		
		return getPath('$rootDir/$key.$existingType');
	}
	
	inline static public function getSparrowAtlas(key:String, ?rootDir:String = '') {
		return FlxAtlasFrames.fromSparrow(asset('$key.png', rootDir), asset('$key.xml', rootDir));
	}

	inline static public function getPackerAtlas(key:String, ?rootDir:String) {
		return FlxAtlasFrames.fromSpriteSheetPacker(asset('$key.png', rootDir), asset('$key.txt', rootDir));
	}

	public static function getAssetType(assettype:String):AssetType {
		switch (assettype) {
			case 'BINARY': 
				return BINARY;
			case 'FONT': 
				return FONT;
			case 'IMAGE': 
				return IMAGE;
			case 'MOVIE_CLIP': 
				return MOVIE_CLIP;
			case 'MUSIC': 
				return MUSIC;
			case 'SOUND': 
				return SOUND;
			default:
				return TEXT;
		}
	}
}
