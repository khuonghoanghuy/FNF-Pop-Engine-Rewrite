package modding;

import flixel.group.FlxGroup.FlxTypedGroup;
import states.MusicBeatState;

class EditorsState extends MusicBeatState
{
    var menuItem:Array<String> = ["Charaters", "Week", "Characters Week", "Dialogue", "Dialogue Face", "Menu"];
    var curSelection:Int = 0;
    var group:FlxTypedGroup<Alphabet>;

    override function create()
    {
        super.create();
        group = new FlxTypedGroup<Alphabet>();
        add(group);
    }

    override function update(elapsed:Float) 
    {
        super.update(elapsed);
    }
}