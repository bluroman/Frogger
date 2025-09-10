import extension.admob.Admob;
import flixel.addons.ui.FlxUIPopup;

class Popup_Demo extends FlxUIPopup
{
	var _parentState1:PlayState = null;

	override public function create():Void
	{
		_xml_id = "popup_demo";
		_parentState1 = cast(_parentState, PlayState);
		super.create();
		_ui.setMode("demo_0");
	}

	override public function getEvent(id:String, target:Dynamic, data:Dynamic, ?params:Array<Dynamic>):Void
	{
		if (params != null && params.length > 0)
		{
			if (id == "click_button")
			{
				var i:Int = cast params[0];
				if (_ui.currMode == "demo_0")
				{
					switch (i)
					{
						case 0:
							// openSubState(new Popup_Simple());
							Admob.showRewarded();
						// close();
						case 1:
							// _ui.setMode("demo_1");
							_parentState1.restart();
							close();
						case 2:
							close();
					}
				}
				else if (_ui.currMode == "demo_1")
				{
					switch (i)
					{
						case 0:
							_ui.setMode("demo_0");
						case 1:
							close();
					}
				}
			}
		}
	}
}
