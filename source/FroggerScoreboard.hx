package ;
//import cpp.Object;
import FScoreboard.User_Score;
class FroggerScoreboard extends FScoreboard
{
    public static inline var ID:String = "FlxFroggerScoreboard";
    public static inline var MAX_SCORES:Int = 5;

    public function new()
    {
        super(ID, MAX_SCORES);

        //TODO need to remove this is just for testing
        clearScoreboard();

        if (_scores == null)
        {
            var defaultScores:Array<User_Score> = [
            {score:860630, name:"GLC"},
            {score:10000, name:"PRO"},
            {score:5000, name:"AMA"},
            {score:1500, name:"BLU"},
            {score:1000, name:"ROM"}
            ];

            set_scores(defaultScores);
        }
        //for(val in _scores)
        //    trace(val.score);



    }
}
