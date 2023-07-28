package options;

import data.SaveData;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;

class ResetDataSubState extends MusicBeatSubstate
{
    public function new()
    {
        super();

        var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0.6;
		bg.scrollFactor.set();
		add(bg);

        var textWarm:FlxText = new FlxText(0, 0, 0, "?ARE YOU SURE?\n\nPRESS ENTER TO CONTINUE\nPRESS ESCAPE TO RETURN", 32);
        textWarm.scrollFactor.set();
        textWarm.alignment = CENTER;
        textWarm.screenCenter();
        add(textWarm);
    }    

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if (FlxG.keys.justPressed.ENTER)
        {
            SaveData.resetData(true);
            FlxG.switchState(new states.TitleState());
        }

        if (FlxG.keys.justPressed.ESCAPE)
        {
            close();
        }
    }
}