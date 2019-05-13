package gui.widgets;

import haxe.xml.Access;
import gui.widgets.Frame;
import hxd.Res.loader;

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
        var image:Image = new Image();

        var width:Int = Std.int(XMLHelper.XMLGetWidth(info, -1));
        var height:Int = Std.int(XMLHelper.XMLGetHeight(info, -1));

        var srcImage = LoadScaledImage(info);
        if (srcImage != null)
        {
            image.addChild(srcImage);
        }

        return image;
    }

    public static function LoadScaledImage(info:Access)
    {
        var src:String = XMLHelper.XMLGetStr(info.x, "src", "");
        if (src != "") 
        {
            if (info.hasNode.resolve("scale"))
            {
                for(scaleNode in info.nodes.resolve("scale"))   
                {
                    var scaleWidth:Float = XMLHelper.XMLGetWidth(scaleNode, -1);
                    var scaleHeight:Float = XMLHelper.XMLGetHeight(scaleNode, -1);
                    if (scaleWidth != 0 && scaleHeight != 0)
                    {
                        var srcPath = src + ".png";
                        var src:h2d.Bitmap = new h2d.Bitmap(
                            hxd.Res.loader.load(srcPath).toImage().toTile());

                        src.scaleX = scaleWidth;
                        src.scaleY = scaleHeight;

                        return src;
                    }
                }
            }
        }
        return null;
    }

    public static function LoadButton(info:Access):Frame
    {
        var button:Frame = null;

        return button;
    }
}