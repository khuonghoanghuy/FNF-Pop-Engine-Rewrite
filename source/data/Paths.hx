package;

#if sys
import sys.io.File;
import sys.FileSystem;
#end

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;

import flash.media.Sound;

import openfl.system.System;
import openfl.utils.AssetType;
import openfl.utils.Assets as Assets;
import openfl.display.BitmapData;

import haxe.Json;

using StringTools;

class Paths
{
	inline public static final SOUND_EXT = #if !web "ogg" #else "mp3" #end;

	#if MODS_ALLOWED
	public static var ignoreModFolders:Array<String> = [
		'data',
		'songs',
		'music',
		'sounds',
		'images',
		'fonts'
	];
	#end

	public static function excludeAsset(key:String) {
		if (!dumpExclusions.contains(key))
			dumpExclusions.push(key);
	}

	public static var dumpExclusions:Array<String> =
	[
		'assets/music/freakyMenu.$SOUND_EXT',
		'assets/music/breakfast.$SOUND_EXT',
	];

	/// haya I love you for the base cache dump I took to the max
	public static function clearUnusedMemory() 
	{
		// clear non local assets in the tracked assets list
		for (key in currentTrackedAssets.keys()) 
		{
			// if it is not currently contained within the used local assets
			if (!localTrackedAssets.contains(key) && !dumpExclusions.contains(key)) {
				// get rid of it
				var obj = currentTrackedAssets.get(key);
				@:privateAccess
				if (obj != null) 
				{
					Assets.cache.removeBitmapData(key);
					FlxG.bitmap._cache.remove(key);
					obj.destroy();
					currentTrackedAssets.remove(key);
				}
			}
		}
		// run the garbage collector for good measure lmfao
		System.gc();
	}

	// fuckin around ._.
	public static function removeBitmap(key)
	{
		var obj = currentTrackedAssets.get(key);
		@:privateAccess
		if (obj != null)
		{
			Assets.cache.removeBitmapData(key);
			FlxG.bitmap._cache.remove(key);
			obj.destroy();
			currentTrackedAssets.remove(key);
		}
	}

	// define the locally tracked assets
	public static var localTrackedAssets:Array<String> = [];
	public static function clearStoredMemory() 
	{
		// clear anything not in the tracked assets list
		@:privateAccess
		for (key in FlxG.bitmap._cache.keys())
		{
			var obj = FlxG.bitmap._cache.get(key);
			if (obj != null && !currentTrackedAssets.exists(key)) 
			{
				Assets.cache.removeBitmapData(key);
				FlxG.bitmap._cache.remove(key);
				obj.destroy();
			}
		}

		// clear all sounds that are cached
		for (key in currentTrackedSounds.keys()) 
		{
			if (!localTrackedAssets.contains(key) && !dumpExclusions.contains(key) && key != null) 
			{
				//trace('test: ' + dumpExclusions, key);
				Assets.cache.clear(key);
				currentTrackedSounds.remove(key);
			}
		}	
		// flags everything to be cleared out next unused memory clear
		localTrackedAssets = [];
		Assets.cache.clear("songs");
	}

	static var currentLevel:String;
	static public var currentModDirectory:String = '';

	static public function setCurrentLevel(name:String)
	{
		currentLevel = name.toLowerCase();
	}

