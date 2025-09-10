package;

import FScoreboard.User_Score;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.ui.FlxUIInputText;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.math.FlxPoint;
import flixel.sound.FlxSound;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import haxe.io.Input;
import openfl.Lib;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFieldType;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;

// import zerolib.ZCountDown;
// import zerolib.ZSpotLight;
#if ADS
import extension.admob.Admob;
import extension.admob.AdmobEvent;
#end

class PlayState extends BaseState
{
	public static inline var TILE_SIZE = 40;

	public var gameState:GameStates;
	public var actorSpeed:Float = 1.0;

	private var gameTime:Int;
	private var timer:Int;
	private var timeAlmostOverWarning:Float;
	private var waterY:Int;
	var inputField:TextField;
	var okButton:FlxButton;

	// private var bases:Array<Home>;
	private var homeBaseGroup:HomeBaseGroup;
	private var logGroup:LogGroup;
	var logGroup1:LogGroup;
	private var turtleGroup:TurtleGroup;
	var turtleGroup1:TurtleGroup;

	public var player:Frog;

	private var carGroup:CarGroup;
	private var carGroup1:Car1Group;
	private var carGroup2:CarGroup;

	// private var touchControls:TouchControls;
	private var hideGameMessageDelay:Int = -1;
	private var safeFrogs:Int = 0;
	private var timeAlmostOverFlag:Bool = false;
	private var playerIsFloating:Bool;

	// private var timeAlmostOverWarning:Int;
	private var lastLifeScore:Int = 0;
	private var nextLife:Int = 5000;
	private var totalElapsed:Float = 0;
	private var isRewardedLoaded:Bool = false;
	private var isRewardedEarned:Bool = false;

	public var snake:Snake;
	public var blueFrog:BlueFrog = null;

	// private var blueFrog:BlueFrog;
	var alligator:Alligator;
	var backgroundGroup:BackgroundGroup;
	var hud:Hud;

	public var level:TiledLevel1;
	public var carGroupNew:FlxTypedSpriteGroup<FlxSprite>;
	public var turtleGroupNew:FlxTypedSpriteGroup<FlxSprite>;
	public var logGroupNew:FlxTypedSpriteGroup<FlxSprite>;
	public var alligatorGroup:FlxTypedSpriteGroup<FlxSprite>;
	public var safeStoneGroup:FlxTypedSpriteGroup<FlxSprite>;
	public var homeGroup:FlxTypedSpriteGroup<FlxSprite>;
	public var water:FlxObject;
	public var swamp:FlxObject;
	public var lava:FlxObject;
	public var road:FlxObject;

	var sndWave:FlxSound;
	var sndAlligator:FlxSound;
	var sndLava:FlxSound;
	var sndSnake:FlxSound;
	private var rectangle_1:Square;
	private var rectangle_2:Square;

