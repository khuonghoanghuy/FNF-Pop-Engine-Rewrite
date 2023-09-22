package modding;

import flixel.sound.FlxSound;
import flixel.text.FlxText;
import openfl.net.FileReference;
import Song.SwagSong;
import Section.SwagSection;
import states.MusicBeatState;
import flixel.FlxG;
import states.playstate.*;
import flixel.addons.ui.*;
import flixel.addons.display.*;
import flixel.tweens.*;
import flixel.group.FlxGroup.FlxTypedGroup;
import obj.*;
import haxe.Json;
import flixel.FlxSprite;

using StringTools;

class ChartingState extends MusicBeatState
{
    var _song:SwagSong;
    var _file:FileReference;
    var textInfo:FlxText;
    var UI_box:FlxUITabMenu;
    var bg:FlxBackdrop;
    var GRID_SIZE:Int = 40;
	var dummyArrow:FlxSprite;
	var curRenderedNotes:FlxTypedGroup<Note>;
	var curRenderedSustains:FlxTypedGroup<FlxSprite>;
    var vocals:FlxSound;
    var strumLine:FlxSprite;

    override function create()
    {
        super.create();
        FlxG.mouse.visible = true;

        bg = new FlxBackdrop(FlxGridOverlay.createGrid(30, 30, 60, 60, true, 0x3B161932, 0x0), XY);
        bg.velocity.set(FlxG.random.bool(50) ? 90 : -90, FlxG.random.bool(50) ? 90 : -90);
        bg.alpha = 0;
		FlxTween.tween(bg, {alpha: 1}, 0.5, {ease: FlxEase.quadOut});
        add(bg);

        curRenderedNotes = new FlxTypedGroup<Note>();
		curRenderedSustains = new FlxTypedGroup<FlxSprite>();

        if (PlayState.SONG != null)
			_song = PlayState.SONG;
		else
		{
			_song = {
				song: 'Tutorial',
				notes: [],
				bpm: 100,
				needsVoices: true,
				player1: 'bf',
				player2: 'dad',
                gfVersion: 'gf',
                stages: 'stage',
				speed: 1,
				validScore: false
			};
		}

        loadSong(_song.song);
        Conductor.changeBPM(_song.bpm);
		Conductor.mapBPMChanges(_song);

        var tabs = [
			{name: "Song", label: 'Song'},
			{name: "Section", label: 'Section'},
			{name: "Note", label: 'Note'}
		];

        strumLine = new FlxSprite(0, 50).makeGraphic(Std.int(FlxG.width / 2), 4);
		add(strumLine);

        addSongUI();

        UI_box = new FlxUITabMenu(null, tabs, true);
		UI_box.resize(300, 800);
		UI_box.x = FlxG.width / 6;
		UI_box.y = 20;
		add(UI_box);

        add(curRenderedNotes);
		add(curRenderedSustains);

        textInfo = new FlxText(20, 20, 0, "", 16);
        textInfo.scrollFactor.set();
        textInfo.font = Paths.font("vcr.ttf");
        add(textInfo);
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);
        textInfo.text = "Current Beat: " + curBeat
         + "\nCurrent Step: " + curStep
         + "\nCurrent Speed: " + _song.speed;

        if (controls.BACK) {
            FlxG.mouse.visible = false;
            FlxG.switchState(new states.playstate.PlayState());
        }
    }

    function loadSong(daSong:String):Void
    {
		if (FlxG.sound.music != null)
        {
            FlxG.sound.music.stop();
            // vocals.stop();
        }

        FlxG.sound.playMusic(Paths.inst(daSong), 0.6);

        // WONT WORK FOR TUTORIAL OR TEST SONG!!! REDO LATER
        vocals = new FlxSound().loadEmbedded(Paths.voices(daSong));
        FlxG.sound.list.add(vocals);
        FlxG.sound.music.pause();
        vocals.pause();

        FlxG.sound.music.onComplete = function()
        {
            vocals.pause();
            vocals.time = 0;
            FlxG.sound.music.pause();
            FlxG.sound.music.time = 0;
            // changeSection();
        };
    }

    // add some ui
    function addSongUI()
    {

    }
}