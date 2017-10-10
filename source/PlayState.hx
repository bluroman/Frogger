package;

import flixel.math.FlxPoint;
import flixel.ui.FlxButton;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxObject;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.text.FlxText;
import flixel.group.FlxGroup;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.ui.FlxUIInputText;
import flixel.util.FlxColor;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFieldType;
import openfl.text.TextFormatAlign;
import openfl.text.TextFieldAutoSize;
import openfl.Lib;
import FScoreboard.User_Score;
import zerolib.ZSpotLight;
import zerolib.ZCountDown;


class PlayState extends BaseState
{
    public static inline var TILE_SIZE = 40;
    public var gameState:GameStates;

    private var actorSpeed:Int = 1;
    private var gameTime:Int;
    private var timer:Int;
    private var timeAlmostOverWarning:Float;
    private var waterY:Int;
    var inputField:TextField;
    var okButton:FlxButton;

    //private var bases:Array<Home>;
    private var homeBaseGroup:HomeBaseGroup;
    private var logGroup:LogGroup;
    var logGroup1:LogGroup;
    private var turtleGroup:TurtleGroup;
    var turtleGroup1:TurtleGroup;
    public var player:Frog;
    private var carGroup:CarGroup;
    private var carGroup1:Car1Group;
    private var carGroup2:CarGroup;

    private var touchControls:TouchControls;

