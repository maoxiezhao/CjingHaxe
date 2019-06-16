package gui;

import h2d.Interactive;
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

    private var mUIInstanceArray:Array<UIState>;
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
        mUIInstanceArray = new Array();
        mUIInstanceStack = new Array();

        InitDefaultUI();
    }

    public function Dispose()
    {
        for (uiState in mUIInstanceArray){
            uiState.Dispose();
        }
        mUIInstanceArray = null;
        mUIInstanceMap = null;
        mUIInstanceStack = null;
    }

    public function InitDefaultUI()
    {
        mUILoader = new UILoader(this);

        // parse templates
        mUILoader.ParseUIXML("templates/templates.xml");

        LoadDefaultUIStates();
    }

    public function LoadDefaultUIStates()
    {
        LoadUIInstance("ui/main.xml", "main");
    }

    public function LoadUIInstance(path:String, name:String)
    {
        var newState = new UIState(this);
        newState.SetRoot(mUILoader.ParseUIXML(path));
        newState.Initialize();

        mRootFrame.addChild(newState.GetRoot());

        mUIInstanceMap.set(name, newState);
        mUIInstanceArray.push(newState);

        return newState;
    }

    public function GetRootFrame() { return mRootFrame;}

    public function Update(dt:Float)
    {
        for (uiState in mUIInstanceArray){
            uiState.Update(dt);
        }
    }

    public function OpenUIState(name:String)
    {
        if (IsUIStateOpened(name)) return;

        var uiState = mUIInstanceMap.get(name);
        if (uiState != null)
        {
            mUIInstanceStack.push(uiState);
            uiState.SetVisible(true);
        }
    }

    public function CloseUIState(name:String)
    {
        for (uiState in mUIInstanceStack)
        {
            if (uiState.GetName() == name)
            {   
                uiState.SetVisible(false);
                mUIInstanceStack.remove(uiState);
                break;
            }
        }
    }

    public function PopLastUIState()
    {
        var uiState = mUIInstanceStack.pop();
        if (uiState != null)
        {
            uiState.SetVisible(false);
        }
    }

    public function IsUIStateOpened(name:String)
    {
        var isOpened = false;
        for (uiState in mUIInstanceStack)
        {
            if (uiState.GetName() == name)
            {   
                isOpened = true;
                break;
            }
        }

        return isOpened;
    }


}