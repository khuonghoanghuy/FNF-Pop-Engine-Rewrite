package modding;

import flixel.text.FlxText;
import states.MusicBeatState;
import flixel.FlxSprite;

class LuaCodeAPIState extends MusicBeatState
{
    var arrayString:Array<Array<String>> = [
        "How to Import lua file", "1. open assets/data/'song you wanna add'/\n2.make a file and set name is 'script.lua'"
    ];

    var curText:FlxText; // as title
    var curSelection:Int = 0;

    override function create() {
        super.create();

        var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (controls.BACK){
			FlxG.switchState(new EditorsState());
		}
    }
}