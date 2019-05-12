package gui.widgets;

import haxe.xml.Access;
import gui.widgets.Frame;

class WidgetFactory
{
    public static var mTagLoaderMap:Map<String, Access->Frame> = new Map();

    public static function LoadFromTag(tag:String, info:Access)
    {
        var loader = mTagLoaderMap.get(tag);
        if (loader == null) {
            return null;
        }
        return loader(info);
    }

    public static function Initialize()
    {
        mTagLoaderMap.set("image", LoadImage);
        mTagLoaderMap.set("button", LoadButton);
    }

    public static function LoadImage(info:Access):Frame
    {
        var image:Frame = null;

        return image;
    }

    public static function LoadButton(info:Access):Frame
    {
        var button:Frame = null;

        return button;
    }
}