	override public function create():Void
	{
		FlxG.debugger.drawDebug = false;
		Reg.PS = this;
		Reg.level = 1;

		sndWave = FlxG.sound.load("Wave");
		sndAlligator = FlxG.sound.load("Alligator");
		sndLava = FlxG.sound.load("Lava");
		sndSnake = FlxG.sound.load("Snake");

		// Create the BG sprites
		// backgroundGroup = new BackgroundGroup();
		// add(backgroundGroup);
		carGroupNew = new FlxTypedSpriteGroup<FlxSprite>();
		turtleGroupNew = new FlxTypedSpriteGroup<FlxSprite>();
		logGroupNew = new FlxTypedSpriteGroup<FlxSprite>();
		// logGroupNew = new FlxTypedGroup<WrappingSprite>();

		alligatorGroup = new FlxTypedSpriteGroup<FlxSprite>();
		safeStoneGroup = new FlxTypedSpriteGroup<FlxSprite>();
		homeGroup = new FlxTypedSpriteGroup<FlxSprite>();
		level = new TiledLevel1("assets/tiled/frogger2_test1.tmx", this);

		// Add backgrounds
		add(level.backgroundLayer);

		add(carGroupNew);
		add(turtleGroupNew);
		add(logGroupNew);
		add(alligatorGroup);
		add(safeStoneGroup);
		add(homeGroup);

		// Load player objects
		add(level.objectsLayer);
		add(snake);
		add(blueFrog);
		// CONFIG::mobile
		// {
		actorSpeed = 1.0;

		// }

		// TODO Need to simplify level

		// Set up main variable properties
		gameTime = Reg.defaultTime * FlxG.updateFramerate; // FlxG.framerate;
		trace("gameTime: " + gameTime);
		timer = gameTime;
		timeAlmostOverWarning = Reg.TIMER_BAR_WIDTH * .7;
		waterY = TILE_SIZE * 8;
		Reg.score = 0;

		// var spotlights = new ZSpotLight(0xe0000000);
		// spotlights.add_to_state();
		// spotlights.add_light_target(player, 100);

		// Create Player
		// player = new Frog(calculateColumn(6), calculateRow(14) + 6);
		// add(player);

		// FlxG.camera.setScrollBoundsRect(0, -FlxG.height, FlxG.width, FlxG.height * 2, true);
		// FlxG.camera.follow(player, LOCKON, 1);

		hud = new Hud();
		add(hud);

		// touchControls = new TouchControls(this, 10, calculateRow(16) + 20, 16);
		// player.touchControls = touchControls;
		// add(touchControls);
		#if mobile
		// 仮想ゲームパッド有効
		Input.createVirtualPad(this, FULL, NONE);
		Input.virtualPad.buttonUp.loadGraphic("assets/images/touchUp.png", 100, 100);
		Input.virtualPad.buttonDown.loadGraphic("assets/images/touchDown.png", 100, 100);
		Input.virtualPad.buttonLeft.loadGraphic("assets/images/touchLeft.png", 100, 100);
		Input.virtualPad.buttonRight.loadGraphic("assets/images/touchRight.png", 100, 100);
		Input.virtualPad.buttonUp.setPosition(10, calculateRow(16) + 20);
		Input.virtualPad.buttonDown.setPosition(10 + 100, calculateRow(16) + 20);
		Input.virtualPad.buttonLeft.setPosition(480 - 200, calculateRow(16) + 20);
		Input.virtualPad.buttonRight.setPosition(480 - 100, calculateRow(16) + 20);
		#end
		#if ADS
		Admob.status.addEventListener(AdmobEvent.REWARDED_LOADED, onRewardedLoadedEvent);
		Admob.status.addEventListener(AdmobEvent.REWARDED_EARNED, onRewardedEarnedEvent);
		Admob.status.addEventListener(AdmobEvent.REWARDED_DISMISSED, onRewardedDismissedEvent);

		// AdMob.onInterstitialEvent = onInterstitialEvent;
		trace("##################Start Load Rewarded Video#################");

		// if (Reg.playCount % 2 == 1)
		// AdMob.showInterstitial(0);
		Admob.loadRewarded(Reg.REWARDED_ID_ANDROID);
		#end

		// var _timer = new ZCountDown(new FlxPoint(20, 20), 1);
		// add(_timer);

		super.create();

		gameState = GameStates.PLAYING;
		FlxG.sound.play("Theme");
		trace("Log Group: " + logGroupNew.length);
		trace("Turtle Group: " + turtleGroupNew.length);
		trace("Car Group: " + carGroupNew.length);
		trace("PlayState display width: " + Lib.current.stage.stageWidth + " display height: " + Lib.current.stage.stageHeight);
	}

	function onRewardedDismissedEvent(event:String)
	{
		trace("The Rewarded Video Event is " + event);
		if (isRewardedEarned)
		{
			hud.createLives(1);

			hud.showGameMessage("Earned 1-Life");
			hideGameMessageDelay = 50;
			isRewardedEarned = false;
			FlxG.sound.play("Bonus");
		}
		closeSubState();
	}

