#if !macro
// HAXE / CORE
import Std;
import Type;
import Reflect;
import Math;

// FLIXEL
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.FlxCamera;
import flixel.FlxBasic;

import flixel.sound.FlxSound;

import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;

import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
//import flixel.group.FlxTypedGroup;

import flixel.util.FlxTimer;
import flixel.util.FlxColor;
import flixel.util.FlxAxes;
import flixel.util.FlxSort;
import flixel.util.FlxSave;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxStringUtil;

import flixel.text.FlxText;
/*import flixel.text.FlxTextAlign;
import flixel.text.FlxTextBorderStyle;*/

import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.effects.FlxFlicker;

import flixel.addons.display.FlxBackdrop;

// MISC
import motion.*; // imports Actuate and MotionPath
import animate.*;

// FUNKIN / ENGINE
//import funkin.states.PlayState;
import funkin.states.MusicBeatState;
import funkin.substates.MusicBeatSubstate;
import funkin.objects.game.Alphabet;
import funkin.objects.input.Controls;
import funkin.objects.song.Conductor;
/*import funkin.objects.graphics.FunkinSprite;
import funkin.objects.graphics.text.FunkinText;
import funkin.objects.graphics.video.FunkinVideo;*/
import funkin.utils.CoolUtil;
//import funkin.utils.CameraUtil;
import funkin.utils.Preferences;
import funkin.utils.Paths;

// USING CLASSES
using StringTools;
#end