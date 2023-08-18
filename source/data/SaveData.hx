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
	public static var shadersVHS:Bool = false;

	// key
	public static var leftArrow:String = "A";
	public static var leftAltArrow:String = "LEFT";
	public static var downArrow:String = "S";
	public static var downAltArrow:String = "DOWN";
	public static var upArrow:String = "W";
	public static var upAltArrow:String = "UP";
	public static var rightArrow:String = "D";
	public static var rightAltArrow:String = "RIGHT";

	inline public static function init()
	{
		if (FlxG.save.data.ghosttap == null) {
			FlxG.save.data.ghosttap = ghosttap;
			ghosttap = FlxG.save.data.ghosttap;
		}

		if (FlxG.save.data.downscroll == null) {
			FlxG.save.data.downscroll = downscroll;
			downscroll = FlxG.save.data.downscroll;
		}

		if (FlxG.save.data.accuracy == null) {
			FlxG.save.data.accuracy = accuracy;
			accuracy = FlxG.save.data.accuracy;
		}

		if (FlxG.save.data.botplay == null) {
			FlxG.save.data.botplay = botplay;
			botplay = FlxG.save.data.botplay;
		}

		if (FlxG.save.data.watermark == null) {
			FlxG.save.data.watermark = watermark;
			watermark = FlxG.save.data.watermark;
		}

		if (FlxG.save.data.fpsCounter == null) {
			FlxG.save.data.fpsCounter = fpsCounter;
			fpsCounter = FlxG.save.data.fpsCounter;
		}

		if (FlxG.save.data.fps == null) {
			FlxG.save.data.fps = fps;
			fps = FlxG.save.data.fps;
		}

		if (FlxG.save.data.accuracyType == null) {
			FlxG.save.data.accuracyType = accuracyType;
			accuracyType = FlxG.save.data.accuracyType;
		}

		if (FlxG.save.data.leftArrow == null) {
			FlxG.save.data.leftArrow = leftArrow;
			leftArrow = FlxG.save.data.leftArrow;
		}

		if (FlxG.save.data.downArrow == null) {
			FlxG.save.data.downArrow = downArrow;
			downArrow = FlxG.save.data.downArrow;
		}

		if (FlxG.save.data.upArrow == null) {
			FlxG.save.data.upArrow = upArrow;
			upArrow = FlxG.save.data.upArrow;
		}

		if (FlxG.save.data.rightArrow == null) {
			FlxG.save.data.rightArrow = rightArrow;
			rightArrow = FlxG.save.data.rightArrow;
		}

		if (FlxG.save.data.leftAltArrow == null) {
			FlxG.save.data.leftAltArrow = leftAltArrow;
			leftAltArrow = FlxG.save.data.leftAltArrow;
		}

		if (FlxG.save.data.downAltArrow == null) {
			FlxG.save.data.downAltArrow = downAltArrow;
			downAltArrow = FlxG.save.data.downAltArrow;
		}

		if (FlxG.save.data.upAltArrow == null) {
			FlxG.save.data.upAltArrow = upAltArrow;
			upAltArrow = FlxG.save.data.upAltArrow;
		}

		if (FlxG.save.data.rightAltArrow == null) {
			FlxG.save.data.rightAltArrow = rightAltArrow;
			rightAltArrow = FlxG.save.data.rightAltArrow;
		}

		getPath("Options", "Huy1234TH");
	}

	inline public static function getPath(name:String, ?path:String)
	{
		var save:FlxSave = new FlxSave();
		save.bind(name, path);
		FlxG.log.add("Data save complete!");
	}
}