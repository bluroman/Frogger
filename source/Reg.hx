package;

/**
 * Handy, pre-built Registry class that can be used to store 
 * references to objects and other things for quick-access. Feel
 * free to simply ignore it or change it in any way you like.
 */
import FScoreboard.User_Score;

class Reg
{
	/**
	 * Generic scores Array that can be used for cross-state stuff.
	 * Example usage: Storing the scores for level.
	 */
	public static var scores:Array<User_Score> = [];

	/**
	 * Generic score variable that can be used for cross-state stuff.
	 * Example usage: Storing the current score.
	 */
	public static var score:Int = 0;

	public static var level:Int = 0;
	public static var playCount:Int = 0;
	public static var PS:PlayState;

	/**
	 * default game time (sec)
	**/
	public static var defaultTime:Int = 45;

	public static inline var TIMER_BAR_WIDTH = 300;
	public static inline var GPG_LEADERBOARD:String = "CgkIzdyhmLQOEAIQAg";
	public static inline var BANNER_ID_IOS:String = "ca-app-pub-6964194614288140/7785218114";
	public static inline var BANNER_ID_ANDROID:String = "ca-app-pub-6964194614288140/8538635264";
	public static inline var INTERSTITIAL_ID_IOS:String = "ca-app-pub-6964194614288140/8331302582";
	public static inline var INTERSTITIAL_ID_ANDROID:String = "ca-app-pub-6964194614288140/8511587241";
	public static inline var REWARDED_ID_IOS:String = "ca-app-pub-6964194614288140/4643184958";
	public static inline var REWARDED_ID_ANDROID:String = "ca-app-pub-6964194614288140/9633097226";
}
