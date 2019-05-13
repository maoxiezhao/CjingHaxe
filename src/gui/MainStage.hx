package gui;

import gui.UILoader;
import gui.widgets.WidgetFactory;

// TODO 
// will support layout
class MainStage
{
    private var mRootLayer:h2d.Layers;
    private var mUILoader:gui.UILoader;

    public function new(s2d:h2d.Scene)
    {
        mRootLayer = new h2d.Layers();
        s2d.add(mRootLayer, 10);

        WidgetFactory.Initialize();

        mUILoader = new UILoader();

        InitDefaultUI();
    }

    public function InitDefaultUI()
    {
        var frame = mUILoader.ParseUIXML("ui/main.xml");
        mRootLayer.addChild(frame);
    }
}