	function onRewardedEarnedEvent(event:String)
	{
		trace("The Rewarded Video Event is " + event);
		isRewardedEarned = true;
		isRewardedLoaded = false;
	}

	function onRewardedLoadedEvent(event:String)
	{
		trace("The Rewarded Video Event is " + event);
		isRewardedLoaded = true;
	}

	/**
	 * Helper function to find the X position of a columm on the game's grid
	 * @param value colum number
	 * @return returns number based on the value * TILE_SIZE
	**/
	public function calculateColumn(value:Int):Int
	{
		return value * TILE_SIZE;
	}

	/**
	 * Helper function to find the Y position of a row on the game's grid
	 * @param value row number
	 * @return returns number based on the value * TILE_SIZE
	 */
	public function calculateRow(value:Int):Int
	{
		return calculateColumn(value);
	}

	override public function destroy():Void
	{
		// set sprites to null to help with gc
		rectangle_1 = null;
		rectangle_2 = null;

		super.destroy();
	}

	// var secondsFlag:Bool;
	var displayFlag:Bool = false;

	override public function update(elapsed:Float):Void
	{
		// TODO these first two condition based on hideGameMessageDelay can be cleaned up.
		if (gameState == GameStates.GAME_OVER)
		{
			if (hideGameMessageDelay == 0)
			{
				// FlxG.state = new StartState();
				// ToDo by hoon
				#if ADS
				Admob.status.removeEventListener(AdmobEvent.REWARDED_LOADED, onRewardedLoadedEvent);
				Admob.status.removeEventListener(AdmobEvent.REWARDED_EARNED, onRewardedEarnedEvent);
				Admob.status.removeEventListener(AdmobEvent.REWARDED_DISMISSED, onRewardedDismissedEvent);
				#end
				if (!displayFlag)
				{
					displayFlag = true;
					hud.showEnterUserNameField(true);
					hud.displayTextField();
				}
			}
			else
			{
				hideGameMessageDelay -= 1;
				// trace("HideGameMessageDelay: " + hideGameMessageDelay);
			}
		}
		else if (gameState == GameStates.LEVEL_OVER)
		{
			if (hideGameMessageDelay == 0)
			{
				restart();
			}
			else
			{
				hideGameMessageDelay -= 1; // FlxG.elapsed;
			}
		}
		else if (gameState == GameStates.PLAYING)
		{
			// trace("Player Position Y:" + player.y);
			// Reset floating flag for the player.
			playerIsFloating = false;

			// Do collision detections
			// FlxG.overlap(carGroup, player, carCollision);
			// FlxG.overlap(carGroup1, player, carCollision);
			// FlxG.overlap(road, player, roadCollision);
			// FlxG.overlap(carGroupNew, player, carCollision);
			for (newCar in carGroupNew)
			{
				var collides = false;
				if (FlxG.pixelPerfectOverlap(newCar, player))
				{
					if (gameState != GameStates.COLLISION)
					{
						collides = true;
						// newCar.color = 0xFFac3232;
						FlxG.sound.play("Squash");
						killPlayer(false);
						break;
						// carCollision(carGroupNew, player);
					}
				}
			}
			for (newLog in logGroupNew)
			{
				if (FlxG.pixelPerfectOverlap(newLog, player))
				{
					playerIsFloating = true;
					#if desktop
					if (!(FlxG.keys.pressed.LEFT || FlxG.keys.pressed.RIGHT))
					#end
					{
						var castLog:WrappingSprite = cast(newLog, WrappingSprite);
						player.float(castLog.speed, castLog.facing);
					}
				}
			}
			if (FlxG.pixelPerfectOverlap(blueFrog, player))
			{
				Reg.score += ScoreValues.HOME_BONUS;

				FlxG.sound.play("Bonus");
				blueFrog.kill();
			}
			if (FlxG.pixelPerfectOverlap(snake, player))
			{
				if (gameState != GameStates.COLLISION)
				{
					// collides = true;
					// newCar.color = 0xFFac3232;
					FlxG.sound.play("Squash");
					killPlayer(false);
					// break;
					// carCollision(carGroupNew, player);
				}
			}
			// for (newTurtle in turtleGroupNew)
			// {
			// 	if (FlxG.overlap(newTurtle, player))
			// 	{
			// 		var target:TimerSprite = cast(newTurtle, TimerSprite);
			// 		// Test to see if the target is active. If it is active the player can float. If not the player
			// 		// is in the water
			// 		if (target.get_isActive())
			// 		{
			// 			float(target, player);
			// 		}
			// 		else if (!player.isMoving)
			// 		{
			// 			waterCollision();
			// 		}
			// 	}
			// }

			// FlxG.overlap(logGroupNew, player, float);
			FlxG.overlap(turtleGroupNew, player, turtleFloat);
			FlxG.overlap(homeGroup, player, baseCollision);
			// FlxG.overlap(snake, player, carCollision);
			FlxG.overlap(alligatorGroup, player, float);
			FlxG.overlap(safeStoneGroup, player, stoneCollision);
			FlxG.overlap(water, player, liquidCollision);
			FlxG.overlap(swamp, player, liquidCollision);
			FlxG.overlap(lava, player, liquidCollision);

			if (timer == 0 && gameState == GameStates.PLAYING)
			{
				timeUp();
			}
			else
			{
				timer -= 1;
				hud.timerBar.scale.x = Reg.TIMER_BAR_WIDTH - Math.round((timer / gameTime * Reg.TIMER_BAR_WIDTH));

				if (hud.timerBar.scale.x == timeAlmostOverWarning && !timeAlmostOverFlag)
				{
					// FlxG.play(GameAssets.FroggerTimeSound);
					FlxG.sound.play("Time");
					timeAlmostOverFlag = true;
				}
			}

			// Manage hiding gameMessage based on timer
			if (hideGameMessageDelay > 0)
			{
				hideGameMessageDelay -= 1; // FlxG.elapsed;
				if (hideGameMessageDelay < 0)
					hideGameMessageDelay = 0;
			}
			else if (hideGameMessageDelay == 0)
			{
				hideGameMessageDelay = -1;
				hud.hideGameMessage();
				// gameMessageGroup.visible = false;
			}

			// Update the score text
			// ToDo by hoon
			scoreTxt.text = Std.string(Reg.score);
			// scoreTxt.text = FlxG.score.toString();
		}
		else if (gameState == GameStates.RESTART)
		{
			// restart();
			if (hideGameMessageDelay == 0)
			{
				restart();
			}
			else
			{
				hideGameMessageDelay -= 1; // FlxG.elapsed;
			}
		}
		else if (gameState == GameStates.DEATH_OVER)
		{
			if (hideGameMessageDelay == 0)
			{
				// restart();
				if (hud.get_totalLives() == 0)
				{
					if (isRewardedLoaded)
					{
						// Admob.showRewarded();
						openSubState(new Popup_Demo());
					}
					else
						restart();
				}
				else
					restart();
			}
			else
			{
				hideGameMessageDelay -= 1; // FlxG.elapsed;
			}
		}

		if (lastLifeScore != Reg.score && Reg.score % nextLife == 0)
		{
			if (hud.get_totalLives() < 5)
			{
				hud.addLife();
				lastLifeScore = Reg.score;

				hud.showGameMessage("1-UP");
				hideGameMessageDelay = 200;
			}
		}
		// Update the entire game
		super.update(elapsed);
	}

