package ;
//import cpp.Object;
import FScoreboard.User_Score;
class FroggerScoreboard extends FScoreboard
{
    public static inline var ID:String = "FlxFroggerScoreboard";
    public static inline var MAX_SCORES:Int = 10;

    public function new()
    {
        super(ID, MAX_SCORES);

        //TODO need to remove this is just for testing
        //clearScoreboard();

        if (_scores == null)
        {
            var defaultScores:Array<User_Score> = [
            {score:5000, name:"COM1"},
            {score:4000, name:"COM2"},
            {score:3000, name:"COM3"},
            {score:1500, name:"COM4"},
            {score:1000, name:"ROM1"},
            {score:1000, name:"ROM2"},
            {score:1000, name:"ROM3"},
            {score:1000, name:"ROM4"},
            {score:1000, name:"ROM5"},
            {score:1000, name:"ROM6"}
            ];

            set_scores(defaultScores);
        }
        //for(val in _scores)
        //    trace(val.score);



    }
}
