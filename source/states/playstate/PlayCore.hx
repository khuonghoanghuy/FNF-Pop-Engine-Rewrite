package states.playstate;

import flixel.FlxG;
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
        trace("Play Core Create!");
    }

    override function update(elapsed:Float) {
        super.update(elapsed);
    }

    inline public static function getToggle(debug:Bool)
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
        }

        return debug;
    }

    inline public static function displayScore(ifneed:Bool, curScore:Int, ?missesNeed:Int, ?curAcc:Float, ?getRank:String, ?fcRank:String) {
        return PlayState.inClass.scoreTxt.text = (ifneed ? 
            "Score: " + curScore + " - Misses: " + missesNeed + " - Accuracy: " + curAcc + "% - Rank: " + getRank + " (" + fcRank + ")"
            : "Score: " + curScore);
    }
}