	private function liquidCollision(target:FlxObject, player:Frog):Void
	{
		// trace("###############Liquid Collisions#############");
		// trace("Player Position: " + player.y + " ID: " + target.ID);
		if (target.ID == 0) // water
		{
			if (!sndWave.playing)
				sndWave.play(true);
		}
		else if (target.ID == 1) // swamp
		{
			if (!sndAlligator.playing)
				sndAlligator.play(true);
		}
		else if (target.ID == 2) // lava
		{
			if (!sndLava.playing)
				sndLava.play(true);
		}

		// TODO this can be cleaned up better
		// if (!player.isMoving && !playerIsFloating)
		if (!playerIsFloating)
			waterCollision();

		if ((player.x > FlxG.width - player.frameWidth / 2) || (player.x < -player.frameWidth / 2))
			// if(!player.isOnScreen())
		{
			waterCollision();
		}
	}

	private function stoneCollision(target:TimerSprite, player:Frog):Void
	{
		// trace("##############Stone Collision###########");
		if (target.get_isActive())
		{
			float(target, player);
		}
		else if (!player.isMoving)
		{
			waterCollision();
		}
	}

	private function timeUp():Void
	{
		if (gameState != GameStates.COLLISION)
		{
			// FlxG.play(GameAssets.FroggerSquashSound);
			FlxG.sound.play("Squash");
			killPlayer(false);
		}
	}

