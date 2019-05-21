package gui;

import gui.UILoader;
import gui.widgets.Frame;
import gui.widgets.WidgetFactory;

// TODO 
// will support layout
class MainStage
{
    private var mRootLayer:h2d.Layers;
    private var mRootFrame:Frame;
    private var mUILoader:gui.UILoader;

    public function new(s2d:h2d.Scene)
    {
        var screenSize = helper.System.GetScreenSize();

        mRootFrame = new Frame();
        mRootFrame.SetName("Root");
        mRootFrame.getBounds().set(0, 0, screenSize.x, screenSize.y);
        s2d.add(mRootFrame, 10);

        WidgetFactory.Initialize();

        mUILoader = new UILoader(this);

        InitDefaultUI();
    }

    public function InitDefaultUI()
    {
        mUILoader.ParseUIXML("ui/main.xml");
    }

    public function GetRootFrame() { return mRootFrame;}
}