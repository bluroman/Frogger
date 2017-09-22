package ;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.FlxState;
class BaseState extends FlxState
{
    var scoreboard:FroggerScoreboard;
    var scoreTxt:FlxText;
    var highscoreLabel:FlxText;
    var highscoreTxt:FlxText;
    var scoreLabel:FlxText;
    var levelLabel:FlxText;
    var levelTxt:FlxText;
    var background:FlxSprite;
    var _topScoreBoard:FlxTypedSpriteGroup<FlxSprite>;

    public function new()
    {
        super();
        _topScoreBoard = new FlxTypedSpriteGroup<FlxSprite>();

    }

    override public function create():Void
    {
        super.create();

        scoreboard = new FroggerScoreboard();

        background = new FlxSprite();
        background.makeGraphic(FlxG.width, 80, 0x80000047);
        _topScoreBoard.add(background);

        trace("0th score:"+ scoreboard.getScore(0).score);

        // Create Text for title, credits, and score
        highscoreLabel = new FlxText((FlxG.width - 200) * .5, 0, 200, "HI-SCORE").setFormat(null, 18, 0xffffff, "center");
        highscoreTxt = new FlxText(highscoreLabel.x, highscoreLabel.y + highscoreLabel.height, 200, Std.string(scoreboard.getScore(0).score)).setFormat(null, 18, 0xffe00000, "center");
        scoreLabel = new FlxText(50, 0, 100, "Score").setFormat(null, 18, 0xffffff, "right");
        scoreTxt = new FlxText(0, scoreLabel.height, 150, Std.string(Reg.score)).setFormat(null, 18, 0xffe00000, "right");
        levelLabel = new FlxText(480 - 170, 0, 100, "Level").setFormat(null, 18, 0xffffff, "right");
        levelTxt = new FlxText(levelLabel.x - 50 , levelLabel.height, 150, Std.string(Reg.level)).setFormat(null, 18, 0xffe00000, "right");

        _topScoreBoard.add(highscoreLabel);
        _topScoreBoard.add(highscoreTxt);
        _topScoreBoard.add(scoreLabel);
        _topScoreBoard.add(scoreTxt);
        _topScoreBoard.add(levelLabel);
        _topScoreBoard.add(levelTxt);

        add(_topScoreBoard);

        _topScoreBoard.forEach(function(spr:FlxSprite)
        {
            spr.scrollFactor.set(0, 0);
        });

    }

}
