package options;

import flixel.util.FlxSave;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import data.SaveData;
import states.MainMenuState;

class OptionsMenu extends MusicBeatState
{
	var selector:FlxText;
	var curSelected:Int = 0;

	var controlsStrings:Array<String> = [];

	var selectArray:Array<String> = ["Controls", "Gameplay", "Misc", "Exit"];
	var gameplayArray:Array<String> = ["Ghost tap", "Downscroll", "Accuracy", "Accuracy Type", "Botplay", "Back"];
	var shadersArray:Array<String> = ["VHS Shader", "Back"];
	var miscArray:Array<String> = ["Watermark", "Show BG Black", "FPS Counter", "FPS", "RESET DATA", "Back"];

	private var grpControls:FlxTypedGroup<Alphabet>;

	var descText:FlxText;
	var inBool:Bool;

	override function create()
	{
		// at begin
		controlsStrings = selectArray;

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

		descText = new FlxText(50, 650, 1180, "", 32);
		descText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		descText.scrollFactor.set();
		add(descText);

		changeSelection();

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.BACK){
			FlxG.save.flush();
			FlxG.switchState(new MainMenuState());
		}

		if (controls.UP_P)
			changeSelection(-1);

		if (controls.DOWN_P)
			changeSelection(1);

		if (controls.LEFT_R)
		{
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
			if (controlsStrings == gameplayArray)
			{
				switch (controlsStrings[curSelected])
				{
					case "Accuracy Type":
						if (FlxG.save.data.accuracyType == "SIMPLE") FlxG.save.data.accuracyType = "COMPLEX";
						else if (FlxG.save.data.accuracyType == "COMPLEX") FlxG.save.data.accuracyType = "SIMPLE";
						FlxG.save.data.accuracyType = FlxG.save.data.accuracyType;
						if (FlxG.save.data.accuracyType == "SIMPLE") descText.text = "If SIMPLE, only hit note\nType: " + FlxG.save.data.accuracyType; else if (FlxG.save.data.accuracyType == "COMPLEX") descText.text = "If COMPLEX, harder than SIMPLE, more Accurate\nType: " + FlxG.save.data.accuracyType;
				}
			}

			if (controlsStrings == miscArray)
			{
				switch (controlsStrings[curSelected])
				{
					case "FPS": 
						if (FlxG.save.data.fps == 60)
							FlxG.save.data.fps -= 0;
						else
							FlxG.save.data.fps -= 10;
						FlxG.drawFramerate = FlxG.save.data.fps;
						FlxG.updateFramerate = FlxG.save.data.fps;
						descText.text = "Currents FPS: " + FlxG.save.data.fps;
				}
			}
		}
		
		if (controls.RIGHT_P)
		{
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
			if (controlsStrings == gameplayArray)
			{
				switch (controlsStrings[curSelected])
				{
					case "Accuracy Type":
						if (FlxG.save.data.accuracyType == "SIMPLE") FlxG.save.data.accuracyType = "COMPLEX";
						else if (FlxG.save.data.accuracyType == "COMPLEX") FlxG.save.data.accuracyType = "SIMPLE";
						FlxG.save.data.accuracyType = FlxG.save.data.accuracyType;
						if (FlxG.save.data.accuracyType == "SIMPLE") descText.text = "If SIMPLE, only hit note\nType: " + FlxG.save.data.accuracyType; else if (FlxG.save.data.accuracyType == "COMPLEX") descText.text = "If COMPLEX, harder than SIMPLE, more Accurate\nType: " + FlxG.save.data.accuracyType;
				}
			}

			if (controlsStrings == miscArray)
			{
				switch (controlsStrings[curSelected])
				{
					case "FPS": 
						if (FlxG.save.data.fps == 360)
							FlxG.save.data.fps += 0;
						else
							FlxG.save.data.fps += 10;
						FlxG.drawFramerate = FlxG.save.data.fps;
						FlxG.updateFramerate = FlxG.save.data.fps;
						descText.text = "Currents FPS: " + FlxG.save.data.fps;
				}
			}
		}

