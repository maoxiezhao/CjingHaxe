package gui.widgets;

import helper.System;
import haxe.xml.Access;
import h2d.Object;
import h2d.Sprite;
import gui.XMLHelper;

class Frame extends h2d.Sprite
{
    private var mName:String;
    private var mGraphics:h2d.Graphics;

    public function new()
    {
        super();
        mGraphics = new h2d.Graphics(this);
    }

    public function SetName(name:String) { mName = name; }
    public function GetName() { return mName;}

    public function Load(data:Access)
    {
        
        if (data.x.firstElement() != null)
        {
            for(node in data.x.elements())
            {
                var obj:Access = new Access(node);
                var type = node.nodeName;

                var frameName = XMLHelper.XMLGetName(node);
                var frame = LoadFromTag(type, obj);
                if (frame != null)
                {
                    var isVisible:Bool = XMLHelper.XMLGetBool(data.x, "visible", true);
                    frame.visible = isVisible;

                    if (frameName != "") {
                        frame.mName = frameName;
                    }

                    this.addChild(frame);

                    LoadPosition(obj, frame);
                }
            }
        }   
    }

    public function LoadFromTag(tag:String, data:Access):Frame
    {
        return WidgetFactory.LoadFromTag(tag, data);
    }

    // TODO:support anchor
    public function LoadPosition(data:Access, frame:Frame)
    {
        var isCenterX:Bool = XMLHelper.XMLGetBool(data.x, "center_x", false);
        var isCenterY:Bool = XMLHelper.XMLGetBool(data.x, "center_y", false);
        CenterFrame(frame, isCenterX, isCenterY);

        var x:Float = XMLHelper.XMLGetX(data);
        var y:Float = XMLHelper.XMLGetY(data);
        frame.x = frame.x + x;
        frame.y = frame.y + y;
    }

    public function CenterFrame(frame:Frame, centerX:Bool, centerY:Bool)
    {
        var frameBounds = frame.getBounds();
        var parent = cast(frame.parent, Frame);
        if (parent != null && parent.GetName() != "Root")
        {
            var parentBounds = parent.getBounds();
            if (centerX) {
                frame.x = (parentBounds.width - frameBounds.width) / 2;
            }
            if (centerY) {
                frame.y = (parentBounds.height - frameBounds.height) / 2;
            }
        }
        else 
        {
            var screenSize = System.GetScreenSize();
            if (centerX) {
                frame.x = (screenSize.x - frameBounds.width) / 2;
            }
            if (centerY) {
                frame.y = (screenSize.y - frameBounds.height) / 2;
            }

        }
    }
}