package modding;

import flixel.text.FlxText;
import flixel.group.FlxGroup.FlxTypedGroup;
import states.*;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.system.FlxAssets;
import flixel.util.FlxColor;

class EditiorsState extends MusicBeatState
{
    var item:Array<String> = [];

    // menu thing
    var menuItem:Array<String> = ["Editor", "Lua Code API", "Back"];
    var editorItem:Array<String> = ["Character", "Chart", "Week"];

    var curSelected:Int = 0;
    var group:FlxTypedGroup<Alphabet>;
    var descText:FlxText;

    override function create()
    {
        super.create();
        item  = menuItem;

		var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);

        group = new FlxTypedGroup<Alphabet>();
        add(group);

        for (i in 0...item.length)
        {
            var controlLabel:Alphabet = new Alphabet(0, (70 * i) + 30, item[i], true, false);
            controlLabel.isMenuItem = true;
            controlLabel.targetY = i;
            group.add(controlLabel);
        }

		descText = new FlxText(50, 650, 1180, "", 32);
		descText.setFormat(FlxAssets.FONT_DEBUGGER, 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		descText.scrollFactor.set();
		add(descText);

        changeSelection();
    }

    override function update(elapsed:Float) 
    {
        super.update(elapsed);

        if (controls.BACK){
			FlxG.switchState(new MainMenuState());
		}

		if (controls.UP_P)
			changeSelection(-1);

		if (controls.DOWN_P)
			changeSelection(1);

        if (controls.ACCEPT)
        {
            switch (item[curSelected])
            {
                case "Editor":
                    item = editorItem;
                    regenMenu();
                case "Back":
                    FlxG.switchState(new MainMenuState());
                case "Lua Code API":
                    trace("test");
            }
        }
    }

    function regenMenu():Void
    {
        for (i in 0...group.members.length)
            group.remove(group.members[0], true);

        for (i in 0...item.length)
        {
            var controlLabel:Alphabet = new Alphabet(0, (70 * i) + 30, item[i], true, false);
            controlLabel.isMenuItem = true;
            controlLabel.targetY = i;
            group.add(controlLabel);
        }

        curSelected = 0;
        changeSelection();
    }

    function changeSelection(change:Int = 0) {
        FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = group.length - 1;
		if (curSelected >= group.length)
			curSelected = 0;

        switch (item[curSelected])
        {
            case "Back": descText.text = "";
            case "Editor": descText.text = "Create own Thing like Character, Chart...";
            case "Lua Code API": descText.text = "This One will display and have sample\nof almost of this engine have";
            case "Character": descText.text = "Create Own Character";
            case "Chart": descText.text = "Create Own Chart";
            case "Week": descText.text = "Create Own Week";
        }

        var bullShit:Int = 0;

		for (item in group.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
    }
}