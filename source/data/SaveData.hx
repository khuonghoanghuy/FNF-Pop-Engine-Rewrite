package data;

import flixel.util.FlxSave;
import flixel.FlxG;

class SaveData
{
	public static var ghosttap:Bool = true;
	public static var downscroll:Bool = false;
	public static var accuracy:Bool = true;
	public static var botplay:Bool = false;
	public static var watermark:Bool = true;
	public static var fpsCounter:Bool = true;
	public static var fps:Int = 60;
	public static var accuracyType:String = "SIMPLE";

	public static function getSave()
	{
		FlxG.save.data.ghosttap = ghosttap;
		FlxG.save.data.downscroll = downscroll;
		FlxG.save.data.accuracy = accuracy;
		FlxG.save.data.botplay = botplay;
		FlxG.save.data.watermark = watermark;
		FlxG.save.data.fpsCounter = fpsCounter;
		FlxG.save.data.fps = fps;
		FlxG.save.data.accuracyType = accuracyType;

		getLoad();

		getPath("Options", "Huy1234TH");
	}

	public static function getLoad()
	{
		if (FlxG.save.data.ghosttap != null) ghosttap = FlxG.save.data.ghosttap;
		if (FlxG.save.data.downscroll != null) downscroll = FlxG.save.data.downscroll;
		if (FlxG.save.data.accuracy != null) accuracy = FlxG.save.data.accuracy;
		if (FlxG.save.data.botplay != null) botplay = FlxG.save.data.botplay;
		if (FlxG.save.data.watermark != null) watermark = FlxG.save.data.watermark;
		if (FlxG.save.data.fpsCounter != null) fpsCounter = FlxG.save.data.fpsCounter;
		if (FlxG.save.data.fps != null) getFPS(fps);
		if (FlxG.save.data.accuracyType != null) accuracyType = FlxG.save.data.accuracyType;

		getPath("Options", "Huy1234TH");
	}

	public static function getPath(name:String, ?path:String)
	{
		var save:FlxSave = new FlxSave();
		save.bind(name, path);
		FlxG.log.add("Data save complete!");
	}

	public static function getFPS(curfps:Int)
	{
		FlxG.drawFramerate = curfps;
		FlxG.updateFramerate = curfps;
	}

	/**
		Make sure that data is like in the var
	**/
	public static function resetData(s:Bool)
	{
		FlxG.save.data.ghosttap = true;
		FlxG.save.data.downscroll = false;
		FlxG.save.data.accuracy = true;
		FlxG.save.data.botplay = false;
		FlxG.save.data.watermark = true;
		FlxG.save.data.fpsCounter = true;
		FlxG.save.data.fps = 60;
		FlxG.save.data.accuracyType = "SIMPLE";
		
		getSave();
		getLoad();

		return s;
	}
}