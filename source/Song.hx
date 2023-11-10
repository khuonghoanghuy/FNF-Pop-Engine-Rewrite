package;

import Section.SwagSection;
import tjson.TJSON as Json;
import lime.utils.Assets;
#if sys
import sys.io.File;
import sys.FileSystem;
#end

using StringTools;

typedef SwagSong =
{
	var song:String;
	var notes:Array<SwagSection>;
	var bpm:Float;
	var needsVoices:Bool;
	var speed:Float;

	var player1:String;
	var player2:String;
	var gfVersion:String;
	var stages:String;
	var validScore:Bool;

	var camlerpInt:Int;
}

class Song
{
	public var song:String;
	public var notes:Array<SwagSection>;
	public var bpm:Float;
	public var needsVoices:Bool = true;
	public var speed:Float = 1;

	public var player1:String = 'bf';
	public var player2:String = 'dad';
	public var gfVersion:String = 'gf';
	public var stages:String = 'stage';
	public var camlerpInt:Int = 60;

	public function new(song, notes, bpm)
	{
		this.song = song;
		this.notes = notes;
		this.bpm = bpm;
	}

	public static function loadFromJson(jsonInput:String, ?folder:String):SwagSong
	{
		var rawJson = null;

		#if (sys && MODS_ALLOWED)
		if (FileSystem.exists(Paths.modsJson(folder.toLowerCase() + '/' + jsonInput.toLowerCase())))
			rawJson = File.getContent(Paths.modsJson(folder.toLowerCase() + '/' + jsonInput.toLowerCase())).trim();
		else
			rawJson = Assets.getText(Paths.json(folder.toLowerCase() + '/' + jsonInput.toLowerCase())).trim();
		#else
		rawJson = Assets.getText(Paths.json(folder.toLowerCase() + '/' + jsonInput.toLowerCase())).trim();
		#end

		while (!rawJson.endsWith("}")) rawJson = rawJson.substr(0, rawJson.length - 1);

		return parseJSONshit(rawJson);
	}

	public static function parseJSONshit(rawJson:String):SwagSong
	{
		var swagShit:SwagSong = cast Json.parse(rawJson).song;
		swagShit.validScore = true;
		return swagShit;
	}
}
