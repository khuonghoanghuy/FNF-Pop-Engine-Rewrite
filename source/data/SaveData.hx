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

	public static function getSave()
	{
		FlxG.save.data.ghosttap = ghosttap;
		FlxG.save.data.downscroll = downscroll;
		FlxG.save.data.accuracy = accuracy;
		FlxG.save.data.botplay = botplay;
		FlxG.save.data.watermark = watermark;

		getPath("Options", "Huy1234TH");
	}

	public static function getLoad()
	{
		if (FlxG.save.data.ghosttap != null) ghosttap = FlxG.save.data.ghosttap;
		if (FlxG.save.data.downscroll != null) downscroll = FlxG.save.data.downscroll;
		if (FlxG.save.data.accuracy != null) accuracy = FlxG.save.data.accuracy;
		if (FlxG.save.data.botplay != null) botplay = FlxG.save.data.botplay;
		if (FlxG.save.data.watermark != null) watermark = FlxG.save.data.watermark;

		getPath("Options", "Huy1234TH");
	}

	public static function getPath(name:String, ?path:String)
	{
		var save:FlxSave = new FlxSave();
		save.bind(name, path);
		FlxG.log.add("Data save complete!");
	}
}