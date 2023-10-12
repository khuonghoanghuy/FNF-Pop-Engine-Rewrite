package states;

import core.ModCore;
import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.graphics.FlxGraphic;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.addons.transition.FlxTransitionableState;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import haxe.io.Bytes;
import openfl.display.BitmapData;

class ModsState extends states.MusicBeatState
{
	private var daMods:FlxTypedGroup<Alphabet>;
	private var iconArray:Array<ModIcon> = [];
	private var description:FlxText;
	private var curSelected:Int = 0;

	override function create()
	{
        Paths.clearStoredMemory();
		Paths.clearUnusedMemory();

        transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = true;

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.color = 0xFFea71fd;
		add(bg);

		daMods = new FlxTypedGroup<Alphabet>();
		add(daMods);

		for (i in 0...ModCore.trackedMods.length)
		{
			var text:Alphabet = new Alphabet(0, (70 * i) + 30, ModCore.trackedMods[i].title, false, false);
			text.isMenuItem = true;
			text.forceX = 70;
			text.targetY = i;
			daMods.add(text);

			var icon:ModIcon = new ModIcon(ModCore.trackedMods[i].icon);
			icon.sprTracker = text;
			iconArray.push(icon);
			add(icon);
		}

		description = new FlxText(0, FlxG.height * 0.1, FlxG.width * 0.9, '', 28);
		description.setFormat(Paths.font("vcr.ttf"), 28, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		description.screenCenter(X);
		description.scrollFactor.set();
		description.borderSize = 3;
		add(description);

		changeSelection();

		super.create();
	}

	override function update(elapsed:Float)
	{
		if (controls.UP_P || controls.DOWN_P)
			changeSelection(controls.UP_P ? -1 : 1);
		else if (FlxG.mouse.wheel != 0)
			changeSelection(-FlxG.mouse.wheel);

		if (FlxG.keys.justPressed.ESCAPE)
		{
			ModCore.reload();
			FlxG.switchState(new states.MainMenuState());
		}
		else if (controls.ACCEPT)
		{
			if (!FlxG.save.data.disabledMods.contains(ModCore.trackedMods[curSelected].id))
			{
				FlxG.save.data.disabledMods.push(ModCore.trackedMods[curSelected].id);
				FlxG.save.flush();
				changeSelection();
			}
			else
			{
				FlxG.save.data.disabledMods.remove(ModCore.trackedMods[curSelected].id);
				FlxG.save.flush();
				changeSelection();
			}
		}

		super.update(elapsed);
	}

	private function changeSelection(change:Int = 0)
	{
		curSelected += change;

		if (curSelected < 0)
			curSelected = ModCore.trackedMods.length - 1;
		else if (curSelected >= ModCore.trackedMods.length)
			curSelected = 0;

		for (i in 0...iconArray.length)
		{
			iconArray[i].alpha = 0.6;
			if (FlxG.save.data.disabledMods != null && !FlxG.save.data.disabledMods.contains(ModCore.trackedMods[i].id))
				iconArray[i].alpha = 1;
		}

		var bullShit:Int = 0;
		for (i in 0...daMods.length)
		{
			daMods.members[i].targetY = bullShit - curSelected;
			bullShit++;

			daMods.members[i].alpha = 0.6;
			if (FlxG.save.data.disabledMods != null && !FlxG.save.data.disabledMods.contains(ModCore.trackedMods[i].id))
				daMods.members[i].alpha = 1;
		}

		if (ModCore.trackedMods[curSelected].description != null)
		{
			description.text = ModCore.trackedMods[curSelected].description;
			description.screenCenter(X);
		}
	}
}

class ModIcon extends FlxSprite
{
	public var sprTracker:FlxSprite;

	public function new(bytes:Bytes)
	{
		super();

		loadGraphic(BitmapData.fromBytes(bytes));
		setGraphicSize(150, 150);
		updateHitbox();
		scrollFactor.set();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y);
	}
}