	private function waterCollision():Void
	{
		if (gameState != GameStates.COLLISION)
		{
			// FlxG.play(GameAssets.FroggerPlunkSound);
			FlxG.sound.play("Plunk");
			killPlayer(true);
		}
	}

	function roadCollision(target:FlxObject, player:Frog):Void
	{
		if (gameState != GameStates.COLLISION)
		{
			trace("############Road#####################");
			// if(!sndCarGroup.getFirstAlive().playing)
			//    sndCarGroup.getFirstAlive().play();
		}
	}

	private function carCollision(target:FlxObject, player:Frog):Void
	{
		if (gameState != GameStates.COLLISION)
		{
			// sndCarGroup.getRandom().play();
			// FlxG.play(GameAssets.FroggerSquashSound);
			if (Std.isOfType(target, Car) || Std.isOfType(target, Car1) || Std.isOfType(target, Truck) || Std.isOfType(target, Snake))
			{
				FlxG.sound.play("Squash");
				killPlayer(false);
			}
			else
			{
				// trace("Player Position Y: " + player.y);
				// trace("Target Position Y: " + target.y);
				// trace("Target Bottom Y: " + Std.string(target.y + target.height));
			}
		}
	}

	private function baseCollision(target:Home, player:Frog):Void
	{
		var timeLeftOver:Int = Math.round(timer / FlxG.updateFramerate);
		trace("Base Collision Mode:" + target.mode + " TimeLeftOver: " + timeLeftOver);

		switch (target.mode)
		{
			case Home.EMPTY:
				// Increment number of frogs saved
				safeFrogs++;

				// Flag the target as success to show it is occupied now
				target.success();

				// var timeLeftOver:Int = Math.round(timer / FlxG.drawFramerate);

				// Increment the score based on the time left
				Reg.score += timeLeftOver * ScoreValues.TIME_BONUS;
				FlxG.sound.play("Bonus");
			// break;
			case Home.BONUS:
				// Increment number of frogs saved
				safeFrogs++;

				// Flag the target as success to show it is occupied now
				target.success();

				// var timeLeftOver:Int = Math.round(timer / FlxG.drawFramerate);

				// Increment the score based on the time left
				Reg.score += timeLeftOver * ScoreValues.TIME_BONUS;

				if (target.mode == Home.BONUS)
					Reg.score += ScoreValues.HOME_BONUS;

				FlxG.sound.play("Bonus");
			// break;
			case Home.NO_BONUS:
				waterCollision();
				return;
			case Home.SUCCESS:
				return;
				// break;
		}
		trace("Safe frogs:" + safeFrogs + "Group:" + homeGroup.length);

		// Reguardless if the base was empty or occupied we still display the time it took to get there
		hud.showGameMessage("TIME " + Std.string(gameTime / FlxG.updateFramerate - timeLeftOver));
		hideGameMessageDelay = 200;

		// Test to see if we have all the frogs, if so then level has been completed. If not restart.
		if (safeFrogs == homeGroup.length)
		{
			levelComplete();
		}
		else
		{
			hideGameMessageDelay = 50;
			gameState = GameStates.RESTART;
			player.restart();
			// restart();
		}
	}

