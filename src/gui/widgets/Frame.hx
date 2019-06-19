package gui.widgets;

import hxd.Cursor;
import haxe.xml.Access;
import h2d.Object;
import h2d.Sprite;
import gui.XMLHelper;
import gui.Signal;
import gui.UIState;

enum UIEventType
{
    UIEventType_OnCreated;
    UIEventType_OnDisposed;
    UIEventType_MouseOver;
    UIEventType_MouseOut;
    UIEventType_MouseClick;
}

typedef UIEventParams = {
    name:String,
    event:UIEventType,
    params:Array<Dynamic>
}

class Frame extends h2d.Sprite
{
    private var mName:String;
    private var mFrameChild:Array<Frame>;
    private var mGraphics:h2d.Graphics;
    private var mInteraction:h2d.Interactive;
    private var mEventParamsMap:Map<UIEventType, UIEventParams>;
    private var mCurrentState:UIState;

    public function new()
    {
        super();
        mGraphics = new h2d.Graphics(this);
        mInteraction = new h2d.Interactive(0, 0, this);
        mInteraction.cursor = Cursor.Default;

        mEventParamsMap = new Map();
        mFrameChild = new Array();
    }

    public function Initialize()
    {
        FireEvent(UIEventType_OnCreated);
    }

    public function Dispose()
    {
        mFrameChild = null;

        for (child in children)
        {
            var childFrame:Frame = cast(child, Frame);
            if (childFrame != null)
            {
                childFrame.Dispose();
            }
        }

        FireEvent(UIEventType_OnDisposed);
        
        removeChildren();
    }

    private function FireEventImpl(event:UIEventType, params:UIEventParams)
    {
        if (mCurrentState != null)
        {
            mCurrentState.ProcessCallback(event, this, params.name, params.params);
        }
    }

    public function FireEvent(event:UIEventType)
    {
        var eventParams = mEventParamsMap.get(event);
        if (eventParams != null)
        {
            FireEventImpl(event, eventParams);
        }
    }

    public function RegisterEvent(eventType:UIEventType, params:UIEventParams)
    {
        mEventParamsMap.set(eventType, params);
    }

    public function Update(dt:Float) {}
    public function SetName(name:String) { mName = name; }
    public function GetName() { return mName;}
    public function SetCurrentStage(state:UIState) 
    {
        mCurrentState =  state;
        for (child in mFrameChild)
        {
            child.SetCurrentStage(state);
        }
    }
    
    public function SetSize(width:Int, height:Int)
    {
        mInteraction.width = width;
        mInteraction.height = height;

        for (child in mFrameChild)
        {
            child.SetSize(width, height);
        }
    }

    public function addFrameChild( s : Frame ) : Void {
		this.addChild(s);
        mFrameChild.push(s);
	}
}