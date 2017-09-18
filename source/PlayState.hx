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
    public static inline var LIFE_X = 20;
    public static inline var LIFE_Y = 610;
    public static inline var TIMER_BAR_WIDTH = 300;
    public static inline var TILE_SIZE = 40;
    public var gameState:GameStates;

    private var actorSpeed:Int = 1;
    private var gameTime:Int;
    private var timer:Int;
    private var timeAlmostOverWarning:Float;
    private var waterY:Int;
    private var lifeSprites = [];

    //public var _score = 0;
    //private var _currentLevel = 1;

    private var gameMessageGroup:FlxTypedSpriteGroup<FlxSprite>;
    private var messageText:FlxText;

    var enterUserNameGroup:FlxTypedSpriteGroup<FlxSprite>;
    var enterYourName:FlxText;
    var inputField:TextField;
    var okButton:FlxButton;

    //private var bases:Array<Home>;
    private var homeBaseGroup:FlxTypedGroup<Home>;
    private var logGroup:FlxGroup;
    private var turtleGroup:FlxGroup;
    private var player:Frog;
    private var carGroup:FlxGroup;

    private var timeTxt:FlxText;
    private var timerBarBackground:FlxSprite;
    private var timerBar:FlxSprite;

    private var touchControls:TouchControls;

    private var hideGameMessageDelay:Int = -1;
    private var safeFrogs:Int = 0;
    private var timeAlmostOverFlag:Bool = false;
    private var playerIsFloating:Bool;
    //private var timeAlmostOverWarning:Int;
    private var lastLifeScore:Int = 0;
    private var nextLife:Int = 5000;
    private var totalElapsed:Float = 0;
    private var snake:Snake;
    private var blueFrog:BlueFrog;
    var alligator:Alligator;
	override public function create():Void
	{
		super.create();
        Reg.PS = this;

        lifeSprites = new Array();

        // Create the BG sprites
        add(new FlxSprite(0, calculateRow(1) + 19 + 20, AssetPaths.water_background1__png));

        add(new FlxSprite(0, calculateRow(14), AssetPaths.bottom_ground__png));
        add(new FlxSprite(0, calculateRow(8), AssetPaths.shore_sprite__png));
        add(new FlxSprite(0, calculateRow(1) + 19, AssetPaths.top_ground1__png));

        //CONFIG::mobile
        //{
        actorSpeed = 1;

        //}

        //TODO Need to simplify level

        // Set up main variable properties
        gameTime = (30 - Reg.level) * FlxG.updateFramerate;//FlxG.framerate;
        trace("gameTime: "+ gameTime);
        timer = gameTime;
        timeAlmostOverWarning = TIMER_BAR_WIDTH * .7;
        waterY = TILE_SIZE * 8;
        Reg.score = 0;
        //_score = 0;
        createLives(3);

        // Create game message, this handles game over, time, and start message for player
        gameMessageGroup = new FlxTypedSpriteGroup<FlxSprite>((480 * .5) - (150 * .5), calculateRow(8) + 5 );
        //gameMessageGroup.x = (480 * .5) - (150 * .5);
        //gameMessageGroup.y = calculateRow(8) + 5;
        add(gameMessageGroup);

        // Black background for message
        var messageBG:FlxSprite = new FlxSprite(0, 0);
        messageBG.makeGraphic(150, 30, 0xff000000);
        gameMessageGroup.add(messageBG);

        // Message text
        messageText = new FlxText(0, 4, 150, "TIME 99").setFormat(null, 18, 0xffff00, "center");
        gameMessageGroup.visible = false;
        gameMessageGroup.add(messageText);

        enterUserNameGroup = new FlxTypedSpriteGroup<FlxSprite>(0, calculateRow(8));
        add(enterUserNameGroup);

        var enterUserNameBG:FlxSprite = new FlxSprite(0, 0);
        enterUserNameBG.makeGraphic(480, 40, 0xff000000);
        enterUserNameGroup.add(enterUserNameBG);

        enterYourName = new FlxText(0, 4, 240, "ENTER YOUR NAME:").setFormat(null, 18, 0xffff00, "left");
        enterUserNameGroup.visible = false;
        enterUserNameGroup.add(enterYourName);

        homeBaseGroup = new FlxTypedGroup<Home>();
        add(homeBaseGroup);
        homeBaseGroup.add(new Home(28, 59 + 22, 200, 200,10));
        homeBaseGroup.add(new Home(28 + 96, 59 + 22, 200, 200,10));
        homeBaseGroup.add(new Home(28 + 96 * 2, 59 + 22, 200, 200, 10));
        homeBaseGroup.add(new Home(28 + 96 * 3, 59 + 22, 200, 200, 10));
        homeBaseGroup.add(new Home(28 + 96 * 4, 59 + 22, 200, 200, 10));

        // Create logs and turtles
        logGroup = new FlxGroup();
        add(logGroup);
        turtleGroup = new FlxGroup();
        add(turtleGroup);
        //logGroup = add(new FlxGroup()) as FlxGroup;
        //turtleGroup = add(new FlxGroup()) as FlxGroup;

        logGroup.add(new Log(0, calculateRow(3), Log.TYPE_C, FlxObject.RIGHT, actorSpeed));
        logGroup.add(new Log(Log.TYPE_C_WIDTH + 77, calculateRow(3), Log.TYPE_C, FlxObject.RIGHT, actorSpeed));
        //logGroup.add(new Log((Log.TYPE_C_WIDTH + 77) * 2, calculateRow(3), Log.TYPE_C, FlxObject.RIGHT, actorSpeed, this));

        turtleGroup.add(new TurtlesA(0, calculateRow(4), -1, -1, FlxObject.LEFT, actorSpeed));
        turtleGroup.add(new TurtlesA((TurtlesA.SPRITE_WIDTH + 123) * 1, calculateRow(4), TurtlesA.DEFAULT_TIME, 200, FlxObject.LEFT, actorSpeed));
        turtleGroup.add(new TurtlesA((TurtlesA.SPRITE_WIDTH + 123) * 2, calculateRow(4), -1, -1, FlxObject.LEFT, actorSpeed));

        logGroup.add(new Log(30, calculateRow(5), Log.TYPE_B, FlxObject.RIGHT, actorSpeed* 2));
        logGroup.add(new Log(Log.TYPE_B_WIDTH + 130, calculateRow(5), Log.TYPE_B, FlxObject.RIGHT, actorSpeed* 2));

        logGroup.add(new Log(0, calculateRow(6), Log.TYPE_A, FlxObject.RIGHT, actorSpeed));
        logGroup.add(new Log(Log.TYPE_A_WIDTH + 77, calculateRow(6), Log.TYPE_A, FlxObject.RIGHT, actorSpeed));
        logGroup.add(new Log((Log.TYPE_A_WIDTH + 77) * 2, calculateRow(6), Log.TYPE_A, FlxObject.RIGHT, actorSpeed));

        blueFrog = new BlueFrog(100, 100, 0xffffff,cast(logGroup.getFirstAlive(), Log));
        logGroup.add(blueFrog);

        turtleGroup.add(new TurtlesB(0, calculateRow(7), TurtlesA.DEFAULT_TIME, 0, FlxObject.LEFT, actorSpeed));
        turtleGroup.add(new TurtlesB((TurtlesB.SPRITE_WIDTH + 95) * 1, calculateRow(7), -1, -1, FlxObject.LEFT, actorSpeed));
        turtleGroup.add(new TurtlesB((TurtlesB.SPRITE_WIDTH + 95) * 2, calculateRow(7), -1, -1, FlxObject.LEFT, actorSpeed));

        alligator = new Alligator((Log.TYPE_C_WIDTH + 77) * 2, calculateRow(3), FlxObject.RIGHT, actorSpeed);
        logGroup.add(alligator);

        snake = new Snake(0, calculateRow(8), FlxObject.LEFT, actorSpeed);
        add(snake);

        // Create Player
        player = new Frog(calculateColumn(6), calculateRow(14) + 6);
        add(player);

        // Create Cars
        carGroup = new FlxGroup();
        add(carGroup);

        carGroup.add(new Truck(0, calculateRow(9), FlxObject.LEFT, actorSpeed));
        carGroup.add(new Truck(270, calculateRow(9), FlxObject.LEFT, actorSpeed));

        carGroup.add(new Car(0, calculateRow(10), Car.TYPE_C, FlxObject.RIGHT, actorSpeed* 2));
        carGroup.add(new Car(270, calculateRow(10), Car.TYPE_C, FlxObject.RIGHT, actorSpeed* 2));

        carGroup.add(new Car(0, calculateRow(11), Car.TYPE_D, FlxObject.LEFT, actorSpeed));
        carGroup.add(new Car(270, calculateRow(11), Car.TYPE_D, FlxObject.LEFT, actorSpeed));


        carGroup.add(new Car(0, calculateRow(12), Car.TYPE_B, FlxObject.RIGHT, actorSpeed));
        carGroup.add(new Car((Car.SPRITE_WIDTH + 138) * 1, calculateRow(12), Car.TYPE_B, FlxObject.RIGHT, actorSpeed));
        carGroup.add(new Car((Car.SPRITE_WIDTH + 138) * 2, calculateRow(12), Car.TYPE_B, FlxObject.RIGHT, actorSpeed));

        carGroup.add(new Car(0, calculateRow(13), Car.TYPE_A, FlxObject.LEFT, actorSpeed));
        carGroup.add(new Car((Car.SPRITE_WIDTH + 138) * 1, calculateRow(13), Car.TYPE_A, FlxObject.LEFT, actorSpeed));
        carGroup.add(new Car((Car.SPRITE_WIDTH + 138) * 2, calculateRow(13), Car.TYPE_A, FlxObject.LEFT, actorSpeed));

        //var spotlights = new ZSpotLight(0xe0000000);
        //spotlights.add_to_state();
        //spotlights.add_light_target(player, 100);

        // Create Time text
        timeTxt = new FlxText(FlxG.width - 70, LIFE_Y, 60, "TIME").setFormat(null, 14, 0xffff00, "right");
        add(timeTxt);

        // Create timer graphic
        //TODO this is hacky and needs to be cleaned up
        timerBarBackground = new FlxSprite(timeTxt.x - TIMER_BAR_WIDTH + 5, LIFE_Y + 2);
        timerBarBackground.makeGraphic(TIMER_BAR_WIDTH, 16, 0xff21de00);
        add(timerBarBackground);

        timerBar = new FlxSprite(timerBarBackground.x, timerBarBackground.y);
        timerBar.makeGraphic(1, 16, 0xFF000000);
        timerBar.scrollFactor.x = timerBar.scrollFactor.y = 0;
        timerBar.origin.x = timerBar.origin.y = 0;
        timerBar.scale.x = 0;
        add(timerBar);

        touchControls = new TouchControls(this, 10, calculateRow(16) + 20, 16);
        player.touchControls = touchControls;
        add(touchControls);

        var _timer = new ZCountDown(new FlxPoint(20, 20), 1);
        add(_timer);

        gameState = GameStates.PLAYING;
        FlxG.sound.play("Theme");
        trace("Log Group: " + logGroup.length);
        trace("Turtle Group: " + turtleGroup.length);
        trace("Car Group: " + carGroup.length);
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
    function displayTextField():Void
    {
        //FlxG.addChildBelowMouse(textfield);
        var oflScaleX = Lib.current.stage.stageWidth / FlxG.width;
        var oflScaleY = Lib.current.stage.stageHeight / FlxG.height;
        var textfield = new TextField();
        var textformat = new TextFormat();
        var fontName = messageText.font;

        textformat.font = fontName;
        textformat.align = TextFormatAlign.LEFT;
        textformat.size = 32 * oflScaleY;
        textformat.color = 0xffff00;

        textfield.defaultTextFormat = textformat;

        textfield.embedFonts = true;
        //textfield.defaultTextFormat = new TextFormat(fontName, 32 * oflScaleY, 0xffffff, TextFormatAlign.CENTER);
        textfield.type = TextFieldType.INPUT;
        textfield.x = 240 * oflScaleX;
        textfield.y = calculateRow(8) * oflScaleY;
        textfield.background = true;
        textfield.backgroundColor = 0xff0000ff;
        textfield.width = 240 * oflScaleX;
        textfield.height = 40 * oflScaleY;
        textfield.border = true;
        textfield.borderColor = 0xff000000;
        
        textfield.maxChars = 9;
        textfield.autoSize = TextFieldAutoSize.LEFT;
        textfield.text = " ";
        
        //textfield.type = TextFieldType.INPUT;
        //textfield.textColor = 0x000000;
        //textfield.border = true;
        //textfield.borderColor = 0xFFFF00;
        //textfield.background = true;
        //textfield.backgroundColor = 0xFFFFFF;
        //textfield.width = 200;
        //textfield.height = 40;
        //textfield.setTextFormat(new TextFormat(null, 32));
        trace("OpenFl display width: " + Lib.current.stage.stageWidth + " display height: " + Lib.current.stage.stageHeight);

        //Mobile stuff
        #if (android || ios)
        textfield.needsSoftKeyboard = true;
                //This should work in "next" i think, but causes a compiler error legacy
        //textfield.softKeyboardInputAreaOfInterest = new Rectangle(540, 440, 200, 40);
                //This does not have any effect afaik (available on legacy only)
        textfield.moveForSoftKeyboard = true;
        #end

        FlxG.addChildBelowMouse(textfield);
        FlxG.stage.focus = textfield;
        textfield.setSelection(0, textfield.text.length);
        textfield.visible = true;
        

        //add(textfield);

        var submitButton = new FlxButton(0, 0, "OK", function() {
            //trace("Text is " + inputText.text);
            trace("TextField is " + textfield.text);
            FlxG.removeChild(textfield);
            var scoreState:ScoreState = new ScoreState();
            scoreState.playerData.name = textfield.text;
            scoreState.playerData.score = Reg.score = 1100;
            FlxG.switchState(scoreState);
        });
        submitButton.makeGraphic(Std.int(40.0 * oflScaleX), Std.int(40.0 * oflScaleY), FlxColor.BLACK);
        //submitButton.color = 0x0000ff;
        submitButton.label.color = 0xffffff;
        submitButton.label.setFormat(null, 18, 0xffffff, "center");
        //submitButton.width = 40;
        //submitButton.height = 40;
        //submitButton.setSize(40 * oflScaleY, 40 * oflScaleY);
        submitButton.x = 400 * oflScaleX;
        //submitButton.y = calculateRow(8);
        enterUserNameGroup.add(submitButton);
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
                    enterUserNameGroup.visible = true;
                    displayTextField();
                }
                    //displayTextField();
                //FlxG.switchState(new ScoreState());
                //FlxG.state = new ScoreState();
            } else
            {
                hideGameMessageDelay -= 1;
                trace("HideGameMessageDelay: " + hideGameMessageDelay);
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
            // Reset floating flag for the player.
            playerIsFloating = false;

            // Do collision detections
            FlxG.overlap(carGroup, player, carCollision);
            FlxG.overlap(logGroup, player, float);
            FlxG.overlap(turtleGroup, player, turtleFloat);
            FlxG.overlap(homeBaseGroup, player, baseCollision);
            FlxG.overlap(snake, player, carCollision);

            // If nothing has collided with the player, test to see if they are out of bounds when in the water zone
            if (player.y < waterY)
            {
                //TODO this can be cleaned up better
                if (!player.isMoving && !playerIsFloating)
                    waterCollision();

                if ((player.x > FlxG.width) || (player.x < -TILE_SIZE ))
                {
                    waterCollision();
                }

            }

            // This checks to see if time has run out. If not we decrease time based on what has elapsed
            // sine the last update.
            if (timer == 0 && gameState == GameStates.PLAYING)
            {
                timeUp();
            } else
            {
                timer -= Std.int(100 * elapsed);
                timerBar.scale.x = TIMER_BAR_WIDTH - Math.round((timer / gameTime * TIMER_BAR_WIDTH));

                if (timerBar.scale.x == timeAlmostOverWarning && !timeAlmostOverFlag)
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
                gameMessageGroup.visible = false;
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

            if(lifeSprites.length < 5)
            {
                addLife();
                lastLifeScore = Reg.score;

                messageText.text = "1-UP";
                gameMessageGroup.visible = true;
                hideGameMessageDelay = 200;
            }
        }
        // Update the entire game
        super.update(elapsed);
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
            FlxG.sound.play("Squash");
            killPlayer(false);
        }
    }
    private function baseCollision(target:Home, player:Frog):Void
    {
        var timeLeftOver:Int = Math.round(timer / FlxG.updateFramerate);
        trace("Base Collision Mode:" + target.mode + "TimeLeftOver: " + timeLeftOver);

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
        trace("Safe frogs:" + safeFrogs + "Group:" + homeBaseGroup.length);


        // Reguardless if the base was empty or occupied we still display the time it took to get there
        messageText.text = "TIME " + Std.string(gameTime / FlxG.updateFramerate - timeLeftOver);
        gameMessageGroup.visible = true;
        hideGameMessageDelay = 200;

        // Test to see if we have all the frogs, if so then level has been completed. If not restart.
        if (safeFrogs == homeBaseGroup.length)
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
        if (get_totalLives() == 0 && gameState != GameStates.GAME_OVER)
        {
            gameOver();
        } else
        {
            // Test to see if Level is over, if so reset all the bases.
            if (gameState == GameStates.LEVEL_OVER)
                resetBases();
            //FlxG.level ++;
            Reg.level++;
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
        // Loop though bases and empty them
        //var base:Home;
        /*for (base in bases)
        {
            trace("base", base);
            base.empty();
        }*/
        homeBaseGroup.forEach(function(base:Home)
        {
            trace("base:", base);
            base.empty();
        });
            // Reset safe frogs
        safeFrogs = 0;

            // Set message to tell player they can restart
        messageText.text = "START";
        gameMessageGroup.visible = true;
        hideGameMessageDelay = 200;
    }
    private function killPlayer(isWater:Bool):Void
    {
        //commented just test home collision
        gameState = GameStates.COLLISION;
        removeLife();
        player.death(isWater);
        hideGameMessageDelay = 30;
    }
    private function gameOver():Void
    {
        gameState = GameStates.GAME_OVER;

        gameMessageGroup.visible = true;

        messageText.text = "GAME OVER";

        hideGameMessageDelay = 100;

        //TODO there is a Game Over sound I need to play here
    }
    /**
         * This loop creates X number of lives.
         * @param value number of lives to create
         */
    private function createLives(value:Int):Void
    {
        var i:Int;
        for (i in 0...value)
            addLife();
    }
    /**
         * This adds a life sprite to the display and pushes it to teh lifeSprites array.
         * @param value
         */
    private function addLife():Void
    {
        var flxLife:FlxSprite = new FlxSprite(LIFE_X * get_totalLives() + 10, LIFE_Y, AssetPaths.lives__png);
        add(flxLife);
        lifeSprites.push(flxLife);
    }
    private function removeLife():Void
    {
        var id:Int = get_totalLives() - 1;
        var sprite:FlxSprite = lifeSprites[id];
        sprite.kill();
        lifeSprites.splice(id, 1);
    }
    /**
         * A simple getter for Total Lives based on life sprite instances in lifeSprites array.
         * @return
         */
    private function get_totalLives():Int
    {
        return lifeSprites.length;
    }
}
