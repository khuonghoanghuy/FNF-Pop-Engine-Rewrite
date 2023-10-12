package data;

import core.ModCore;
import openfl.media.Sound;
import flixel.FlxG;
import flixel.graphics.frames.FlxAtlasFrames;
import openfl.utils.AssetType;
import openfl.utils.Assets;
import flixel.graphics.FlxGraphic;
#if sys
import sys.FileSystem;
import sys.io.File;
#end

class Paths
{
	inline public static final SOUND_EXT = #if web "mp3" #else "ogg" #end;

	static var currentLevel:String;

	static public function setCurrentLevel(name:String)
	{
		currentLevel = name.toLowerCase();
	}

	public static var currentTrackedAssets:Map<String, FlxGraphic> = [];
	public static var currentTrackedSounds:Map<String, Sound> = [];

	public static var localTrackedAssets:Array<String> = [];

	public static function clearUnusedMemory()
	{
		for (key in currentTrackedAssets.keys())
		{
			if (!localTrackedAssets.contains(key) && key != null)
			{
				var obj = currentTrackedAssets.get(key);
				@:privateAccess
				if (obj != null)
				{
					Assets.cache.removeBitmapData(key);
					Assets.cache.clearBitmapData(key);
					Assets.cache.clear(key);
					FlxG.bitmap._cache.remove(key);
					obj.destroy();
					currentTrackedAssets.remove(key);
				}
			}
		}

		for (key in currentTrackedSounds.keys())
		{
			if (!localTrackedAssets.contains(key) && key != null)
			{
				var obj = currentTrackedSounds.get(key);
				if (obj != null)
				{
					Assets.cache.removeSound(key);
					Assets.cache.clearSounds(key);
					Assets.cache.clear(key);
					currentTrackedSounds.remove(key);
				}
			}
		}
	}

	public static function clearStoredMemory()
	{
		@:privateAccess
		for (key in FlxG.bitmap._cache.keys())
		{
			var obj = FlxG.bitmap._cache.get(key);
			if (obj != null && !currentTrackedAssets.exists(key))
			{
				Assets.cache.removeBitmapData(key);
				Assets.cache.clearBitmapData(key);
				Assets.cache.clear(key);
				FlxG.bitmap._cache.remove(key);
				obj.destroy();
			}
		}

		@:privateAccess
		for (key in Assets.cache.getSoundKeys())
		{
			if (key != null && !currentTrackedSounds.exists(key))
			{
				var obj = Assets.cache.getSound(key);
				if (obj != null)
				{
					Assets.cache.removeSound(key);
					Assets.cache.clearSounds(key);
					Assets.cache.clear(key);
				}
			}
		}

		localTrackedAssets = [];
	}

	static function getPath(file:String, type:AssetType, ?library:Null<String> = null)
	{
		if (library != null)
			return getLibraryPath(file, library);

		if (currentLevel != null)
		{
			var levelPath = getLibraryPathForce(file, currentLevel);
			if (Assets.exists(levelPath, type))
				return levelPath;

			levelPath = getLibraryPathForce(file, "shared");
			if (Assets.exists(levelPath, type))
				return levelPath;
		}

		return getPreloadPath(file);
	}

	static public function getLibraryPath(file:String, library = "preload")
	{
		return if (library == "preload" || library == "default") getPreloadPath(file); else getLibraryPathForce(file, library);
	}

	inline static function getLibraryPathForce(file:String, library:String)
	{
		return '$library:assets/$library/$file';
	}

	inline static function getPreloadPath(file:String)
	{
		return 'assets/$file';
	}

	static public function getTextFromFile(key:String)
	{
		#if sys
		if (FileSystem.exists(getPreloadPath(key)))
			return File.getContent(getPreloadPath(key));

		if (currentLevel != null)
		{
			var levelPath:String = '';
			if(currentLevel != 'shared') {
				levelPath = getLibraryPathForce(key, currentLevel);
				if (FileSystem.exists(levelPath))
					return File.getContent(levelPath);
			}

			levelPath = getLibraryPathForce(key, 'shared');
			if (FileSystem.exists(levelPath))
				return File.getContent(levelPath);
		}
		#end
		return Assets.getText(getPath(key, TEXT));
	}

	inline static public function file(file:String, type:AssetType = TEXT, ?library:String)
	{
		return getPath(file, type, library);
	}