	private function levelComplete():Void
	{
		// Increment the score based on
		Reg.score += ScoreValues.FINISH_LEVEL;

		// Change game state to let system know a level has been completed
		gameState = GameStates.LEVEL_OVER;

		// Hide the player since the level is over and wait for the game to restart itself
		player.visible = false;
	}

	private function turtleFloat(target:TimerSprite, player:Frog):Void
	{
		// Test to see if the target is active. If it is active the player can float. If not the player
		// is in the water
		if (target.get_isActive())
		{
			float(target, player);
		}
		else if (!player.isMoving)
		{
			waterCollision();
		}
	}

	private function float(target:WrappingSprite, player:Frog):Void
	{
		playerIsFloating = true;
		if (Std.isOfType(target, Alligator))
		{
			target.color = 0xff0000;
			trace("Alligator X:" + target.x);
			trace("Player X:" + player.x);
		}
		#if desktop
		if (!(FlxG.keys.pressed.LEFT || FlxG.keys.pressed.RIGHT))
		#end
		{
			player.float(target.speed, target.facing);
		}
	}

	public function restart():Void
	{
		// Make sure the player still has lives to restart
		if (hud.get_totalLives() == 0 && gameState != GameStates.GAME_OVER)
		{
			gameOver();
		}
		else
		{
			// Test to see if Level is over, if so reset all the bases.
			if (gameState == GameStates.LEVEL_OVER)
			{
				resetBases();
				Reg.level++;
				levelUp();
			}
			levelTxt.text = Std.string(Reg.level);
			// Change game state to Playing so animation can continue.
			timer = gameTime;
			player.restart();
			timeAlmostOverFlag = false;
			gameState = GameStates.PLAYING;
			trace("restart end");
			// totalElapsed = 0;
		}
	}

	public function levelUp():Void
	{
		actorSpeed += 0.2;
		if (actorSpeed > 2.0)
			actorSpeed = 2.0;
		alligatorGroup.forEachOfType(Alligator, function(_alligator)
		{
			// var alligator:Alligator = cast _alligator;

			_alligator.speed = actorSpeed;
			trace("Alligator Speed:" + _alligator.speed);
		});
		turtleGroupNew.forEachOfType(WrappingSprite, function(_turtle)
		{
			// var turtle:WrappingSprite = cast _turtle;

			_turtle.speed = actorSpeed;
			trace("Turtle Speed:" + _turtle.speed);
		});
		carGroupNew.forEachOfType(Car1, function(_car)
		{
			// var car:Car1 = cast _car;

			_car.speed = actorSpeed;
			trace("Car Speed:" + _car.speed);
		});
		logGroupNew.forEachOfType(WrappingSprite, function(_logMoving)
		{
			// var logMoving:WrappingSprite = cast(_logMoving, WrappingSprite);

			_logMoving.speed = actorSpeed;
			trace("Log Speed:" + _logMoving.speed);
		});
	}

	private function resetBases():Void
	{
		homeGroup.forEachOfType(Home, function(_base)
		{
			// var here = cast base;
			trace("base:", _base);
			_base.empty();
		});
		// Reset safe frogs
		safeFrogs = 0;

		// Set message to tell player they can restart
		hud.showGameMessage("START");
		hideGameMessageDelay = 200;
	}

	private function killPlayer(isWater:Bool):Void
	{
		// commented just test home collision
		gameState = GameStates.COLLISION;
		hud.removeLife();
		player.death(isWater);
		hideGameMessageDelay = 30;
	}

	private function gameOver():Void
	{
		gameState = GameStates.GAME_OVER;

		hud.showGameMessage("GAME OVER");

		hideGameMessageDelay = 100;

		// TODO there is a Game Over sound I need to play here
		FlxG.sound.playMusic("GameOver", 1, false);
	}
}
