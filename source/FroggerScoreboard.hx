package ;
import cpp.Object;
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
            var defaultScores:Array<Object> = [
            {initials:"GLC", score: 860630},
            {initials:"BUM", score: 10000},
            {initials:"SWF", score: 5000},
            {initials:"AS3", score: 1500},
            {initials:"AIR", score: 1000}
            ];

            set_scores(defaultScores);
        }
        for(val in _scores)
            trace(val.score);



    }
}
