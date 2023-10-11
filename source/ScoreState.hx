package;

import FScoreboard.User_Score;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
// using cpp.Object;
#if ADS
import extension.admob.Admob;
import extension.admob.AdmobEvent;
// import extension.admob.GravityMode;
#end
#if GPG
import extension.gpg.GooglePlayGames;
#end

class ScoreState extends BaseState
{
	private var scores:Array<User_Score>;
	private var highScored:Bool = false;
	private var newScore:User_Score = {score: 0, name: ""};
	private var newScorePosition:Int = -1;

	private var whichInitial:Int = 0; // the index of the initial being input, 0 through 2
	private var whichLetter:Int = 1; // what the current letter is, 0 through 26

	private var leftArrow:FlxText;
	private var rightArrow:FlxText;
	private var upArrow:FlxText;
	private var downArrow:FlxText;

	private var newInitials:Array<FlxText>;
	private var letterPreview:FlxText;
	private var timer:FlxTimer;

	var playerScore:Int = Reg.score;
	var xpos:Float;
	var i:Int;
	var totalScores:Int = FroggerScoreboard.MAX_SCORES;

	var textItem:FlxText;
	var score:User_Score;

	public var playerData:User_Score = {score: 0, name: ""};

	private var _btnMainMenu:FlxButton; // button to go to main menu
	private var _btnLeaderboadrdMenu:FlxButton;

