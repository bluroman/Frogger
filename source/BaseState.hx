package ;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.FlxState;
class BaseState extends FlxState
{
    var scoreboard:FroggerScoreboard;
    var scoreTxt:FlxText;

    public function new()
    {
        super();
    }

    override public function create():Void
    {
        super.create();

        scoreboard = new FroggerScoreboard();

        var sprite:FlxSprite = new FlxSprite();
        sprite.makeGraphic(FlxG.width, 350, 0xff000047);
        add(sprite);

        trace("0th score:"+ scoreboard.getScore(0).score);

        // Create Text for title, credits, and score
        var demoTXT:FlxText = new FlxText((FlxG.width - 200) * .5, 0, 200, "HI-SCORE").setFormat(null, 18, 0xffffff, "center");
        var highScore:FlxText = new FlxText(demoTXT.x, demoTXT.y + demoTXT.height, 200, Std.string(scoreboard.getScore(0).score)).setFormat(null, 18, 0xffe00000, "center");
        var scoreLabel:FlxText = new FlxText(demoTXT.x - 100, 0, 100, "Score").setFormat(null, 18, 0xffffff, "right");
        scoreTxt = new FlxText(scoreLabel.x - 50, scoreLabel.height, 150, Std.string(Reg.score)).setFormat(null, 18, 0xffe00000, "right");
        add(demoTXT);
        add(highScore);
        add(scoreLabel);
        add(scoreTxt);

        //var demoTXT:FlxText = add(new FlxText((FlxG.width - 200) * .5, 0, 200, "HI-SCORE").setFormat(null, 18, 0xffffff, "center")) as FlxText;
        //var highScore:FlxText = add(new FlxText(demoTXT.x, demoTXT.y + demoTXT.height, 200, scoreboard.getScore(0).score).setFormat(null, 18, 0xffe00000, "center")) as FlxText;
        //var scoreLabel:FlxText = add(new FlxText(demoTXT.x - 100, 0, 100, "Score").setFormat(null, 18, 0xffffff, "right")) as FlxText;
        //scoreTxt = add(new FlxText(scoreLabel.x - 50, scoreLabel.height, 150, FlxG.score.toString()).setFormat(null, 18, 0xffe00000, "right")) as FlxText;
    }

}
