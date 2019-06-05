package gui;

import gui.UILoader;
import gui.widgets.Frame;
import gui.widgets.WidgetFactory;

import gui.mint.Canvas;
import gui.mint.render.CjingMintRender;
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

        var renderging = new CjingMintRender();

        var canvas = new gui.mint.Canvas({
            name:'Root',
            rendering : renderging,
            x:0, y:0, w:800, h:600
        });
    }

    public function InitDefaultUI()
    {
        mUILoader.ParseUIXML("ui/main.xml");
    }

    public function GetRootFrame() { return mRootFrame;}
}