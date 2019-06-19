package game.ui;

import gui.UIState;
import gui.MainStage;
import gui.widgets.Frame;

class UIMainState extends UIState
{
    public function new(mainStage:MainStage)
    {
        super(mainStage);
    }

    override public function ProcessCallback(event:UIEventType, sender:Frame, name:String,  params:Array<Dynamic>) 
    {
        if (name == "onMouseOver")
        {
            var param = cast(params[0], String); 
            trace("onMouseOver", param);
        }
    }
    
}