    private var hideGameMessageDelay:Int = -1;
    private var safeFrogs:Int = 0;
    private var timeAlmostOverFlag:Bool = false;
    private var playerIsFloating:Bool;
    //private var timeAlmostOverWarning:Int;
    private var lastLifeScore:Int = 0;
    private var nextLife:Int = 5000;
    private var totalElapsed:Float = 0;
    public var snake:Snake;
    private var blueFrog:BlueFrog;
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
	override public function create():Void
	{

        FlxG.debugger.drawDebug = false;
        Reg.PS = this;

        // Create the BG sprites
        //backgroundGroup = new BackgroundGroup();
        //add(backgroundGroup);
        carGroupNew = new FlxTypedSpriteGroup<FlxSprite>();
        turtleGroupNew = new FlxTypedSpriteGroup<FlxSprite>();
        logGroupNew = new FlxTypedSpriteGroup<FlxSprite>();
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
        //CONFIG::mobile
        //{
        actorSpeed = 1;

        //}

        //TODO Need to simplify level

        // Set up main variable properties
        gameTime = Reg.defaultTime * FlxG.updateFramerate;//FlxG.framerate;
        trace("gameTime: "+ gameTime);
        timer = gameTime;
        timeAlmostOverWarning = Reg.TIMER_BAR_WIDTH * .7;
        waterY = TILE_SIZE * 8;
        Reg.score = 0;

//        homeBaseGroup = new HomeBaseGroup();
//        add(homeBaseGroup);
//
//        // Create logs and turtles
//        logGroup = new LogGroup(3, actorSpeed);
//        add(logGroup);
//        logGroup1 = new LogGroup(-10, actorSpeed);
//        add(logGroup1);
//
//        turtleGroup = new TurtleGroup(2, actorSpeed);
//        add(turtleGroup);
//        turtleGroup1 = new TurtleGroup(-11, actorSpeed);
//        add(turtleGroup1);
//
//        snake = new Snake(0, calculateRow(8), FlxObject.LEFT, actorSpeed);
//        add(snake);
//
//
//
//        // Create Cars
//        carGroup = new CarGroup(0, calculateRow(-4), actorSpeed);
//        add(carGroup);
//
//        // Create Cars
//        carGroup1 = new Car1Group(0, calculateRow(9), actorSpeed);
//        add(carGroup1);
//
//        carGroup2 = new CarGroup(0, calculateRow(-17), actorSpeed);
//        add(carGroup2);

        //var spotlights = new ZSpotLight(0xe0000000);
        //spotlights.add_to_state();
        //spotlights.add_light_target(player, 100);

        // Create Player
        //player = new Frog(calculateColumn(6), calculateRow(14) + 6);
        //add(player);

        //FlxG.camera.setScrollBoundsRect(0, -FlxG.height, FlxG.width, FlxG.height * 2, true);
        //FlxG.camera.follow(player, LOCKON, 1);

        hud = new Hud();
        add(hud);

        touchControls = new TouchControls(this, 10, calculateRow(16) + 20, 16);
        player.touchControls = touchControls;
        add(touchControls);

        var _timer = new ZCountDown(new FlxPoint(20, 20), 1);
        add(_timer);

        super.create();

        gameState = GameStates.PLAYING;
        FlxG.sound.play("Theme");
        trace("Log Group: " + logGroupNew.length);
        trace("Turtle Group: " + turtleGroupNew.length);
        trace("Car Group: " + carGroupNew.length);
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

    //var secondsFlag:Bool;
    var displayFlag:Bool = false;
    override public function update(elapsed:Float):Void
    {
        //TODO these first two condition based on hideGameMessageDelay can be cleaned up.
        if (gameState == GameStates.GAME_OVER)
        {
            if (hideGameMessageDelay == 0)
            {
                //FlxG.state = new StartState();
                //ToDo by hoon
                if(!displayFlag)
                {
                    displayFlag = true;
                    hud.showEnterUserNameField(true);
                    hud.displayTextField();
                }
            } else
            {
                hideGameMessageDelay -= 1;
                //trace("HideGameMessageDelay: " + hideGameMessageDelay);
            }
        } else if (gameState == GameStates.LEVEL_OVER)
        {
            if (hideGameMessageDelay == 0)
            {
                restart();
            } else
            {
                hideGameMessageDelay -= 1;//FlxG.elapsed;
            }
        } else if (gameState == GameStates.PLAYING)
        {
            trace("Player Position Y:" + player.y);
            // Reset floating flag for the player.
            playerIsFloating = false;

            // Do collision detections
            //FlxG.overlap(carGroup, player, carCollision);
            //FlxG.overlap(carGroup1, player, carCollision);
            FlxG.overlap(carGroupNew, player, carCollision);
            FlxG.overlap(logGroupNew, player, float);
            FlxG.overlap(turtleGroupNew, player, turtleFloat);
            FlxG.overlap(homeGroup, player, baseCollision);
            FlxG.overlap(snake, player, carCollision);
            FlxG.overlap(alligatorGroup, player, float);
            FlxG.overlap(safeStoneGroup, player, stoneCollision);
            FlxG.overlap(water, player, liquidCollision);
            FlxG.overlap(swamp, player, liquidCollision);
            FlxG.overlap(lava, player, liquidCollision);

            // If nothing has collided with the player, test to see if they are out of bounds when in the water zone
           /* if (FlxG.overlap(water, player) || FlxG.overlap(swamp, player) || FlxG.overlap(lava, player))//player.y < waterY)
            {
                trace("Water Overlap!!!!!!!!!!!!");
                trace("Player Position: " + player.y);
                //TODO this can be cleaned up better
                if (!player.isMoving && !playerIsFloating)
                    waterCollision();

                if ((player.x > FlxG.width - player.frameWidth/2) || (player.x < -player.frameWidth/2 ))
                    //if(!player.isOnScreen())
                {
                    waterCollision();

                }

            }*/

            if (timer == 0 && gameState == GameStates.PLAYING)
            {
                timeUp();
            } else
            {
                timer -= 1;
                hud.timerBar.scale.x = Reg.TIMER_BAR_WIDTH - Math.round((timer / gameTime * Reg.TIMER_BAR_WIDTH));

                if (hud.timerBar.scale.x == timeAlmostOverWarning && !timeAlmostOverFlag)
                {
                    //FlxG.play(GameAssets.FroggerTimeSound);
                    FlxG.sound.play("Time");
                    timeAlmostOverFlag = true;
                }
            }

            // Manage hiding gameMessage based on timer
            if (hideGameMessageDelay > 0)
            {
                hideGameMessageDelay -= 1;//FlxG.elapsed;
                if (hideGameMessageDelay < 0)
                    hideGameMessageDelay = 0;
            }
            else if (hideGameMessageDelay == 0)
            {
                hideGameMessageDelay = -1;
                hud.hideGameMessage();
                //gameMessageGroup.visible = false;
            }

            // Update the score text
            //ToDo by hoon
            scoreTxt.text = Std.string(Reg.score);
            //scoreTxt.text = FlxG.score.toString();
        } else if (gameState == GameStates.DEATH_OVER)
        {
            //restart();
            if (hideGameMessageDelay == 0)
            {
                restart();
            } else
            {
                hideGameMessageDelay -= 1;//FlxG.elapsed;
            }
        }

        if (lastLifeScore != Reg.score && Reg.score % nextLife == 0)
        {

            if(hud.get_totalLives() < 5)
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
        trace("###############Liquid Collisions#############");
        trace("Player Position: " + player.y);
        //TODO this can be cleaned up better
        if (!player.isMoving && !playerIsFloating)
            waterCollision();

        if ((player.x > FlxG.width - player.frameWidth/2) || (player.x < -player.frameWidth/2 ))
            //if(!player.isOnScreen())
        {
            waterCollision();

        }
    }
    private function stoneCollision(target:TimerSprite, player:Frog):Void
    {
        trace("##############Stone Collision###########");
        if (target.get_isActive())
        {
            float(target, player);
        } else if (!player.isMoving)
        {
            waterCollision();
        }
    }
    private function timeUp():Void
    {
        if (gameState != GameStates.COLLISION)
        {
            //FlxG.play(GameAssets.FroggerSquashSound);
            FlxG.sound.play("Squash");
            killPlayer(false);
        }
    }
    private function waterCollision():Void
    {
        if (gameState != GameStates.COLLISION)
        {
            //FlxG.play(GameAssets.FroggerPlunkSound);
            FlxG.sound.play("Plunk");
            killPlayer(true);
        }
    }
    private function carCollision(target:FlxSprite, player:Frog):Void
    {
        if (gameState != GameStates.COLLISION)
        {
            //FlxG.play(GameAssets.FroggerSquashSound);
            if(Std.is(target, Car) || Std.is(target, Car1) || Std.is(target, Truck) || Std.is(target, Snake))
            {
                FlxG.sound.play("Squash");
                killPlayer(false);
            }
            else
            {
                trace("Player Position Y: " + player.y);
                trace("Target Position Y: " + target.y);
                trace("Target Bottom Y: " + Std.string(target.y + target.height));
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
                safeFrogs ++;

                // Flag the target as success to show it is occupied now
                target.success();

                //var timeLeftOver:Int = Math.round(timer / FlxG.drawFramerate);

                // Increment the score based on the time left
                Reg.score += timeLeftOver * ScoreValues.TIME_BONUS;
            case Home.BONUS:
                // Increment number of frogs saved
                safeFrogs ++;

                // Flag the target as success to show it is occupied now
                target.success();

                //var timeLeftOver:Int = Math.round(timer / FlxG.drawFramerate);

                // Increment the score based on the time left
                Reg.score += timeLeftOver * ScoreValues.TIME_BONUS;

                if (target.mode == Home.BONUS)
                    Reg.score += ScoreValues.HOME_BONUS;
            case Home.NO_BONUS:
                waterCollision();
                return;
            case Home.SUCCESS:
                return;
                //break;

        }
        trace("Safe frogs:" + safeFrogs + "Group:" + homeGroup.length);


        // Reguardless if the base was empty or occupied we still display the time it took to get there
        hud.showGameMessage("TIME " + Std.string(gameTime / FlxG.updateFramerate - timeLeftOver));
        hideGameMessageDelay = 200;

        // Test to see if we have all the frogs, if so then level has been completed. If not restart.
        if (safeFrogs == homeGroup.length)
        {
            levelComplete();
        } else
        {
            restart();
        }

    }
    private function levelComplete():Void
    {

        //Increment the score based on
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
        } else if (!player.isMoving)
        {
            waterCollision();
        }
    }
    private function float(target:WrappingSprite, player:Frog):Void
    {
        playerIsFloating = true;
        if(Std.is(target, Alligator))
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
    private function restart():Void
    {
        // Make sure the player still has lives to restart
        if (hud.get_totalLives() == 0 && gameState != GameStates.GAME_OVER)
        {
            gameOver();
        } else
        {
            // Test to see if Level is over, if so reset all the bases.
            if (gameState == GameStates.LEVEL_OVER)
            {
                resetBases();
                Reg.level++;
            }
            levelTxt.text = Std.string(Reg.level);
            // Change game state to Playing so animation can continue.
            gameState = GameStates.PLAYING;
            timer = gameTime;
            player.restart();
            timeAlmostOverFlag = false;
            //totalElapsed = 0;
        }
    }
    private function resetBases():Void
    {
        homeGroup.forEach(function(base:FlxSprite)
        {
            var here = cast base;
            trace("base:", here);
            here.empty();
        });
            // Reset safe frogs
        safeFrogs = 0;

            // Set message to tell player they can restart
        hud.showGameMessage("START");
        hideGameMessageDelay = 200;
    }
    private function killPlayer(isWater:Bool):Void
    {
        //commented just test home collision
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

        //TODO there is a Game Over sound I need to play here
    }

}
