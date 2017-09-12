package ;
//import cpp.Object;
import flixel.util.FlxSave;
//import flash.net.SharedObject;
typedef User_Score = {
    var score : Int;
    var name : String;
}
class FScoreboard
{

    public static inline var ERROR_MESSAGE_NO_SCORE_PROP:String = "Supplied object does not have a score property.";
    //var so:SharedObject;
    var _scores:Array<User_Score>;
    var id:String;
    var maxScores:Int;
    private var _gameSave:FlxSave;

    /**
         * This is a simple proxy to wrap a SharedObject which stores and array of score objects.
         * Simply create a new instance of the Scoreboard and it will automatically create
         * or load the SharedObject associated with the supplied ID.
         *
         * @param id a unique ID used to store and retrieve the Scoreboard shared Object.
         * @param maxScores this is the maximum number of scores you want to keep track of. By
         *        default it is set to -1 which means it will not truncate the scores.

         */
    public function new(id:String, maxScores:Int = -1)
    {
        this.maxScores = maxScores <= 0 ? -1 : maxScores;
        this.id = id;
        _gameSave = new FlxSave();
        _gameSave.bind(id);
        //_scores = new Array<Object>();
        init();
    }

    /**
         * Add a Score object to the Scoreboard. Your object can have any properties but it should
         * have a score property at the very least. If the supplied object does not have a score
         * property it will throw an error.
         *
         * @param value Object with a score property on it.
         */
    public function addScore(value:User_Score):Void
    {
        //if (!value.hasOwnProperty("score"))
        //    throw new Error(ERROR_MESSAGE_NO_SCORE_PROP);
        //if(!Reflect.hasField(value, "score"))
        //    trace(ERROR_MESSAGE_NO_SCORE_PROP);

        _scores.push(value);

        _scores.sort(sortOnValue);

        saveToSharedObject((maxScores > -1) ? _scores.slice(0, maxScores) : _scores);

        loadSharedObject();

    }

    /**
         * Returns a copy of the scores array.
         *
         * @return a copy of the scores array. This may not be the same values stored in the SharedObject.
         */
    public function get_scores():Array<User_Score>
    {
        return _scores;
    }

    /**
         * scores allows you to pass in an array of scores which can be used to populate the
         * Scoreboard. If this is not supplied the default value (assuming you have
         * never instantiated the SharedObject) will be an empty array. Use this when you
         * want to populate your game with a set number of high scores the first time it
         * is ever loaded up. An ideal use case would be to create a new instance of the
         * Scoreboard then check to see if it's total is 0. If it is, pass in a set of
         * default values.
         *
         * @param value an array of score objects. At the min, the score object should have
         *        a property for score.
         */
    public function set_scores(value:Array<User_Score>):Void
    {
        //validateScoreObjects(value);

        saveToSharedObject(value);
        loadSharedObject();
    }

    /**
         *
         * Clears the values from the SharedObject's scores array.
         *
         */
    public function clearScoreboard():Void
    {
        //so = SharedObject.getLocal(id);
        //so.data.localScoreboard.length = _scores.length = 0
        _gameSave.data.localScoreboard = null;
        _gameSave.flush();
    }

    /**
         * Makes sure you can actually submit a score before you try to do it. Use this
         * to see if the score is worth saving.
         *
         * @param value score value
         * @return returns true if it would be saved or false if it was not high enough.
         */
    public function canSubmitScore(value:User_Score):Bool
    {
        var result:Int;

        var total:Int = get_scores().length;
        var i:Int;

        //for (i = 0; i < total; i++)
        for (i in 0...total)
        {
            result = sortOnValue(value, get_scores()[i]);

            if (result == -1 || result == 0)
                return true;
        }
        return false;
    }

    /**
         * Returns the total number of scores in the Scoreboard
         *
         * @return totals scores
         */
    public function get_total():Int
    {
        return _scores.length;
    }

    /**
         * Allows you to get a score at a particular position in the Scoreboard.
         * @param i the index of the score you are trying to retrieve.
         * @return the score object.
         */
    public function getScore(i:Int):User_Score
    {
        return _scores[i];
    }

    /**
         *
         * @param defaultsScores
         */
    private function init():Void
    {
        /*so = SharedObject.getLocal(id);
        if (so.data.localScoreboard == null)
        {
            saveToSharedObject(_scores);
        }
        loadSharedObject();*/
        if(_gameSave.data.localScoreboard == null)
        {
            saveToSharedObject(_scores);
        }
        loadSharedObject();
    }

    /**
             *
             */
    private function loadSharedObject():Void
    {
        //_scores = so.data.localScoreboard.slice();
        _scores = _gameSave.data.localScoreboard;
    }

    /**
             *
             * @param value
             */
    private function saveToSharedObject(value:Array<User_Score>):Void
    {
        //so.data.localScoreboard = value;
        //so.flush();
        _gameSave.data.localScoreboard = value;
        _gameSave.flush();
    }

    /**
         *
         * @param val1
         * @param val2
         * @return
         */
    private function sortOnValue(val1:User_Score, val2:User_Score):Int
    {

        var score1:Int = val1.score;
        var score2:Int = val2.score;

        if (score1 > score2)
        {
            return -1;
        }
        else if (score1 < score2)
        {
            return 1;
        }
        else
        {
            //they are the same
            return 0;
        }
    }

    /**
         *
         * @param values
         */
    private function validateScoreObjects(values:Array<User_Score>):Void
    {
        //for each(var score:Object in values)
        for(value in values)
        {
        //if (!score.hasOwnProperty("score"))
        //throw new Error(ERROR_MESSAGE_NO_SCORE_PROP);
            //if(!Reflect.hasField(value, "score"))
            //    trace(ERROR_MESSAGE_NO_SCORE_PROP);
        }
    }

}
