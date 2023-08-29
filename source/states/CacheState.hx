package states;

import flixel.FlxG;

class CacheState extends MusicBeatState
{
    override function create()
    {
        super.create();
        init();
        FlxG.switchState(new TitleState());
    }

    function init()
    {
        cacheFile("data");
    }

    function cacheFile(pathFolder:String)
    {
        
    }
}