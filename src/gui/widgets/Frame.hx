package gui.widgets;

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

    public function LoadPosition(data:Access, frame:Frame)
    {
        var x:Float = XMLHelper.XMLGetX(data);
        var y:Float = XMLHelper.XMLGetY(data);

        frame.x = x;
        frame.y = y;
    }
}