package states;

import flixel.FlxG;

// in build
// would like if u help to make this cache work
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