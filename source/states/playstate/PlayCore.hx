package states.playstate;

class PlayCore
{
    public static function displayScore(ifneed:Bool, curScore:Int, ?missesNeed:Int, ?curAcc:Float, ?getRank:String, ?fcRank:String) {
        return PlayState.inClass.scoreTxt.text = (ifneed ? 
            "Score: " + curScore + " - Misses: " + missesNeed + " - Accuracy: " + curAcc + "% - Rank: " + getRank + " (" + fcRank + ")"
            : "Score: " + curScore);
    }
}