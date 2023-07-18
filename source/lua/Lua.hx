package lua;

import llua.Lua;
import llua.LuaL;
import llua.State;

// some code from psych engine
class Lua
{
    public function new()
    {
        super();

        var lua:State = new LuaL.newstate();
    }
}