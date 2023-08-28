package states;

import flixel.system.FlxAssets;
import Conductor.BPMChangeEvent;
import flixel.FlxG;
import flixel.addons.ui.FlxUIState;

class MusicBeatState extends FlxUIState
{
	private var lastBeat:Float = 0;
	private var lastStep:Float = 0;
	var VERSION_POPENGINE:String = "0.1.0";

	/**
	 * Using for font was type like: vcr.ttf
	 */
	var font:String;

	/**
	 * Using for font when type the full name like: VCR OSD Mono
	 */
	var full_font:String;

	private var curStep:Int = 0;
	private var curBeat:Int = 0;
	private var controls(get, never):Controls;

	inline function get_controls():Controls
		return PlayerSettings.player1.controls;

	override function create()
	{
		super.create();

		if (FlxG.save.data.flixelDebuggerFont) {
			font = FlxAssets.FONT_DEBUGGER;
			full_font = FlxAssets.FONT_DEBUGGER;
		} else if (!FlxG.save.data.flixelDebuggerFont) {
			font = "vcr.ttf";
			full_font = "VCR OSD Mono";
		}
	}

	override function update(elapsed:Float)
	{
		//everyStep();
		var oldStep:Int = curStep;

		updateCurStep();
		updateBeat();

		FlxG.drawFramerate = FlxG.save.data.fps;
		FlxG.updateFramerate = FlxG.save.data.fps;

		if (!FlxG.save.data.fpsCounter) FlxG.stage.removeChild(Main.fpsCounter);
		else if (FlxG.save.data.fpsCounter) FlxG.stage.addChild(Main.fpsCounter);

		if (oldStep != curStep && curStep > 0)
			stepHit();

		super.update(elapsed);
	}

	private function updateBeat():Void
	{
		curBeat = Math.floor(curStep / 4);
	}

	private function updateCurStep():Void
	{
		var lastChange:BPMChangeEvent = {
			stepTime: 0,
			songTime: 0,
			bpm: 0
		}
		for (i in 0...Conductor.bpmChangeMap.length)
		{
			if (Conductor.songPosition >= Conductor.bpmChangeMap[i].songTime)
				lastChange = Conductor.bpmChangeMap[i];
		}

		curStep = lastChange.stepTime + Math.floor((Conductor.songPosition - lastChange.songTime) / Conductor.stepCrochet);
	}

	public function stepHit():Void
	{
		if (curStep % 4 == 0)
			beatHit();
	}

	public function beatHit():Void
	{
		//do literally nothing dumbass
	}
}