	override public function create():Void
	{
		super.create();

		// FlxG.mouse.show();
		// if (FlxG.sound.music == null) // don't restart the music if it's alredy playing
		// {
		FlxG.sound.playMusic("Score", 1, true);
		// }

		scores = scoreboard.get_scores();

		newInitials = [];
		// playerData.score = playerScore;
		// playerData.name = "Hoon";

		highScored = scoreboard.canSubmitScore(playerData);

		textItem = new FlxText(0, FlxG.height / 7, FlxG.width, "SCORE RANKING");
		textItem.setFormat(null, 15, 0xd8d94a, "center", 0);
		add(textItem);

		// find out if score can be inserted at the beginning
		if (scores[0] == null)
		{
			// score = {score:Reg.score, name:""};
			score = playerData;
			scores.push(score);
			newScore = score;
			highScored = true;
			newScorePosition = 0;
		}

		// first loop: find out if score can be inserted in middle
		// for (i = 0; i < totalScores; i++)
		for (i in 0...totalScores)
		{
			score = scores[i];
			trace("score: " + score.score + " name: " + score.name);
			/*if (highScored)
					break;
				else */
			if (score.score <= Reg.score)
			{
				// score = {score:Reg.score, name:""};
				score = playerData;
				newScorePosition = i;
				// scores.splice(i, 0, score);
				scores.insert(i, score);
				if (totalScores > 10)
					scores.pop();
				highScored = true;
				newScore = score;
				break;
			}
		}

		// find out if score can be inserted at end
		if (!highScored && totalScores < FroggerScoreboard.MAX_SCORES)
		{
			// score = {score:Reg.score, name:""};
			score = playerData;
			scores.push(score);
			newScorePosition = totalScores - 1;
			highScored = true;
			newScore = score;
		}

		var ypos:Float = textItem.getPosition().y + textItem.height + 20;

		// second loop lay out the current high scores.
		// for (i = 0; i < totalScores; i++)
		for (i in 0...totalScores)
		{
			var scoreObj:User_Score = scores[i];
			// display the current score.
			// index

			var color:UInt = (i == newScorePosition) ? 0xc83fbb : 0xffffff;

			textItem = new FlxText(140, ypos, 25, Std.string(i + 1));
			textItem.setFormat(null, 15, color, "left", 0);
			add(textItem);

			xpos = textItem.getPosition().x + 20;

			// initials - loop to position each separately.
			// for (var j:Number = 0; j < 3; j++)
			for (j in 0...4)
			{
				textItem = new FlxText(xpos, ypos, 15, scoreObj.name.charAt(j));
				// new high score text gets colored red.
				if (i == newScorePosition)
				{
					textItem.setFormat(null, 15, color, "center", 0);
					newInitials.push(textItem);
				}
				else
					textItem.setFormat(null, 15, color, "center", 0);
				add(textItem);

				xpos += 20;
			}

			// score
			textItem = new FlxText(xpos, ypos, 100, Std.string(scoreObj.score));
			textItem.setFormat(null, 15, color, "right", 0);
			add(textItem);
			ypos += 20;
		}
		_btnMainMenu = new FlxButton(0, 0, "Main Menu", goMainMenu);
		_btnMainMenu.loadGraphic("assets/images/button01.png", 120, 36);
		_btnMainMenu.screenCenter();
		_btnMainMenu.onUp.sound = FlxG.sound.load("Click");
		_btnMainMenu.label.setFormat(null, 15, FlxColor.WHITE, "center");
		add(_btnMainMenu);
		#if mobile
		_btnLeaderboadrdMenu = new FlxButton(0, 0, "Leaderboard", goLeaderboard);
		_btnLeaderboadrdMenu.loadGraphic("assets/images/button02.png", 150, 40);
		_btnLeaderboadrdMenu.screenCenter();
		_btnLeaderboadrdMenu.y += 80;
		_btnLeaderboadrdMenu.onUp.sound = FlxG.sound.load("Click");
		_btnLeaderboadrdMenu.label.setFormat(null, 18, FlxColor.WHITE, "center");
		add(_btnLeaderboadrdMenu);
		#end
		if (highScored)
		{
			/*letterPreview = new FlxText((FlxG.width - 100 ) * .5, 500, 100, "_");
				letterPreview.setFormat(null, 70, 0xc83fbb, "center", 0);
				add(letterPreview);

					//add in arrows for displaying position and possible motions
				leftArrow = new FlxText(letterPreview.x - 50, letterPreview.y + 10, 50, " ");
				leftArrow.setFormat(null, 60, 0xc83fbb, "right", 0);
				add(leftArrow);

				rightArrow = new FlxText(letterPreview.x + letterPreview.width, letterPreview.y + 10, 200, " ");
				rightArrow.setFormat(null, 60, 0xc83fbb, "left", 0);
				add(rightArrow);

				upArrow = new FlxText(letterPreview.x, letterPreview.y - 60, 100, "+");
				upArrow.setFormat(null, 60, 0xc83fbb, "center", 0);
				add(upArrow);

				downArrow = new FlxText(letterPreview.x, letterPreview.y + letterPreview.height - 30, 100, "-");
				downArrow.setFormat(null, 60, 0xc83fbb, "center", 0);
				add(downArrow);


				textItem = new FlxText(0, upArrow.x - 30, FlxG.width, "ENTER YOUR INITIALS");
				textItem.setFormat(null, 15, 0xc83fbb, "center", 0);
				add(textItem);

				textItem = new FlxText(0, downArrow.x + downArrow.height, FlxG.width, "USE JOYSTICK TO SELECT LETTER");
				textItem.setFormat(null, 15, 0xc83fbb, "center", 0);
				add(textItem); */
		}
		else
		{
			// timer = new Timer(6000, 1);
			// timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
			// timer.start();

			// timer = new FlxTimer().start(10.0, onTimerComplete, 1);
		}
		#if ADS
		Admob.status.addEventListener(AdmobEvent.INTERSTITIAL_LOADED, onInterstitialLoadedEvent);
		Admob.status.addEventListener(AdmobEvent.INTERSTITIAL_DISMISSED, onInterstitialDismissedEvent);

		// AdMob.onInterstitialEvent = onInterstitialEvent;
		trace("##################Load Interstitial#################");

		// if (Reg.playCount % 2 == 1)
		// AdMob.showInterstitial(0);
		if (Reg.playCount % 2 == 1)
			Admob.loadInterstitial(Reg.INTERSTITIAL_ID_ANDROID);
		#end
	}

	#if ADS
	function onInterstitialLoadedEvent(event:String)
	{
		trace("The Interstitial Event is " + event);
		Admob.showInterstitial();
	}

	function onInterstitialDismissedEvent(event:String)
	{
		trace("The Interstitial Event is " + event);
	}
	#end

	override public function destroy():Void
	{
		trace("$$$$$$Destroy Called$$$$$$$$$$$");
		#if ADS
		Admob.status.removeEventListener(AdmobEvent.INTERSTITIAL_LOADED, onInterstitialLoadedEvent);
		Admob.status.removeEventListener(AdmobEvent.INTERSTITIAL_DISMISSED, onInterstitialDismissedEvent);
		#end
		super.destroy();
	}

	private function onTimerComplete(event:FlxTimer):Void
	{
		// FlxG.state = new MenuState();
		goMainMenu();
	}