	inline static public function txt(key:String, ?library:String)
	{
		return getPath('data/$key.txt', TEXT, library);
	}

	inline static public function xml(key:String, ?library:String)
	{
		return getPath('images/$key.xml', TEXT, library);
	}

	inline static public function json(key:String, ?library:String)
	{
		return getPath('data/$key.json', TEXT, library);
	}

	inline static public function lua(key:String, ?library:String)
	{
		return getPath('data/$key.lua', TEXT, library);
	}

	inline static public function song(key:String, song:String, ?library:String)
	{
		return getPath('data/' + song + '/$key.json', TEXT, library);
	}

	static public function sound(key:String, ?cache:Bool = true):Sound
	{
		return returnSound('sounds/$key', cache);
	}

	inline static public function soundRandom(key:String, min:Int, max:Int, ?cache:Bool)
	{
		return sound(key + FlxG.random.int(min, max), cache);
	}

	inline static public function music(key:String, ?cache:Bool = true)
	{
		return returnSound('music/$key', cache);
	}

	inline static public function voices(song:String, ?cache:Bool = true)
	{
		return returnSound('songs/' + ${song.toLowerCase()} + '/Voices', cache);
	}

	inline static public function inst(song:String, ?cache:Bool = true)
	{
		return returnSound('songs/' + ${song.toLowerCase()} + '/Inst', cache);
	}

	inline static public function image(key:String, ?library:String, ?cache:Bool = true):FlxGraphic
	{
		return returnGraphic('images/$key', cache);
	}

	inline static public function font(key:String)
	{
		return 'assets/fonts/$key';
	}

	inline static public function getSparrowAtlas(key:String, ?library:String, ?cache:Bool = true):FlxAtlasFrames
	{
		return FlxAtlasFrames.fromSparrow(returnGraphic('images/$key', cache), xml('images/$key'));
	}

	inline static public function getPackerAtlas(key:String, ?library:String, ?cache:Bool = true):FlxAtlasFrames
	{
		return FlxAtlasFrames.fromSpriteSheetPacker(returnGraphic('images/$key', cache), txt('images/$key'));
	}

	inline static public function cacheSound(sound:String):Sound
	{
		return FlxG.sound.cache(sound);
	}

	public static function returnGraphic(key:String, ?cache:Null<Bool> = true):FlxGraphic
	{
		var path:String = 'assets/$key.png';
		if (Assets.exists(path, IMAGE))
		{
			if (!currentTrackedAssets.exists(path))
			{
				var graphic:FlxGraphic = FlxGraphic.fromBitmapData(Assets.getBitmapData(path), false, path, cache);
				graphic.persist = true;
				currentTrackedAssets.set(path, graphic);
			}

			localTrackedAssets.push(path);
			return currentTrackedAssets.get(path);
		}

		trace('$key its null');
		return null;
	}

	public static function returnSound(key:String, ?cache:Null<Bool> = true):Sound
	{
		if (Assets.exists('assets/$key.$SOUND_EXT', SOUND))
		{
			var path:String = 'assets/$key.$SOUND_EXT';
			if (!currentTrackedSounds.exists(path))
				currentTrackedSounds.set(path, Assets.getSound(path, cache));

			localTrackedAssets.push(path);
			return currentTrackedSounds.get(path);
		}

		trace('$key its null');
		return null;
	}

	#if FUTURE_POLYMOD
	static public function mods(key:String = '')
	{
		var modsPath:String = "mods/";
		if (ModCore.trackedMods != [])
		{
			for (i in 0...ModCore.trackedMods.length)
			{
				return modsPath + ModCore.trackedMods[i] + '/' + key;
			}
		}
		else
		{
			return modsPath + key;
		}
	}

	inline static public function modsFont(key:String)
		return mods('fonts/$key');

	inline static public function modsTxt(key:String)
		return mods('data/$key.txt');

	inline static public function modsJson(key:String)
		return mods('data/$key.json');

	inline static public function modsLua(key:String)
		return mods('data/$key.lua');

	inline static public function modsSounds(key:String)
		return mods('sounds/$key.$SOUND_EXT');

	inline static public function modsImages(key:String)
		return mods('images/$key.png');

	inline static public function modsXml(key:String)
		return mods('images/$key.xml');
	#end
}
