package funkinLua;

import states.playstate.PlayState;
import flixel.FlxSprite;
import lime.app.Application;
import llua.Convert;
import llua.Lua;
import llua.State;
import llua.LuaL;
import flixel.FlxG;
import obj.*;
#if sys
import openfl.geom.Matrix;
import flixel.util.FlxColor;
import openfl.display.BitmapData;
#end

using StringTools;

/**
 * From Kade Engine cuz code lua from kade engine is so cool!
 */
class LuaCode
{
    public static var lua:State = null;
    static var result:Any = null;
    static var sprites:Map<String, FlxSprite> = [];

    public function new() {
        lua = LuaL.newstate();
        LuaL.openlibs(lua);
        Lua.init_callbacks(lua);
        // var stuff
        setVar("curStep", 0);
        setVar("curBeat", 0);
        setVar("screenWidth", FlxG.width);
        setVar("screenHeight", FlxG.height);
        setVar("windowWidth", FlxG.width);
        setVar("windowHeight", FlxG.height);

        result = LuaL.dofile(lua, Paths.lua(PlayState.SONG.song.toLowerCase() + "/lua"));

        // obj stuff
        Lua_helper.add_callback(lua, "changeChar", function(fromDad:Bool, x:Float, y:Float, id:String) {
            if (fromDad)
            {
                PlayState.inClass.dad.x = x;
                PlayState.inClass.dad.y = y;
                PlayState.inClass.removeObject(PlayState.inClass.dad);
                PlayState.inClass.dad = new Character(x, y, id);
                PlayState.inClass.addObject(PlayState.inClass.dad);
                PlayState.inClass.iconP2.animation.play(id);
            }
            else
            {
                PlayState.inClass.boyfriend.x = x;
                PlayState.inClass.boyfriend.y = y;
                PlayState.inClass.removeObject(PlayState.inClass.boyfriend);
                PlayState.inClass.boyfriend = new Boyfriend(x, y, id);
                PlayState.inClass.addObject(PlayState.inClass.boyfriend);
                PlayState.inClass.iconP1.animation.play(id);
            }
        });

        // gameplay stuff
        Lua_helper.add_callback(lua, "makeSprite", makeLuaSprite);
        Lua_helper.add_callback(lua,"destroySprite", destroySprite);

        Lua_helper.add_callback(lua, "setHealth", function(float:Float){
            PlayState.inClass.health = float;
        });

        Lua_helper.add_callback(lua, "addHealth", function(float:Float){
            PlayState.inClass.health += float;
        });

        Lua_helper.add_callback(lua, "setScore", function(int:Int){
            PlayState.inClass.songScore = int;
            PlayState.inClass.getDisplayByLua();
        });

        Lua_helper.add_callback(lua, "addScore", function(int:Int){
            PlayState.inClass.songScore += int;
            PlayState.inClass.getDisplayByLua();
        });

        Lua_helper.add_callback(lua, "setMiss", function(int:Int){
            PlayState.inClass.songMisses = int;
            PlayState.inClass.getDisplayByLua();
        });

        Lua_helper.add_callback(lua, "addMiss", function(int:Int){
            PlayState.inClass.songMisses += int;
            PlayState.inClass.getDisplayByLua();
        });

        // other stuff
        Lua_helper.add_callback(lua, "trace", function(string:String){
            trace(string);
        });
        // lime stuff
        Lua_helper.add_callback(lua, "changeTitle", function(string:String){
            return Application.current.window.title = string;
        });

        Lua_helper.add_callback(lua, "addWarm", function(string:String, title:String){
            return Application.current.window.alert(string, title);
        });

        Lua_helper.add_callback(lua, "changeframe", function(fps:Int){
            Application.current.window.frameRate = fps;
        });
    }

    inline public static function getLua(name:String, arg:Array<Dynamic>, ?type:String):Dynamic {
        result = Lua.pcall(lua, arg.length, 1, 0);

        for (arg in arg) {
            Convert.toLua(lua, arg);
        }

        if (result == null) {
            return null;
        } else {
            return convert(result, type);
        }
    }

    public function setVar(var_name:String, obj:Dynamic) {
        Lua.pushnumber(lua, obj);
		Lua.setglobal(lua, var_name);
    }

    inline public function getVar(var_name:String, type:String):Dynamic {
		Lua.getglobal(lua, var_name);
		result = Convert.fromLua(lua, -1);
		Lua.pop(lua,1);

		if(result == null) {
		    return null;
		} else {
		    var result = convert(result, type);
		    return result;
		}
	}

