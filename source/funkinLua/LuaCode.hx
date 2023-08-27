package funkinLua;

import flixel.FlxG;
import flixel.input.keyboard.FlxKey;
import obj.Boyfriend;
import obj.Character;
import states.playstate.PlayState;
import lime.app.Application;
import llua.*;

/**
 * Code from Psych Engine
 */
class LuaCode 
{
	public static var Function_Stop = 1;
	public static var Function_Continue = 0;

    public static var lua:State = null;
    private var controls:Controls;

    public function new(script:String) {
        lua = LuaL.newstate();
        LuaL.openlibs(lua);
        Lua.init_callbacks(lua);
        trace("file " + script + " load complete!");

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
        GetLua.enter.addVar("score", 0);
        GetLua.enter.addVar("misses", 0);
        GetLua.enter.addVar("curBeat", 0);
        GetLua.enter.addVar("curStep", 0);
        GetLua.enter.addVar("curBMP", Conductor.bpm);
        GetLua.enter.addVar("isBotplay", FlxG.save.data.botplay);

        GetLua.enter.addcallback("setCAMAngle", function (typeCam:String, angle:Float) 
        {
            switch (typeCam)
            {
                case "game":
                    PlayState.inClass.camGame.angle = angle;
                case "hud":
                    PlayState.inClass.camHUD.angle = angle;
            }
        });

        GetLua.enter.addcallback("setCAMShake", function (typeCam:String, shake:Float, time:Float) 
        {
            switch (typeCam)
            {
                case "game":
                    PlayState.inClass.camGame.shake(shake, time);
                case "hud":
                    PlayState.inClass.camHUD.shake(shake, time);
            }
        });

        GetLua.enter.addcallback("addCAMAngle", function (typeCam:String, angle:Float) 
        {
            switch (typeCam)
            {
                case "game":
                    PlayState.inClass.camGame.angle += angle;
                case "hud":
                    PlayState.inClass.camHUD.angle += angle;
            }
        });

        GetLua.enter.addcallback("addMountInt", function (type:String, mount:Int) 
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

        GetLua.enter.addcallback("setMountInt", function (type:String, mount:Int) 
        {
            switch (type)
            {
                case "score":
                    PlayState.inClass.songScore = mount;
                case "misses":
                    PlayState.inClass.songMisses = mount;
            }

            PlayState.inClass.getDisplayByLua();
        });

        GetLua.enter.addcallback("changeCharacter", function (type:String, x:Float, y:Float, name:String, isPlayer:Bool) 
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

        GetLua.enter.addcallback("keyPress", function (keyname:String) 
        {
            switch (keyname)
            {
                case "left": controls.LEFT_P;
                case "down": controls.DOWN_P;
                case "up": controls.UP_P;
                case "right": controls.RIGHT_P;
                case "enter": controls.ACCEPT;
                case "esc": controls.BACK;
                case "doCheatBro": controls.CHEAT;
                case "reset": controls.RESET;
                case "pause": controls.PAUSE;
            }
        });

        GetLua.enter.addcallback("keyRelease", function (keyname:String) 
        {
            switch (keyname)
            {
                case "left": controls.LEFT_R;
                case "down": controls.DOWN_R;
                case "up": controls.UP_R;
                case "right": controls.RIGHT_R;
                case "enter": controls.ACCEPT;
                case "esc": controls.BACK;
                case "doCheatBro": controls.CHEAT;
                case "reset": controls.RESET;
                case "pause": controls.PAUSE;
            }
        });

        GetLua.enter.addcallback("changeWindowTitle", function (newTitle:String)
        {
            return Application.current.window.title = newTitle;
        });

        GetLua.enter.addcallback("changeFPS", function (newfps:Int)
        {
            return Application.current.window.frameRate = newfps;
        });

        GetLua.enter.addcallback("playAlert", function (text:String, title:String) 
        {
            return Application.current.window.alert(text, title);
        });

        // only do if u open the app with cmd app
        GetLua.enter.addcallback("doTrace", function (text:String = "cool text") 
        {
            trace(text);
        });
    }

    public function call(event:String, args:Array<Dynamic>):Dynamic
    {
        return GetLua.enter.call(event, args);
    }

    public function addVar(vari:String, dt:Dynamic)
    {
        return GetLua.enter.addVar(vari, dt);
    }
}