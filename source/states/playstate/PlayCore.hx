package states.playstate;

import flixel.FlxG;
import flixel.ui.FlxBar;
import flixel.FlxSprite;
#if discord_allows
import Discord.DiscordClient;
#end

class PlayCore extends MusicBeatState
{
    override function create() {
        super.create();
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

		if (FlxG.keys.justPressed.SEVEN) {
			FlxG.switchState(new ChartingState());
	
			#if desktop
			DiscordClient.changePresence("Chart Editor", null, null, true);
			#end
		}

        if (FlxG.keys.justPressed.EIGHT)
			FlxG.switchState(new AnimationDebug(PlayState.SONG.player2));
    }

    inline public static function displayScore(ifneed:Bool, curScore:Int, ?missesNeed:Int, ?curAcc:Float, ?getRank:String, ?fcRank:String) {
        return PlayState.inClass.scoreTxt.text = (ifneed ? 
            "Score: " + curScore + " - Misses: " + missesNeed + " - Accuracy: " + curAcc + "% - Rank: " + getRank + " (" + fcRank + ")"
            : "Score: " + curScore);
    }
}