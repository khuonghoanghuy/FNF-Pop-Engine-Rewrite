package states.playstate;

import flixel.FlxG;
import data.SaveData;
#if sys
import funkinLua.LuaCode;
#end
#if discord_allows
import Discord.DiscordClient;
#end

class PlayCore extends MusicBeatState
{
    override function create() {
        super.create();
        SaveData.init();
        trace("Play Core Create!");
    }

    override function update(elapsed:Float) {
        super.update(elapsed);
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