	private function goMainMenu():Void
	{
		FlxG.camera.fade(FlxColor.BLACK, .33, false, function()
		{
			FlxG.switchState(new MenuState());
		});
	}

	private function goLeaderboard()
	{
		trace("Display Leaderboard");
		// GooglePlayGames.getPlayerScore(Reg.GPG_LEADERBOARD);
		#if mobile
		#if GPG
		GooglePlayGames.displayScoreboard(Reg.GPG_LEADERBOARD);
		#end
		#end
	}

	override public function update(elapsed:Float):Void
	{
		#if (desktop && mobile)
		if (highScored)
		{
			var str:String = newScore.name;

			var clkX:Float = FlxG.mouse.x;
			var clkY:Float = FlxG.mouse.y;

			// figure out what motion needs to be done
			var letterUp:Bool = FlxG.keys.anyPressed([UP])
				|| (FlxG.mouse.justPressed
					&& clkY < letterPreview.y
					&& clkX > letterPreview.x
					&& clkX < letterPreview.x + letterPreview.width);
			var letterDown:Bool = FlxG.keys.anyPressed([DOWN])
				|| (FlxG.mouse.justPressed
					&& clkY > letterPreview.y + letterPreview.height
					&& clkX > letterPreview.x
					&& clkX < letterPreview.x + letterPreview.width);
			var letterLeft:Bool = whichInitial > 0 && (FlxG.keys.anyPressed([LEFT]) || (FlxG.mouse.justPressed && clkX < letterPreview.x));
			var letterRight:Bool = whichInitial < 2
				&& (FlxG.keys.anyPressed([RIGHT])
					|| FlxG.keys.anyPressed([ENTER])
					|| (FlxG.mouse.justPressed && clkX > letterPreview.x + letterPreview.width));
			var doneEdit:Bool = whichInitial == 2
				&& (FlxG.keys.anyPressed([ENTER]) || (FlxG.mouse.justPressed && clkX > letterPreview.x + letterPreview.width));

			// perform said motions
			if (letterUp)
				whichLetter = (whichLetter + 1) % 27;
			else if (letterDown)
				whichLetter = (whichLetter + 26) % 27;
			else if (letterLeft)
			{
				whichInitial--;
				whichLetter = str.charCodeAt(whichInitial) - 64;
				if (whichLetter < 0)
					whichLetter = 1;
			}
			else if (letterRight)
			{
				whichInitial++;
				whichLetter = str.charCodeAt(whichInitial) - 64;
				if (whichLetter < 0)
					whichLetter = 1;
			}
			else if (doneEdit)
			{
				// scoreboard.scores = scores;
				scoreboard.set_scores(scores);
				// FlxG.state = new MenuState();
				FlxG.switchState(new MenuState());
			}

			// update the arrows.
			leftArrow.text = "<";
			rightArrow.text = ">";

			if (whichInitial == 0)
				leftArrow.text = " ";
			else if (whichInitial == 2)
				rightArrow.text = "OK";

			// update the string.
			var arr:Array<Int> = new Array<Int>();
			// for (var i:Number = 0; i < 3; i++)
			for (i in 0...3)
			{
				if (i >= str.length)
					arr[i] = 32;
				else
					arr[i] = str.charCodeAt(i);
			}
			if (whichLetter == 0)
				arr[whichInitial] = 32; // space
			else
				arr[whichInitial] = 64 + whichLetter; // some uppercase letter

			// str = String.fromCharCode(arr[0], arr[1], arr[2]);
			str = String.fromCharCode(arr[0]);
			newScore.name = str; // store the string
			// for (i = 0; i < 3; i++)
			for (i in 0...3)
			{
				// update the display
				newInitials[i].text = str.charAt(i);
			}

			// letterPreview.text = String.fromCharCode(arr[whichInitial]);
			letterPreview.text = String.fromCharCode(arr[whichInitial]);
		}
		else if (FlxG.keys.anyPressed([ENTER]) || FlxG.mouse.justPressed) // no new highscore.
		#end
		{
			// if (timer.active)
			//    timer.cancel();

			// scoreboard.scores = scores;
			scoreboard.set_scores(scores);
			// For Test by hoon
			// FlxG.switchState(new MenuState());
			// FlxG.state = new MenuState();
		}
		super.update(elapsed);
	}
}
