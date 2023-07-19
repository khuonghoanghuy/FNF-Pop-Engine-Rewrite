package lua;

import llua.Lua;
import llua.LuaL;
import llua.State;
import llua.Convert;
import Type.ValueType;
import Controls;

import flixel.FlxG;

#if sys
import sys.FileSystem;
import sys.io.File;
#end

using StringTools;

// some code from psych engine
class Lua
{
    var lua:State = null;

    public function new(file:String)
    {
        super();
        lua = LuaL.newState();
        LuaL.openlibs(file);
        Lua.init_callbacks(lua);

        // Lua_Helper.add_callback(lua, "changeCharacters", )
    }
}