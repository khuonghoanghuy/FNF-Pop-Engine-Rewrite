package data;

import flixel.util.FlxSave;
import flixel.FlxG;

class SaveData
{
	inline public static function init()
	{
		if (FlxG.save.data.ghosttap == null) {
			FlxG.save.data.ghosttap = true;
		}

		if (FlxG.save.data.downscroll == null) {
			FlxG.save.data.downscroll = false;
		}

		if (FlxG.save.data.accuracy == null) {
			FlxG.save.data.accuracy = true;
		}

		if (FlxG.save.data.botplay == null) {
			FlxG.save.data.botplay = false;
		}

		if (FlxG.save.data.watermark == null) {
			FlxG.save.data.watermark = true;
		}

		if (FlxG.save.data.fpsCounter == null) {
			FlxG.save.data.fpsCounter = true;
		}

		if (FlxG.save.data.fps == null) {
			FlxG.save.data.fps = 60;
		}

		if (FlxG.save.data.accuracyType == null) {
			FlxG.save.data.accuracyType = "SIMPLE";
		}

		// key system
		if (FlxG.save.data.leftArrow == null) {
			FlxG.save.data.leftArrow = "A";
		}

		if (FlxG.save.data.downArrow == null) {
			FlxG.save.data.downArrow = "S";
		}

		if (FlxG.save.data.upArrow == null) {
			FlxG.save.data.upArrow = "W";
		}

		if (FlxG.save.data.rightArrow == null) {
			FlxG.save.data.rightArrow = "D";
		}

		if (FlxG.save.data.leftAltArrow == null) {
			FlxG.save.data.leftAltArrow = "LEFT";
		}

		if (FlxG.save.data.downAltArrow == null) {
			FlxG.save.data.downAltArrow = "UP";
		}

		if (FlxG.save.data.upAltArrow == null) {
			FlxG.save.data.upAltArrow = "DOWN";
		}

		if (FlxG.save.data.rightAltArrow == null) {
			FlxG.save.data.rightAltArrow = "RIGHT";
		}

		if (FlxG.save.data.randomArrow == null) {
			FlxG.save.data.randomArrow = false;
		}

		if (FlxG.save.data.stairArrow == null) {
			FlxG.save.data.stairArrow = false;
		}

		if (FlxG.save.data.healthdrain == null) {
			FlxG.save.data.healthdrain = false;
		}

		// FlxG.save.flush();
	}

	inline public static function getPath(name:String, ?path:String)
	{
		var save:FlxSave = new FlxSave();
		save.bind(name, path);
		FlxG.log.add("Data save complete!");
	}
}