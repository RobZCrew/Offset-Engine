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
import flixel.group.FlxTypedGroup;

import flixel.util.FlxTimer;
import flixel.util.FlxColor;
import flixel.util.FlxAxes;
import flixel.util.FlxSort;
import flixel.util.FlxSave;
import flixel.util.FlxDestroyUtil;
import flicel.util.FlxStringUtil;

import flixel.text.FlxText;
import flixel.text.FlxTextAlign;
import flixel.text.FlxTextBorderStyle;

import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.effects.FlxFlicker;

import flixel.addons.display.FlxBackdrop;

// MISC
import motion.*; // imports Actuate and MotionPath
import flxanimate.*;

// FUNKIN / ENGINE
import funkin.Paths;
import funkin.Conductor;
import funkin.Preferences;
import funkin.ui.MusicBeatState;
import funkin.ui.MusicBeatSubstate;
import funkin.ui.Alphabet;
import funkin.graphics.FunkinSprite;
import funkin.graphics.text.FunkinText;
import funkin.graphics.video.FunkinVideo;
import funkin.util.CoolUtil;
import funkin.util.CameraUtil;
import funkin.util.Constants;
import funkin.input.Controls;
import funkin.play.PlayState;

// USING CLASSES
using StringTools;
#end