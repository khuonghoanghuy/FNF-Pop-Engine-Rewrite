package modding;

import states.playstate.PlayState;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import obj.*;
import openfl.events.IOErrorEvent;
import openfl.events.Event;
import openfl.net.FileReference;
import flixel.addons.ui.FlxUITabMenu;
import flixel.FlxCamera;
import flixel.graphics.frames.FlxAtlasFrames;

using StringTools;

/**
	*DEBUG MODE
 */
class AnimationDebug extends FlxState
{
	var _file:FileReference;
	var bf:Boyfriend;
	var dad:Character;
	var char:Character;
	var textAnim:FlxText;
	var dumbTexts:FlxTypedGroup<FlxText>;
	var animList:Array<String> = [];
	var curAnim:Int = 0;
	var isDad:Bool = true;
	var daAnim:String = 'spooky';
	var camFollow:FlxObject;

	// ui box thing
	var camHUD:FlxCamera;
	var UI_box:FlxUITabMenu;

	var previewMode:Bool = false; // if u wanna test ur characters, just using this
	var previewText:FlxText;
	var strumLine:FlxTypedGroup<FlxSprite>;
	var missisAnim:Bool = false;

	public function new(daAnim:String = 'spooky')
	{
		super();
		this.daAnim = daAnim;
	}

	override function create()
	{
		FlxG.sound.music.stop();

		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;
		FlxG.cameras.add(camHUD, false);

		var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stageback'));
		bg.antialiasing = true;
		bg.scrollFactor.set(0.9, 0.9);
		bg.active = false;
		add(bg);

		if (daAnim == 'bf')
			isDad = false;

		if (isDad)
		{
			dad = new Character(0, 0, daAnim);
			dad.screenCenter();
			dad.debugMode = true;
			add(dad);

			char = dad;
			dad.flipX = false;
		}
		else
		{
			bf = new Boyfriend(0, 0);
			bf.screenCenter();
			bf.debugMode = true;
			add(bf);

			char = bf;
			bf.flipX = false;
		}

		dumbTexts = new FlxTypedGroup<FlxText>();
		add(dumbTexts);

		textAnim = new FlxText(300, 16);
		textAnim.size = 26;
		textAnim.scrollFactor.set();
		textAnim.cameras = [camHUD];
		add(textAnim);

		genBoyOffsets();

		camFollow = new FlxObject(0, 0, 2, 2);
		camFollow.screenCenter();
		add(camFollow);

		FlxG.camera.follow(camFollow);

		var tabs = [
			{name: "Data Character", label: 'Data Character'},
			{name: "Info", label: 'Info'}
		];

		UI_box = new FlxUITabMenu(null, tabs, true);
		UI_box.resize(300, 400);
		UI_box.x = FlxG.width / 1;
		UI_box.y = 20;
		UI_box.cameras = [camHUD];
		add(UI_box);

		addDataCharacterUI();
		addInfoUI();

		strumLine = new FlxTypedGroup<FlxSprite>();
		add(strumLine);

		previewText = new FlxText(0, 0, 0, "");
		previewText.size = 26;
		previewText.x = textAnim.x;
		previewText.x = textAnim.y - 16;
		previewText.scrollFactor.set();
		previewText.cameras = [camHUD];
		add(previewText);

		generateStaticArrows();

		super.create();
	}

	function generateStaticArrows():Void
	{
		for (i in 0...4)
		{
			var tex:FlxAtlasFrames;
			tex = Paths.getSparrowAtlas('arrows/NOTE_assets');
			var babyArrow:FlxSprite = new FlxSprite(textAnim.x, 0);
			babyArrow.frames = tex;
			babyArrow.animation.addByPrefix('green', 'arrowUP');
			babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
			babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
			babyArrow.animation.addByPrefix('red', 'arrowRIGHT');

			babyArrow.antialiasing = true;
			babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));

