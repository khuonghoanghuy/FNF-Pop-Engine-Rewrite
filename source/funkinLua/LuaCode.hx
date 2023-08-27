package funkinLua;

import obj.Boyfriend;
import obj.Character;
import states.MusicBeatState;
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
        trace("file " + script + ".lua complete!");

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
        addVar("curBeat", 0);
        addVar("curStep", 0);

        /*addcallback("addScore", function (value:Int = 0) {
            PlayState.inClass.songScore += value;
            PlayState.inClass.getDisplayByLua();
        });

        addcallback("addMisses", function (value:Int = 0) {
            PlayState.inClass.songMisses += value;
            PlayState.inClass.getDisplayByLua(); 
        });*/

        addcallback("addMountInt", function (type:String, mount:Int) 
        {
            switch (type)
            {
                case "score":
                    PlayState.inClass.songScore += mount;

                case "misses":
                    PlayState.inClass.songMisses += mount;
            }

            PlayState.inClass.getDisplayByLua();
        });

        addcallback("changeCharacter", function (type:String, x:Float, y:Float, name:String, isPlayer:Bool) 
        {
            switch (type)
            {
                case "dad":
                    PlayState.inClass.removeObject(PlayState.inClass.dad);
                    PlayState.inClass.dad = new Character(x, y, name, isPlayer);
                    PlayState.inClass.iconP2.animation.play(name);
                    PlayState.inClass.addObject(PlayState.inClass.dad);

                case "bf":
                    PlayState.inClass.removeObject(PlayState.inClass.boyfriend);
                    PlayState.inClass.boyfriend = new Boyfriend(x, y, name);
                    PlayState.inClass.iconP1.animation.play(name);
                    PlayState.inClass.addObject(PlayState.inClass.boyfriend);

                case "gf":
                    PlayState.inClass.removeObject(PlayState.inClass.gf);
                    PlayState.inClass.gf = new Character(x, y, name);
                    PlayState.inClass.addObject(PlayState.inClass.gf);
            }
        });

        // only do if u open the app with cmd app
        addcallback("doTrace", function (text:String = "cool text") {
            trace(text);
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