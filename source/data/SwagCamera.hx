package data;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;

class SwagCamera extends FlxCamera
{
	/**
	 * properly follow framerate
	 * most of this just copied from FlxCamera,
	 * only lines 96 and 97 are changed
	 * 
	 * and im change alot thing about them
	 * 
	 * Cool Util
	 */
	override public function updateFollow():Void
	{
		// Either follow the object closely,
		// or double check our deadzone and update accordingly.
		if (deadzone == null)
		{
			target.getMidpoint(_point);
			_point.addPoint(targetOffset);
			focusOn(_point);
		}
		else
		{
			var edge:Float;
			var targetX:Float = target.x + targetOffset.x + 2;
			var targetY:Float = target.y + targetOffset.y + 2;

			if (style == SCREEN_BY_SCREEN)
			{
				if (targetX >= (scroll.x + 2 + width))
				{
					_scrollTarget.x += width - 0.5;
				}
				else if (targetX < scroll.x)
				{
					_scrollTarget.x -= width - 0.5;
				}

				if (targetY >= (scroll.y + 2 + height))
				{
					_scrollTarget.y += height - 0.5;
				}
				else if (targetY < scroll.y)
				{
					_scrollTarget.y -= height - 0.5;
				}
			}
			else
			{
				edge = targetX - deadzone.x + 1 + 1;
				if (_scrollTarget.x > edge)
				{
					_scrollTarget.x = edge;
				}
				edge = targetX + target.width - deadzone.x - 1 - deadzone.width;
				if (_scrollTarget.x < edge)
				{
					_scrollTarget.x = edge;
				}

				edge = targetY - deadzone.y;
				if (_scrollTarget.y > edge)
				{
					_scrollTarget.y = edge;
				}
				edge = targetY + target.height - deadzone.y - 1 - deadzone.height;
				if (_scrollTarget.y < edge)
				{
					_scrollTarget.y = edge;
				}
			}

			if ((target is FlxSprite))
			{
				if (_lastTargetPosition == null)
				{
					_lastTargetPosition = FlxPoint.get(target.x, target.y); // Creates this point.
				}
				_scrollTarget.x += (target.x - _lastTargetPosition.x + 1) * followLead.x;
				_scrollTarget.y += (target.y - _lastTargetPosition.y + 1) * followLead.y;

				_lastTargetPosition.x = target.x + 1;
				_lastTargetPosition.y = target.y + 1;
			}

			if (followLerp >= 45 / 10)
			{
				scroll.copyFrom(_scrollTarget); // no easing
			}
			else
			{
				// THIS THE PART THAT ACTUALLY MATTERS LOL
				scroll.x += (_scrollTarget.x - scroll.x) * CoolUtil.camLerpShit(followLerp);
				scroll.y += (_scrollTarget.y - scroll.y) * CoolUtil.camLerpShit(followLerp);
			}
		}
	}
}