			switch (Math.abs(i))
			{
				case 0:
					babyArrow.x += Note.swagWidth * 0;
					babyArrow.animation.addByPrefix('static', 'arrowLEFT');
					babyArrow.animation.addByPrefix('lpressed', 'left press', 24, false);
					babyArrow.animation.addByPrefix('lconfirm', 'left confirm', 24, false);
				case 1:
					babyArrow.x += Note.swagWidth * 1;
					babyArrow.animation.addByPrefix('static', 'arrowDOWN');
					babyArrow.animation.addByPrefix('dpressed', 'down press', 24, false);
					babyArrow.animation.addByPrefix('dconfirm', 'down confirm', 24, false);
				case 2:
					babyArrow.x += Note.swagWidth * 2;
					babyArrow.animation.addByPrefix('static', 'arrowUP');
					babyArrow.animation.addByPrefix('upressed', 'up press', 24, false);
					babyArrow.animation.addByPrefix('uconfirm', 'up confirm', 24, false);
				case 3:
					babyArrow.x += Note.swagWidth * 3;
					babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
					babyArrow.animation.addByPrefix('rpressed', 'right press', 24, false);
					babyArrow.animation.addByPrefix('rconfirm', 'right confirm', 24, false);
			}
			babyArrow.updateHitbox();
			babyArrow.scrollFactor.set();
			babyArrow.ID = i;
	
