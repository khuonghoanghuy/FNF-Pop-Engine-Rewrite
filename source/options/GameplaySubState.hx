package options;

import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.system.FlxAssets;

class GameplaySubState extends MusicBeatSubstate
{
    var arrayOption:Array<String> = [
        "Random Note",
        "Stair Note",
        "Health Drain"
    ];

    var group:FlxTypedGroup<Alphabet>;
    var curSelected:Int = 0;
    var curText:FlxText;

    public function new() 
    {
        super();

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0.6;
		bg.scrollFactor.set();
		add(bg);

        group = new FlxTypedGroup<Alphabet>();
        add(group);

        for (i in 0...arrayOption.length)
        {
            var controlLabel:Alphabet = new Alphabet(0, (70 * i) + 30, arrayOption[i], true, false);
            controlLabel.isMenuItem = true;
            controlLabel.targetY = i;
            group.add(controlLabel);
        }

        curText = new FlxText(0, 0, 0, "", 32);
        curText.setFormat(FlxAssets.FONT_DEBUGGER, 32, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        curText.scrollFactor.set();
        add(curText);

        changeSelection();
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        switch (arrayOption[curSelected])
        {
            case "Random Note": curText.text = FlxG.save.data.randomArrow;
            case "Stair Note": curText.text = FlxG.save.data.stairArrow;
            case "Health Drain": curText.text = FlxG.save.data.healthdrain;
        }

        if (controls.UP_P) {
            changeSelection(-1);
        }

        if (controls.DOWN_P) {
            changeSelection(1);
        }

        if (controls.ACCEPT) {
            FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
            switch (arrayOption[curSelected]) {
                case "Random Note":
                    if (FlxG.save.data.randomArrow) {
                        FlxG.save.data.randomArrow = false;
                    } else {
                        FlxG.save.data.randomArrow = true;
                    }
                
                case "Stair Note":
                    if (FlxG.save.data.stairArrow) {
                        FlxG.save.data.stairArrow = false;
                    } else {
                        FlxG.save.data.stairArrow = true;
                    }
                
                case "Health Drain":
                    if (FlxG.save.data.healthdrain) {
                        FlxG.save.data.healthdrain = false;
                    } else {
                        FlxG.save.data.healthdrain = true;
                    }
            }

            FlxG.save.flush();
        }

        if (controls.BACK) {
            FlxG.save.flush();
            close();
        }
    }

    function changeSelection(change:Int = 0) {
        FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = group.length - 1;
		if (curSelected >= group.length)
			curSelected = 0;

        switch (arrayOption[curSelected])
        {
            case "Random Note": curText.text = FlxG.save.data.randomArrow;
            case "Stair Note": curText.text = FlxG.save.data.stairArrow;
            case "Health Drain": curText.text = FlxG.save.data.healthdrain;
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