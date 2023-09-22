package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
// import lime.app.Application;

using StringTools;

class OutdatedSubState extends MusicBeatState
{
	public static var leftState:Bool = false;
	var continueBeta:Bool = false;

	override function create()
	{
		super.create();
		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);
		// var ver = "v" + Application.current.meta.get('version');
		var text:String;

		if (VERSION_POPENGINE.endsWith("-beta"))
		{
			continueBeta = true;
			text = "Hey\nYou Are Using a Beta Version!\nMaybe Contains Bug!\n\nPress Enter to Continue";
		}
		else
		{
			continueBeta = false;
			text = "Hey!\nYour version is outdate!\nplease update if you need!\n\nPress Enter to Continue";
		}

		var txt:FlxText = new FlxText(0, 0, FlxG.width,
			text,
			32);
		txt.setFormat(full_font, 32, FlxColor.WHITE, CENTER);
		txt.screenCenter();
		add(txt);
	}

	override function update(elapsed:Float)
	{
		if (controls.ACCEPT)
		{
			if (!continueBeta)
				FlxG.openURL("https://github.com/khuonghoanghuy/FNF-Pop-Engine-Rewrite/releases");
			else {
				leftState = true;
				FlxG.switchState(new MainMenuState());				
			}
		}
		
		if (controls.BACK)
		{
			leftState = true;
			FlxG.switchState(new MainMenuState());
		}

		super.update(elapsed);
	}
}