		if (controls.ACCEPT)
		{
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
			switch (controlsStrings[curSelected])
			{
				case "Controls":
					// openSubState(new ControlsSubState());
					FlxG.switchState(new ControlsState());

				case "Gameplay":
					controlsStrings = gameplayArray;
					regenMenu();

				case "Shaders":
					controlsStrings = shadersArray;
					regenMenu();

				case "Misc":
					controlsStrings = miscArray;
					regenMenu();

				case "Exit":
					FlxG.switchState(new MainMenuState());
					
			}

			if (controlsStrings == gameplayArray)
			{
				switch (controlsStrings[curSelected])
				{
					case "Ghost tap":
						if (FlxG.save.data.ghosttap) {
							FlxG.save.data.ghosttap = false;
							descText.text = "Help you play less miss: " + FlxG.save.data.ghosttap;
						} else {
							FlxG.save.data.ghosttap = true;
							descText.text = "Help you play less miss: " + FlxG.save.data.ghosttap;
						}
	
					case "Downscroll":
						if (FlxG.save.data.downscroll) {
							FlxG.save.data.downscroll = false;
							descText.text = "Change layout from upscroll to downscroll: " + FlxG.save.data.downscroll;
						} else {
							FlxG.save.data.downscroll = true;
							descText.text = "Change layout from upscroll to downscroll: " + FlxG.save.data.downscroll;
						}
	
					case "Accuracy":
						if (FlxG.save.data.accuracy) {
							FlxG.save.data.accuracy = false;
							descText.text = "Display more stuff like Misses, Accuracy: " + FlxG.save.data.accuracy;
						} else {
							FlxG.save.data.accuracy = true;
							descText.text = "Display more stuff like Misses, Accuracy: " + FlxG.save.data.accuracy;
						}

					case "Botplay":
						if (FlxG.save.data.botplay) {
							FlxG.save.data.botplay = false;
							descText.text = "Lets botplay play help for you!: " + FlxG.save.data.botplay;
						} else {
							FlxG.save.data.botplay = true;
							descText.text = "Lets botplay play help for you!: " + FlxG.save.data.botplay;
						}

					case "Back":
						controlsStrings = selectArray;
						regenMenu();
				}
			}

			if (controlsStrings == shadersArray)
			{
				switch (controlsStrings[curSelected])
				{
					case "VHS Shader":
						if (FlxG.save.data.shadersVHS) {
							FlxG.save.data.shadersVHS = false;
							descText.text = "Enable/Disable VHS Shaders (LAG WARMING): " + FlxG.save.data.shadersVHS;
						} else {
							FlxG.save.data.shadersVHS = true;
							descText.text = "Enable/Disable VHS Shaders (LAG WARMING): " + FlxG.save.data.shadersVHS;
						}

					case "Back":
						controlsStrings = selectArray;
						regenMenu();
				}
			}

			if (controlsStrings == miscArray)
			{
				switch (controlsStrings[curSelected])
				{
					case "Watermark":
						if (FlxG.save.data.watermark) {
							FlxG.save.data.watermark = false;
							descText.text = "Enable/Disable Pop Engine Watermark: " + FlxG.save.data.watermark;
						} else {
							FlxG.save.data.watermark = true;
							descText.text = "Enable/Disable Pop Engine Watermark: " + FlxG.save.data.watermark;
						}

					case "FPS Counter":						
						if (FlxG.save.data.fpsCounter) {
							FlxG.save.data.fpsCounter = false;
							descText.text = "Display FPS Counter: " + FlxG.save.data.fpsCounter;
						} else {
							FlxG.save.data.fpsCounter = true;
							descText.text = "Display FPS Counter: " + FlxG.save.data.fpsCounter;
						}

					case "RESET DATA":
						openSubState(new ResetDataSubState());

					case "Back":
						controlsStrings = selectArray;
						regenMenu();
				}
			}
		}
	}

	function regenMenu():Void
	{
		for (i in 0...grpControls.members.length)
			grpControls.remove(grpControls.members[0], true);

		for (i in 0...controlsStrings.length)
		{
			var controlLabel:Alphabet = new Alphabet(0, (70 * i) + 30, controlsStrings[i], true, false);
			controlLabel.isMenuItem = true;
			controlLabel.targetY = i;
			grpControls.add(controlLabel);
		}

		curSelected = 0;
		changeSelection();
	}

	/*function getChange(bool:Bool)
	{
		inBool = bool;
	}*/

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
			case "Controls" | "Gameplay" | "Misc" | "Exit": descText.text = "";
			case "Ghost tap": descText.text = "Help you play less miss: " + FlxG.save.data.ghosttap;
			case "Downscroll": descText.text = "Change layout from upscroll to downscroll: " + FlxG.save.data.downscroll;
			case "Accuracy": descText.text = "Display more stuff like Misses, Accuracy: " + FlxG.save.data.accuracy;
			case "Accuracy Type": if (FlxG.save.data.accuracyType == "SIMPLE") descText.text = "If SIMPLE, only hit note\nType: " + FlxG.save.data.accuracyType; else if (FlxG.save.data.accuracyType == "COMPLEX") descText.text = "If COMPLEX, harder than SIMPLE, more Accurate\nType: " + FlxG.save.data.accuracyType;
			case "Botplay": descText.text = "Lets botplay play help for you!: " + FlxG.save.data.botplay;
			case "Watermark": descText.text = "Enable/Disable Pop Engine Watermark: " + FlxG.save.data.watermark;
			case "FPS Counter": descText.text = "Display FPS Counter: " + FlxG.save.data.fpsCounter;
			case "FPS": descText.text = "Currents FPS: " + FlxG.save.data.fps;
			case "VHS Shader": descText.text = "Enable/Disable VHS Shaders (LAG WARMING): " + FlxG.save.data.shadersVHS;
			case "RESET DATA": descText.text = "RESET ALL DATA WHEN YOU PRESS ENTER";
			case "Back": descText.text = "Back to Options";
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