			babyArrow.animation.play('static');
			babyArrow.x += 50;
			babyArrow.x += ((FlxG.width / 3.5));
			babyArrow.y -= 10;
			babyArrow.cameras = [camHUD];
			strumLine.add(babyArrow);
		}
	}

	function addDataCharacterUI():Void
	{

	}

	function addInfoUI():Void
	{
		
	}

	function genBoyOffsets(pushList:Bool = true):Void
	{
		var daLoop:Int = 0;

		for (anim => offsets in char.animOffsets)
		{
			var text:FlxText = new FlxText(10, 20 + (18 * daLoop), 0, anim + ": " + offsets, 15);
			text.scrollFactor.set();
			text.color = FlxColor.WHITE;
			text.cameras = [camHUD];
			dumbTexts.add(text);

			if (pushList)
				animList.push(anim);

			daLoop++;
		}
	}

	function updateTexts():Void
	{
		dumbTexts.forEach(function(text:FlxText)
		{
			text.kill();
			dumbTexts.remove(text, true);
		});
	}

	override function update(elapsed:Float)
	{
		textAnim.text = char.animation.curAnim.name;

		strumLine.forEach(function(sprite:FlxSprite)
		{
			if (previewMode) {
				sprite.visible = true;
			} else if (!previewMode) {
				sprite.visible = false;
			}
		});

		if (FlxG.keys.justPressed.E)
			FlxG.camera.zoom += 0.25;
		if (FlxG.keys.justPressed.Q)
			FlxG.camera.zoom -= 0.25;

		if (FlxG.keys.pressed.I || FlxG.keys.pressed.J || FlxG.keys.pressed.K || FlxG.keys.pressed.L)
		{
			if (FlxG.keys.pressed.I)
				camFollow.velocity.y = -90;
			else if (FlxG.keys.pressed.K)
				camFollow.velocity.y = 90;
			else
				camFollow.velocity.y = 0;

			if (FlxG.keys.pressed.J)
				camFollow.velocity.x = -90;
			else if (FlxG.keys.pressed.L)
				camFollow.velocity.x = 90;
			else
				camFollow.velocity.x = 0;
		}
		else
		{
			camFollow.velocity.set();
		}

		if (!previewMode)
		{
			if (FlxG.keys.justPressed.W)
			{
				curAnim -= 1;
			}

			if (FlxG.keys.justPressed.S)
			{
				curAnim += 1;
			}
		}

		if (curAnim < 0)
			curAnim = animList.length - 1;

		if (curAnim >= animList.length)
			curAnim = 0;

		if (!previewMode)
		{
			if (FlxG.keys.justPressed.S || FlxG.keys.justPressed.W || FlxG.keys.justPressed.SPACE)
			{
				char.playAnim(animList[curAnim]);

				updateTexts();
				genBoyOffsets(false);
			}
		}

		var upP = FlxG.keys.anyJustPressed([UP]);
		var rightP = FlxG.keys.anyJustPressed([RIGHT]);
		var downP = FlxG.keys.anyJustPressed([DOWN]);
		var leftP = FlxG.keys.anyJustPressed([LEFT]);

		var holdShift = FlxG.keys.pressed.SHIFT;
		var multiplier = 1;
		if (holdShift)
			multiplier = 10;

		if (!previewMode)
		{
			if (upP || rightP || downP || leftP)
			{
				updateTexts();
				if (upP)
					char.animOffsets.get(animList[curAnim])[1] += 1 * multiplier;
				if (downP)
					char.animOffsets.get(animList[curAnim])[1] -= 1 * multiplier;
				if (leftP)
					char.animOffsets.get(animList[curAnim])[0] += 1 * multiplier;
				if (rightP)
					char.animOffsets.get(animList[curAnim])[0] -= 1 * multiplier;

				updateTexts();
				genBoyOffsets(false);
				char.playAnim(animList[curAnim]);
			}

			if (FlxG.keys.justPressed.R) {
				saveOffsets();
			}
		}	

		if (FlxG.keys.justPressed.ESCAPE) {
			FlxG.switchState(new PlayState());
		}

		// toggle preview mode
		if (FlxG.keys.justPressed.P && !previewMode) {
			previewMode = true;
			previewText.text = "PREVIEW MODE";
			char.playAnim("idle");
		} else if (FlxG.keys.justPressed.P && previewMode) {
			previewMode = false;
			previewText.text = "";
			char.playAnim("idle");
		}

		if (previewMode)
		{
			if (FlxG.keys.anyJustPressed([UP, W]))
			{
				strumLine.forEach(function(anim:FlxSprite)
				{
					if (missisAnim)
					{
						anim.animation.play("upressed");
					}
					else if (!missisAnim)
					{
						anim.animation.play("uconfirm");
					}
				});
				char.playAnim("singUP", true);
			}
			if (FlxG.keys.anyJustPressed([DOWN, S]))
			{
				strumLine.forEach(function(anim:FlxSprite)
				{
					if (missisAnim)
					{
						anim.animation.play("dpressed");
					}
					else if (!missisAnim)
					{
						anim.animation.play("dconfirm");
					}
				});
				char.playAnim("singDOWN", true);
			}
			if (FlxG.keys.anyJustPressed([LEFT, A]))
			{
				strumLine.forEach(function(anim:FlxSprite)
				{
					if (missisAnim)
					{
						anim.animation.play("lpressed");
					}
					else if (!missisAnim)
					{
						anim.animation.play("lconfirm");
					}
				});
				char.playAnim("singLEFT", true);
			}
			if (FlxG.keys.anyJustPressed([RIGHT, D]))
			{
				strumLine.forEach(function(anim:FlxSprite)
				{
					if (missisAnim)
					{
						anim.animation.play("rpressed");
					}
					else if (!missisAnim)
					{
						anim.animation.play("rconfirm");
					}
				});
				char.playAnim("singRIGHT", true);
			}
		}

		super.update(elapsed);
	}

	function saveOffsets()
	{
		var offsetsText:String = "";
	
		for (anim => offsets in char.animOffsets)
		{
			offsetsText += anim + " " + offsets[0] + " " + offsets[1] + "\n";
		}
	
		if ((offsetsText != "") && (offsetsText.length > 0))
		{
			if (offsetsText.endsWith("\n"))
				offsetsText = offsetsText.substr(0, offsetsText.length - 1);
	
			_file = new FileReference();
			_file.addEventListener(Event.COMPLETE, onSaveComplete);
			_file.addEventListener(Event.CANCEL, onSaveCancel);
			_file.addEventListener(IOErrorEvent.IO_ERROR, onSaveError);
	
			_file.save(offsetsText, "offsets.txt");
		}
	}

	function onSaveComplete(_):Void {
		_file.removeEventListener(Event.COMPLETE, onSaveComplete);
		_file.removeEventListener(Event.CANCEL, onSaveCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
		_file = null;
		FlxG.log.notice("Successfully saved OFFSETS FILE.");
	}

	/**
	 * Called when the save file dialog is cancelled.
	 */
	function onSaveCancel(_):Void {
		_file.removeEventListener(Event.COMPLETE, onSaveComplete);
		_file.removeEventListener(Event.CANCEL, onSaveCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
		_file = null;
	}

	/**
	 * Called if there is an error while saving the gameplay recording.
	 */
	function onSaveError(_):Void {
		_file.removeEventListener(Event.COMPLETE, onSaveComplete);
		_file.removeEventListener(Event.CANCEL, onSaveCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
		_file = null;
		FlxG.log.error("Problem saving offsets file");
	}
}
