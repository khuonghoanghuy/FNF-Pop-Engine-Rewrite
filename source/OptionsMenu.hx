package;

import flixel.util.FlxSave;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import data.SaveData;

class OptionsMenu extends MusicBeatState
{
	var selector:FlxText;
	var curSelected:Int = 0;

	var controlsStrings:Array<String> = ["Ghost tap", "Downscroll", "Accuracy", "Botplay", "Watermark"];

	private var grpControls:FlxTypedGroup<Alphabet>;

	var descText:FlxText;
	var inBool:Bool;

	override function create()
	{
		var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		menuBG.color = 0xFFea71fd;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);

		grpControls = new FlxTypedGroup<Alphabet>();
		add(grpControls);

		for (i in 0...controlsStrings.length)
		{
			var controlLabel:Alphabet = new Alphabet(0, (70 * i) + 30, controlsStrings[i], true, false);
			controlLabel.isMenuItem = true;
			controlLabel.targetY = i;
			grpControls.add(controlLabel);
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
		}

		descText = new FlxText(50, 600, 1180, "", 32);
		descText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		descText.scrollFactor.set();
		add(descText);
		changeSelection();

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.BACK)
			FlxG.switchState(new MainMenuState());

		if (controls.UP_P)
			changeSelection(-1);

		if (controls.DOWN_P)
			changeSelection(1);

		if (controls.ACCEPT)
		{
			switch (controlsStrings[curSelected])
			{
				case "Ghost tap":
					if (SaveData.ghosttap) {
						SaveData.ghosttap = false;
						descText.text = "Help you play less miss - " + SaveData.ghosttap;
					} else {
						SaveData.ghosttap = true;
						descText.text = "Help you play less miss - " + SaveData.ghosttap;
					}

				case "Downscroll":
					if (SaveData.downscroll) {
						SaveData.downscroll = false;
						descText.text = "Change layout from upscroll to downscroll - " + SaveData.downscroll;
					} else {
						SaveData.downscroll = true;
						descText.text = "Change layout from upscroll to downscroll - " + SaveData.downscroll;
					}

				case "Accuracy":
					if (SaveData.accuracy) {
						SaveData.accuracy = false;
						descText.text = "Display more stuff like Misses, Accuracy - " + SaveData.downscroll;
					} else {
						SaveData.accuracy = true;
						descText.text = "Display more stuff like Misses, Accuracy - " + SaveData.downscroll;
					}
			}
		}
	}

	function getChange(bool:Bool)
	{
		inBool = bool;
	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = grpControls.length - 1;
		if (curSelected >= grpControls.length)
			curSelected = 0;

		switch (controlsStrings[curSelected])
		{
			case "Ghost tap":
				descText.text = "Help you play less miss - " + SaveData.ghosttap;
			case "Downscroll":
				descText.text = "Change layout from upscroll to downscroll - " + SaveData.downscroll;
			case "Accuracy":
				descText.text = "Display more stuff like Misses, Accuracy - " + SaveData.downscroll;
		}

		var bullShit:Int = 0;

		for (item in grpControls.members)
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
