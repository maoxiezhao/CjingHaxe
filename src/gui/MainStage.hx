package gui;

import gui.UILoader;
import gui.UIState;
import gui.widgets.Frame;
import gui.widgets.WidgetFactory;

// TODO 
// will support layout
class MainStage
{
    private var mRootLayer:h2d.Layers;
    private var mRootFrame:Frame;
    private var mUILoader:gui.UILoader;
    private var mUIInstanceMap:Map<String, UIState>;
    private var mUIInstanceStack:Array<UIState>;

    public function new(s2d:h2d.Scene)
    {
        var screenSize = helper.System.GetScreenSize();

        mRootFrame = new Frame();
        mRootFrame.SetName("Root");
        mRootFrame.getBounds().set(0, 0, screenSize.x, screenSize.y);
        s2d.add(mRootFrame, 10);

        WidgetFactory.Initialize();

        mUIInstanceMap = new Map();
        mUIInstanceStack = new Array();

        InitDefaultUI();
    }

    public function Dispose()
    {
        mUIInstanceMap = null;
        mUIInstanceStack = null;
    }

    public function InitDefaultUI()
    {
        mUILoader = new UILoader(this);

        // parse templates
        mUILoader.ParseUIXML("templates/templates.xml");

        LoadDefaultUI();
    }

    public function LoadDefaultUI()
    {

    }

    public function LoadUIInstance(inst:UIState, zOrder:Float)
    {
        
    }

    public function GetRootFrame() { return mRootFrame;}

    public function Update(dt:Float)
    {

    }
}