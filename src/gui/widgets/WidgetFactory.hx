package gui.widgets;

import haxe.xml.Access;
import gui.widgets.Frame;
import gui.widgets.Button;
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
        var srcImage = LoadScaledImage(info);
        if (srcImage != null)
        {
            var width:Int = Std.int(XMLHelper.XMLGetWidth(info, -1));
            var height:Int = Std.int(XMLHelper.XMLGetHeight(info, -1));
            if (width > 0 && height > 0) 
            {
                var scaleX = (width / srcImage.tile.width);
                var scaleY = (height / srcImage.tile.height);

                srcImage.scaleX = scaleX;
                srcImage.scaleY = scaleY;
            }

            image.addChild(srcImage);
        }

        return image;
    }

    public static function LoadScaledImage(info:Access)
    {
        var src:String = XMLHelper.XMLGetStr(info.x, "src", "");
        if (src != "") 
        {
            var srcPath = src + ".png";
            var src:h2d.Bitmap = new h2d.Bitmap(
                hxd.Res.loader.load(srcPath).toImage().toTile());

            if (info.hasNode.resolve("scale"))
            {
                for(scaleNode in info.nodes.resolve("scale"))   
                {
                    var scaleWidth:Float = XMLHelper.XMLGetWidth(scaleNode, -1);
                    var scaleHeight:Float = XMLHelper.XMLGetHeight(scaleNode, -1);
                    if (scaleWidth > 0 && scaleHeight > 0)
                    {
                        src.scaleX = scaleWidth;
                        src.scaleY = scaleHeight;
                    }
                }
            }

            return src;
        }
        return null;
    }

    public static function LoadButton(info:Access):Frame
    {
        var button:Button = new Button();

        var label:String = XMLHelper.XMLGetStr(info.x, "label");
        var width:Int = Std.int(XMLHelper.XMLGetWidth(info, -1));
        var height:Int = Std.int(XMLHelper.XMLGetHeight(info, -1));

        if (info.hasNode.graphic)
        {
            for (graphic in info.nodes.graphic)
            {
                var imageSrc = XMLHelper.XMLGetStr(graphic.x, "image");
                var sliceString = XMLHelper.XMLGetStr(graphic.x, "slice9");
                var srcWidth:Int = Std.int(XMLHelper.XMLGetNumber(graphic.x, "src_w", 0));
                var srcHeight:Int = Std.int(XMLHelper.XMLGetNumber(graphic.x, "src_h", 0));
       
                button.LoadImage(imageSrc, width, height, srcWidth, srcHeight, sliceString);
            }
        }

        return button;
    }
}