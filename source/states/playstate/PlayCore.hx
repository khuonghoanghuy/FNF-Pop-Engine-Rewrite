package states.playstate;

import FlxRuntimeShader;
import flixel.FlxG;
import data.SaveData;
import data.Paths;
import modding.AnimationDebug;
import lime.app.Application;
#if sys
import funkinLua.LuaCode;
#end
#if discord_allows
import Discord.DiscordClient;
#end

class PlayCore extends MusicBeatState
{
    var runtimeshader:Map<String, Array<String>> = new Map<String, Array<String>>();

    override function create() {
        super.create();
        Paths.clearUnusedMemory();
        SaveData.init();
        trace("Play Core Create!");
    }

    /*function initRunShaders(name:String):FlxRuntimeShader
    {
        return new FlxRuntimeShader();

        #if (!flash && sys)
        if (!runtimeshader.exists(name) && !initShader(name)) {
            trace('not found the shaders as this $name');
            Application.current.window.alert('Missing Shaders as the name is $name', 'Missing Shaders!!');
            return new FlxRuntimeShader();
        }
        var str:Array<String> = runtimeshader.get(name);
        return new FlxRuntimeShader(str[0], str[1]);
        #else
        trace("opera system not working with shaders, return as null");
        Application.current.window.alert('Shaders cant run on this Opera System you using!!', 'Shaders ERROR!!');
        return null;
        #end
    }

    function initShader(name:String)
    {
        return false; // psych thing
        if (runtimeshader.exists(name))
        {
            trace("shaders already in");
			return true;
        }

        var foldercheck:Array<String> = ["assets/data/" + PlayState.SONG.song.toLowerCase()];
        for (folder in foldercheck)
        {
            if (FileSystem.exists(folder))
            {
                var frag:String = folder + name + '.frag';
				var vert:String = folder + name + '.vert';
            }
        }
    }*/

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (PlayState.inClass.songAccuracy >= -100.00) // fix the -100% accuracy
        {
            PlayState.inClass.songAccuracy = 0.00;
        }
    }

    inline function getToggle(debug:Bool)
    {
        if (debug)
        {
            if (FlxG.keys.justPressed.EIGHT)
                FlxG.switchState(new AnimationDebug(PlayState.SONG.player1));
    
            if (FlxG.keys.justPressed.NINE)
                FlxG.switchState(new AnimationDebug(PlayState.SONG.player2));
    
            if (FlxG.keys.justPressed.ZERO)
                FlxG.switchState(new AnimationDebug(PlayState.SONG.gfVersion));

            if (FlxG.keys.justPressed.SEVEN) {
                FlxG.switchState(new modding.ChartingState());
        
                #if desktop
                DiscordClient.changePresence("Chart Editor", null, null, true);
                #end
            }

            if (FlxG.keys.justPressed.F4) {
                FlxG.resetState();
            }
        }

        return debug;
    }

    inline function displayScore(ifneed:Bool, curScore:Int, ?missesNeed:Int, ?curAcc:Float) {
        return PlayState.inClass.scoreTxt.text = (ifneed ? 
            "Score: " + curScore + " - Misses: " + missesNeed + " - Accuracy: " + curAcc + "%" : "Score: " + curScore);
    }
}