	public static function getPath(file:String, type:AssetType, ?library:Null<String> = null)
	{
		if (library != null)
			return getLibraryPath(file, library);

		if (currentLevel != null)
		{
			var levelPath:String = '';
			if(currentLevel != 'shared') {
				levelPath = getLibraryPathForce(file, currentLevel);
				if (OpenFlAssets.exists(levelPath, type))
					return levelPath;
			}

			levelPath = getLibraryPathForce(file, "shared");
			if (OpenFlAssets.exists(levelPath, type))
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
		var returnPath = '$library:assets/$library/$file';
		return returnPath;
	}

	inline public static function getPreloadPath(file:String = '')
	{
		return 'assets/$file';
	}

	inline static public function txt(key:String, ?library:String)
	{
		return getPath('data/$key.txt', TEXT, library);
	}

	inline static public function xml(key:String, ?library:String)
	{
		return getPath('data/$key.xml', TEXT, library);
	}

	inline static public function json(key:String, ?library:String)
	{
		return getPath('data/$key.json', TEXT, library);
	}

	inline static public function lua(key:String, ?library:String)
	{
		return getPath('$key.lua', TEXT, library);
	}

	inline static public function exists(asset:String, ?type:lime.utils.AssetType)
	{
		#if sys 
		return FileSystem.exists(asset);
		#else
		return Assets.exists(asset, type);
		#end
	}

	inline static public function getContent(asset:String):Null<String> 
	{
		#if sys
		if (FileSystem.exists(asset))
			return File.getContent(asset);
		#else
		if (Assets.exists(asset))
			return Assets.getText(asset);
		#end

		return null;
	}

	#if html5
	static var pathMap = new Map<String, Array<String>>();

	public static function initPaths() 
	{	
		pathMap.clear();

		for (path in Assets.list())
		{
			var file = path.split("/").pop();
			var parent = path.substr(0, path.length - (file.length + 1)); // + 1 to remove the ending slash

			if (pathMap.exists(parent))
				pathMap.get(parent).push(file);
			else
				pathMap.set(parent, [file]);
		}

		return pathMap;
	}
	
	inline static public function iterateDirectory(Directory:String, Func)
	{
		var dir:String = Directory.endsWith("/") ? Directory.substr(0, -1) : Directory; // remove ending slash

		if (!pathMap.exists(dir))
			return;

		for (i in pathMap.get(dir))
			Func(i);
	}
	#else
	inline static public function iterateDirectory(Directory:String, Func):Bool
	{
		if (!FileSystem.exists(Directory) || !FileSystem.isDirectory(Directory))
			return false;
		
		for (i in FileSystem.readDirectory(Directory))
			Func(i);

		return true;
	}
	#end

	static public function sound(key:String, ?library:String):Sound
	{
		var sound:Sound = returnSound('sounds', key, library);
		return sound;
	}
	
	inline static public function soundRandom(key:String, min:Int, max:Int, ?library:String)
	{
		return sound(key + FlxG.random.int(min, max), library);
	}

	inline static public function music(key:String, ?library:String):Sound
	{
		var file:Sound = returnSound('music', key, library);
		return file;
	}

	inline static public function track(song:String, track:String):Any
	{
		return returnSound('songs', '${formatToSongPath(song)}/$track');
	}

	inline static public function voices(song:String):Any
	{
		return track(song, "Voices");
	}

	inline static public function inst(song:String):Any
	{
		return track(song, "Inst");
	}

	inline static public function image(key:String, ?library:String):FlxGraphic
	{
		var returnAsset:FlxGraphic = returnGraphic(key, library);
		return returnAsset;
	}
	
	static public function getTextFromFile(key:String, ?ignoreMods:Bool = false):String
	{
		#if sys
		#if MODS_ALLOWED
		if (!ignoreMods && FileSystem.exists(modFolders(key)))
			return File.getContent(modFolders(key));
		#end

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

	inline static public function font(key:String)
	{
		#if MODS_ALLOWED
		var file:String = modsFont(key);
		if(FileSystem.exists(file)) {
			return file;
		}
		#end
		return 'assets/fonts/$key';
	}

	inline static public function fileExists(key:String, type:AssetType, ?ignoreMods:Bool = false, ?library:String)
	{
		#if MODS_ALLOWED
		if (FileSystem.exists(mods(currentModDirectory + '/' + key)) || FileSystem.exists(mods(key)))
			return true;
		#end
		
		return Paths.exists(getPath(key, type));
	}

	inline static public function getSparrowAtlas(key:String, ?library:String):FlxAtlasFrames
	{
		#if MODS_ALLOWED
		var imageLoaded:FlxGraphic = returnGraphic(key);

		return FlxAtlasFrames.fromSparrow(
			(imageLoaded != null ? imageLoaded : image(key, library)),
			(FileSystem.exists(modsXml(key)) ? File.getContent(modsXml(key)) : getPath('images/$key.xml', library))
		);
		#else
		return FlxAtlasFrames.fromSparrow(image(key, library), getPath('images/$key.xml', library));
		#end
	}

	inline static public function getPackerAtlas(key:String, ?library:String)
	{
		#if MODS_ALLOWED
		var imageLoaded:FlxGraphic = returnGraphic(key);
		var txtExists:Bool = FileSystem.exists(modFolders('images/$key.txt'));

		return FlxAtlasFrames.fromSpriteSheetPacker((imageLoaded != null ? imageLoaded : image(key, library)),
			(txtExists ? File.getContent(modFolders('images/$key.txt')) : getPath('images/$key.txt', library)));
		#else
		return FlxAtlasFrames.fromSpriteSheetPacker(image(key, library), getPath('images/$key.txt', library));
		#end
	}

	inline static public function formatToSongPath(path:String) {
		return path.toLowerCase().replace(' ', '-');
	}

	// completely rewritten asset loading? fuck!
	public static var currentTrackedAssets:Map<String, FlxGraphic> = [];
	public static function getGraphic(path:String):FlxGraphic
	{
		#if html5
		return FlxG.bitmap.add(path, false, path);
		#elseif sys
		return FlxGraphic.fromBitmapData(BitmapData.fromFile(path), false, path);
		#end
	}

	public static function returnGraphic(key:String, ?library:String)
	{
		#if MODS_ALLOWED
		var modKey:String = modsImages(key);
		if (FileSystem.exists(modKey))
		{
			if (!currentTrackedAssets.exists(modKey)){
				var newGraphic:FlxGraphic = getGraphic(modKey);
				newGraphic.persist = true;
				currentTrackedAssets.set(modKey, newGraphic);
			}
			localTrackedAssets.push(modKey);
			return currentTrackedAssets.get(modKey);
		}
		#end

		var path = getPath('images/$key.png', IMAGE, library);
		if (Assets.exists(path, IMAGE))
		{
			if (!currentTrackedAssets.exists(path))
			{
				var newGraphic:FlxGraphic = getGraphic(path);
				newGraphic.persist = true;
				currentTrackedAssets.set(path, newGraphic);
			}
			localTrackedAssets.push(path);
			return currentTrackedAssets.get(path);
		}
		trace('oh no!!' + '$key' + 'returned null!');
		return null;
	}

	public static var currentTrackedSounds:Map<String, Sound> = [];

	public static function returnSoundPath(path:String, key:String, ?library:String)
	{
		#if MODS_ALLOWED
		var file:String = modsSounds(path, key);
		if (FileSystem.exists(file))
			return file;
		
		#end
		var gottenPath:String = getPath('$path/$key.$SOUND_EXT', SOUND, library);
		return gottenPath;
	}

	inline static public function cacheSound(sound:String):Sound
	{
		return FlxG.sound.cache(sound);
	}

	public static function returnSound(path:String, key:String, ?library:String)
	{
		#if MODS_ALLOWED
		var file:String = modsSounds(path, key);
		if (FileSystem.exists(file))
		{
			if (!currentTrackedSounds.exists(file))
				currentTrackedSounds.set(file, Sound.fromFile(file));
			
			localTrackedAssets.push(key);
			return currentTrackedSounds.get(file);
		}
		#end
		// I hate this so god damn much
		var gottenPath:String = getPath('$path/$key.$SOUND_EXT', SOUND, library);
		gottenPath = gottenPath.substring(gottenPath.indexOf(':') + 1, gottenPath.length);
		if (!currentTrackedSounds.exists(gottenPath))
			#if MODS_ALLOWED
			currentTrackedSounds.set(gottenPath, Sound.fromFile('./$gottenPath'));
			#else
				currentTrackedSounds.set(
					gottenPath, 
					Assets.getSound((path == 'songs' ? folder = 'songs:' : '') + getPath('$path/$key.$SOUND_EXT', SOUND, library))
				);
			#end
		localTrackedAssets.push(gottenPath);
		return currentTrackedSounds.get(gottenPath);
	}
	
	#if MODS_ALLOWED
	static final modFolderPath:String = "mods/";

	inline static public function mods(key:String = '')
		return modFolderPath + key;
	
	inline static public function modsFont(key:String)
		return modFolders('fonts/' + key);

	inline static public function modsJson(key:String)
		return modFolders('data/' + key + '.json');

	inline static public function modsSounds(path:String, key:String)
		return modFolders(path + '/' + key + '.' + SOUND_EXT);

	inline static public function modsImages(key:String)
		return modFolders('images/' + key + '.png');

	inline static public function modsXml(key:String)
		return modFolders('images/' + key + '.xml');

	inline static public function modsTxt(key:String)
		return modFolders('images/' + key + '.txt');

	static public function modFolders(key:String) {
		if(currentModDirectory != null && currentModDirectory.length > 0) {
			var fileToCheck:String = mods(currentModDirectory + '/' + key);
			if(FileSystem.exists(fileToCheck)) {
				return fileToCheck;
			}
		}
		return 'mods/' + key;
	}
	static public function getModDirectories():Array<String> {
		var list:Array<String> = [];
		var modsFolder:String = mods();
		if(FileSystem.exists(modsFolder)) {
			for (folder in FileSystem.readDirectory(modsFolder)) {
				var path = haxe.io.Path.join([modsFolder, folder]);
				if (sys.FileSystem.isDirectory(path) && !ignoreModFolders.contains(folder) && !list.contains(folder)) {
					list.push(folder);
				}
			}
		}
		return list;
	}
	#end
}