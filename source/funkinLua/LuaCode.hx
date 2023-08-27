package funkinLua;

import states.playstate.PlayState;
import llua.Lua.Lua_helper;
import lime.app.Application;
import llua.*;
import Type.ValueType;

/**
 * Code from Psych Engine
 */
class LuaCode 
{
	public static var Function_Stop = 1;
	public static var Function_Continue = 0;

    public static var lua:State = null;

    public function new(script:String) {
        lua = LuaL.newstate();
        LuaL.openlibs(lua);
        Lua.init_callbacks(lua);

        var result:Dynamic = LuaL.dofile(lua, script);
        var resultString:String = Lua.tostring(lua, result);

        checkError(resultString, result);
        init(); // will load amount of code lua here!
    }

    function checkError(string:String, int:Int) {
        if (string != null && int != 0) 
        {
            Application.current.window.alert(string, "Error LUA Code!");
            lua = null;
            return;
        }
    }

    function init()
    {
        addVar("score", 0);
        addVar("misses", 0);

        addcallback("addScore", function (value:Int = 0) {
            PlayState.inClass.songScore += value;
            PlayState.inClass.getDisplayByLua();
        });

        addcallback("addMisses", function (value:Int = 0) {
            PlayState.inClass.songMisses += value;
            PlayState.inClass.getDisplayByLua(); 
        });

        // only do if u open the app with cmd app
        addcallback("doTrace", function (text:String = "cool text") {
            return trace(text);
        });
    }

    function addcallback(fname:String, f:Dynamic)
    {
        Lua_helper.add_callback(lua, fname, f);
    }

    public function addVar(vari:String, dt:Dynamic)
    {
        Convert.toLua(lua, dt);
        Lua.setglobal(lua, vari);
    }

    public function call(event:String, args:Array<Dynamic>):Dynamic {
		if(lua == null) {
			return Function_Continue;
		}

		Lua.getglobal(lua, event);

		for (arg in args) {
			Convert.toLua(lua, arg);
		}

		var result:Null<Int> = Lua.pcall(lua, args.length, 1, 0);
		if(result != null && resultIsAllowed(lua, result)) {
			if(Lua.type(lua, -1) == Lua.LUA_TSTRING) {
				var error:String = Lua.tostring(lua, -1);
				if(error == 'attempt to call a nil value') {
					return Function_Continue;
				}
			}
			var conv:Dynamic = Convert.fromLua(lua, result);
			//Lua.pop(lua, 1);
			return conv;
		}
		return Function_Continue;
	}

    function resultIsAllowed(leLua:State, leResult:Null<Int>) { //Makes it ignore warnings
		switch(Lua.type(leLua, leResult)) {
			case Lua.LUA_TNIL | Lua.LUA_TBOOLEAN | Lua.LUA_TNUMBER | Lua.LUA_TSTRING | Lua.LUA_TTABLE:
				return true;
		}
		return false;
	}
}