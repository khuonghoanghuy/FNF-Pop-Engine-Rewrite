package funkinLua;

import llua.Lua.Lua_helper;
import llua.*;

class GetLua
{
    public static var enter:GetLua;

    public function new() {
        enter = this;
    }    

    public function addcallback(fname:String, f:Dynamic)
    {
        Lua_helper.add_callback(LuaCode.lua, fname, f);
    }
    
    public function addVar(vari:String, dt:Dynamic)
    {
        Convert.toLua(LuaCode.lua, dt);
        Lua.setglobal(LuaCode.lua, vari);
    }
    
    public function call(event:String, args:Array<Dynamic>):Dynamic {
        if(LuaCode.lua == null) {
            return LuaCode.Function_Continue;
        }

        Lua.getglobal(LuaCode.lua, event);

        for (arg in args) {
            Convert.toLua(LuaCode.lua, arg);
        }

        var result:Null<Int> = Lua.pcall(LuaCode.lua, args.length, 1, 0);
        if(result != null && resultIsAllowed(LuaCode.lua, result)) {
            if(Lua.type(LuaCode.lua, -1) == Lua.LUA_TSTRING) {
                var error:String = Lua.tostring(LuaCode.lua, -1);
                if(error == 'attempt to call a nil value') {
                    return LuaCode.Function_Continue;
                }
            }
            var conv:Dynamic = Convert.fromLua(LuaCode.lua, result);
            //Lua.pop(lua, 1);
            return conv;
        }
        return LuaCode.Function_Continue;
    }
    
    public function resultIsAllowed(leLua:State, leResult:Null<Int>) { //Makes it ignore warnings
        switch(Lua.type(leLua, leResult)) {
            case Lua.LUA_TNIL | Lua.LUA_TBOOLEAN | Lua.LUA_TNUMBER | Lua.LUA_TSTRING | Lua.LUA_TTABLE:
                return true;
        }
        return false;
    }
}