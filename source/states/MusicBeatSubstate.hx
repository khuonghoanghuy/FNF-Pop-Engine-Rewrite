package states;

import flixel.system.FlxAssets;
import flixel.FlxG;
import Conductor.BPMChangeEvent;
import flixel.FlxSubState;

class MusicBeatSubstate extends FlxSubState
{
	/**
	 * Using for font was type like: vcr.ttf
	 */
	 var font:String;

	 /**
	  * Using for font when type the full name like: VCR OSD Mono
	  */
	 var full_font:String;

	public function new()
	{
		super();

		if (FlxG.save.data.flixelDebuggerFont) {
			font = FlxAssets.FONT_DEBUGGER;
			full_font = FlxAssets.FONT_DEBUGGER;
		} else {
			font = "vcr.ttf";
			full_font = "VCR OSD Mono";
		}
	}

	private var lastBeat:Float = 0;
	private var lastStep:Float = 0;

	private var curStep:Int = 0;
	private var curBeat:Int = 0;
	private var controls(get, never):Controls;

	inline function get_controls():Controls
		return PlayerSettings.player1.controls;

	override function update(elapsed:Float)
	{
		//everyStep();
		var oldStep:Int = curStep;

		updateCurStep();
		curBeat = Math.floor(curStep / 4);

		if (oldStep != curStep && curStep > 0)
			stepHit();

		FlxG.drawFramerate = FlxG.save.data.fps;
		FlxG.updateFramerate = FlxG.save.data.fps;

		super.update(elapsed);
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
			if (Conductor.songPosition > Conductor.bpmChangeMap[i].songTime)
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