    inline public static function characters(char:String):Dynamic {
        switch (char)
        {
            case "boyfriend":
                return PlayState.inClass.boyfriend;

            case "gf":
                return PlayState.inClass.gf;

            case "dad":
                return PlayState.inClass.dad;
        }

        if (sprites.get(char) == null)
			return PlayState.inClass.strumLineNotes.members[Std.parseInt(char)];
		return sprites.get(char);
    }

	inline public static function convert(v:Any, type:String):Dynamic {
		if(Std.is(v, String) && type != null ) {
		    var v:String = v;
		if(type.substr(0, 4) == 'array') {
			if(type.substr(4) == 'float') {
			    var array:Array<String> = v.split(',');
			    var array2:Array<Float> = new Array();

			    for(vars in array) {
			    	array2.push(Std.parseFloat(vars));
			    }

			    return array2;
			} else if(type.substr(4) == 'int') {
			    var array:Array<String> = v.split(',');
			    var array2:Array<Int> = new Array();

			    for( vars in array ) {
			    	array2.push(Std.parseInt(vars));
			    }

			    return array2;
			} else {
			    var array:Array<String> = v.split(',');
			    return array;
			}
		} else if(type == 'float') {
			return Std.parseFloat(v);
		} else if(type == 'int') {
			return Std.parseInt(v);
		} else if(type == 'bool') {
			if(v == 'true') {
			    return true;
			} else {
			    return false;
			}
		} else {
			return v;
		}
		} else {
		    return v;
		}
	}

	inline public static function makeLuaSprite(spritePath:String, toBeCalled:String, drawBehind:Bool)
    {
        #if sys
        var data:BitmapData = BitmapData.fromFile(Sys.getCwd() + "assets/data/" + PlayState.SONG.song.toLowerCase() + '/' + spritePath + ".png");

        var sprite:FlxSprite = new FlxSprite(0,0);
        var imgWidth:Float = FlxG.width / data.width;
        var imgHeight:Float = FlxG.height / data.height;
        var scale:Float = imgWidth <= imgHeight ? imgWidth : imgHeight;

        if (scale > 1)
        {
            scale = 1;
        }

        sprite.makeGraphic(Std.int(data.width * scale),Std.int(data.width * scale),FlxColor.TRANSPARENT);

        var data2:BitmapData = sprite.pixels.clone();
        var matrix:Matrix = new Matrix();
        matrix.identity();
        matrix.scale(scale, scale);
        data2.fillRect(data2.rect, FlxColor.TRANSPARENT);
        data2.draw(data, matrix, null, null, null, true);
        sprite.pixels = data2;
        
        sprites.set(toBeCalled, sprite);
        
        if (drawBehind)
        {
            PlayState.inClass.removeObject(PlayState.inClass.gf);
            PlayState.inClass.removeObject(PlayState.inClass.boyfriend);
            PlayState.inClass.removeObject(PlayState.inClass.dad);
        }

        PlayState.inClass.addObject(sprite);

        if (drawBehind)
        {
            PlayState.inClass.addObject(PlayState.inClass.gf);
            PlayState.inClass.addObject(PlayState.inClass.boyfriend);
            PlayState.inClass.addObject(PlayState.inClass.dad);
        }
        #end

        return toBeCalled;
    }

    inline public static function destroySprite(id:String)
    {
        var sprite = sprites.get(id);
        if (sprite == null)
            return false;
        PlayState.inClass.removeObject(sprite);
        return true;
    }

    inline public static function getType(l, type):Any
    {
        return switch Lua.type(l, type) {
            case t if (t == Lua.LUA_TNIL): null;
            case t if (t == Lua.LUA_TNUMBER): Lua.tonumber(l, type);
            case t if (t == Lua.LUA_TSTRING): (Lua.tostring(l, type):String);
            case t if (t == Lua.LUA_TBOOLEAN): Lua.toboolean(l, type);
            case t: throw 'lua error ($t)';
        }
    }

    inline public static function getReturnValues(l) {
		var lua_v:Int;
		var v:Any = null;
		while((lua_v = Lua.gettop(l)) != 0) {
			var type:String = getType(l,lua_v);
			v = convert(lua_v, type);
			Lua.pop(l, 1);
		}
		return v;
	}

    // for create
    public function startInit()
    {

    }

    public function executeState(name:String, args:Array<Dynamic>)
    {
        return Lua.tostring(lua, getLua(name, args));
    }

    public static function create():LuaCode
    {
        return new LuaCode();
    }
}