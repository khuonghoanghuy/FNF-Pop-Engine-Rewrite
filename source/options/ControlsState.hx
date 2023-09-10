package options;

import states.playstate.PlayState;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxSprite;

class ControlsState extends MusicBeatState
{
    var init:Int = 0; // 7 will max
    var inChange:Bool = false; // main code about key changing system
    var textCenter:FlxText;
    var warmText:FlxText;

    override function create()
    {
        super.create();

        /*var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0;
		bg.scrollFactor.set();
		add(bg);*/

        var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		menuBG.color = 0xFFea71fd;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);

        var versionShit:FlxText = new FlxText(10, FlxG.height - 44, 0, "Press LEFT/RIGHT to Change Key\nPress Escape to Exit with Save Control", 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat(full_font, 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

        textCenter = new FlxText(0, 0, 0, "", 64);
        textCenter.scrollFactor.set();
        textCenter.screenCenter(Y);
        textCenter.x += 100;
        textCenter.setFormat(full_font, 64, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        add(textCenter);

        warmText = new FlxText(0, FlxG.height * 0.9 + 18, FlxG.width, "", 32);
        warmText.scrollFactor.set();
        // warmText.screenCenter();
        warmText.setFormat(full_font, 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        add(warmText);
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if (FlxG.keys.justPressed.ESCAPE && !inChange)
        {
            FlxG.save.flush();
            FlxG.switchState(new OptionsMenu());
        }

        if (FlxG.keys.justPressed.ENTER)
        {
            FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
            inChange = true;
            warmText.text = "PRESS ANY KEY TO CHANGE";
        }

        if (FlxG.keys.anyJustPressed([LEFT, A]) && !inChange) {
            FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
            if (init == 0) {
                init = 11;
            }else{
                init--;
            }
        }

        if (FlxG.keys.anyJustPressed([RIGHT, D]) && !inChange) {
            FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
            if (init == 11) {
                init = 0;
            }else{
                init++;
            }
        }

        switch (init) 
        {
            case 0:
                textCenter.text = "LEFT KEY: " + FlxG.save.data.leftArrow;
            case 1:
                textCenter.text = "DOWN KEY: " + FlxG.save.data.downArrow;
            case 2:
                textCenter.text = "UP KEY: " + FlxG.save.data.upArrow;
            case 3:
                textCenter.text = "RIGHT KEY: " + FlxG.save.data.rightArrow;
            case 4:
                textCenter.text = "LEFT ALT KEY: " + FlxG.save.data.leftAltArrow;
            case 5:
                textCenter.text = "DOWN ALT KEY: " + FlxG.save.data.downAltArrow;
            case 6:
                textCenter.text = "UP ALT KEY: " + FlxG.save.data.upAltArrow;
            case 7:
                textCenter.text = "RIGHT ALT KEY: " + FlxG.save.data.rightAltArrow;
            case 8:
                textCenter.text = "(DEBUG) 7 KEY: " + FlxG.save.data.press7;
            case 9:
                textCenter.text = "(DEBUG) 8 KEY: " + FlxG.save.data.press8;
            case 10:
                textCenter.text = "(DEBUG) 9 KEY: " + FlxG.save.data.press9;
            case 11:
                textCenter.text = "(DEBUG) 0 KEY: " + FlxG.save.data.press0;
        }

        if (inChange) {
            // var doCh = FlxG.keys.getIsDown()[0].ID.toString(); // using this doCh instead of writting a long code
            if (!controls.ACCEPT && !controls.BACK && !controls.PAUSE && !controls.CHEAT && !controls.PAUSE && FlxG.keys.justPressed.ANY) {
                switch (init) {
                    case 0: // left
                        FlxG.save.data.leftArrow = FlxG.keys.getIsDown()[0].ID.toString();
                    case 1: // down
                        FlxG.save.data.downArrow = FlxG.keys.getIsDown()[0].ID.toString();
                    case 2: // up
                        FlxG.save.data.upArrow = FlxG.keys.getIsDown()[0].ID.toString();
                    case 3: // right
                        FlxG.save.data.rightArrow = FlxG.keys.getIsDown()[0].ID.toString();
                    case 4: // left alt
                        FlxG.save.data.leftAltArrow = FlxG.keys.getIsDown()[0].ID.toString();
                    case 5: // down alt
                        FlxG.save.data.downAltArrow = FlxG.keys.getIsDown()[0].ID.toString();
                    case 6: // up alt
                        FlxG.save.data.upAltArrow = FlxG.keys.getIsDown()[0].ID.toString();
                    case 7: // right alt
                        FlxG.save.data.rightAltArrow = FlxG.keys.getIsDown()[0].ID.toString();
                    case 8: // debug 7
                        FlxG.save.data.press7 = FlxG.keys.getIsDown()[0].ID.toString();
                    case 9: // debug 8
                        FlxG.save.data.press8 = FlxG.keys.getIsDown()[0].ID.toString();
                    case 10: // debug 9
                        FlxG.save.data.press9 = FlxG.keys.getIsDown()[0].ID.toString();
                    case 11: // debug 10
                        FlxG.save.data.press0 = FlxG.keys.getIsDown()[0].ID.toString();
                }
                // back right now :D
                FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
                controls.setKeyboardScheme(Solo);
                warmText.text = "";
                inChange = false;
            }
        }
    }
}