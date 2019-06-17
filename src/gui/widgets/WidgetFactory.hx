package gui.widgets;

import haxe.xml.Access;
import hxd.Res.loader;

import gui.widgets.Frame;
import gui.widgets.Button;
import gui.widgets.Image;
import helper.System;

class WidgetFactory
{
    public static var mTagLoaderMap:Map<String, Access->Frame> = new Map();

    public static function LoadFromData(data:Access)
    {
        var newFrame:Frame = new Frame();

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
                    frame.Initialize();

                    var isVisible:Bool = XMLHelper.XMLGetBool(data.x, "visible", true);
                    frame.visible = isVisible;

                    if (frameName != "") {
                        frame.SetName(frameName);
                    }

                    newFrame.addFrameChild(frame);

                    LoadPosition(obj, frame);
                }
            }
        }   

        return newFrame;
    }

    // TODO:support anchor
    static public function LoadPosition(data:Access, frame:Frame)
    {
        var isCenterX:Bool = XMLHelper.XMLGetBool(data.x, "center_x", false);
        var isCenterY:Bool = XMLHelper.XMLGetBool(data.x, "center_y", false);
        CenterFrame(frame, isCenterX, isCenterY);

        var x:Float = XMLHelper.XMLGetX(data);
        var y:Float = XMLHelper.XMLGetY(data);
        frame.x = frame.x + x;
        frame.y = frame.y + y;
    }

    static public function CenterFrame(frame:Frame, centerX:Bool, centerY:Bool)
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

        var id = XMLHelper.XMLGetName(info.x);
        var label:String = XMLHelper.XMLGetStr(info.x, "label");
        var width:Int = Std.int(XMLHelper.XMLGetWidth(info, -1));
        var height:Int = Std.int(XMLHelper.XMLGetHeight(info, -1));

        if (info.hasNode.graphic)
        {
            // every button contains 3 frames
           var imageArray = new Array<Image>();
           imageArray.resize(3);

            for (graphic in info.nodes.graphic)
            {
                var graphicName = XMLHelper.XMLGetName(graphic.x);
                var imageSrc = XMLHelper.XMLGetStr(graphic.x, "image");
                var sliceIntArray = XMLHelper.XMLGetIntArray(graphic, "slice9");
                var srcWidth:Int = Std.int(XMLHelper.XMLGetNumber(graphic.x, "src_width", 0));
                var srcHeight:Int = Std.int(XMLHelper.XMLGetNumber(graphic.x, "src_height", 0));

                switch (graphicName)
                {
                    case "normal":
                        var newImage = new Image();
                        newImage.LoadSlice9Image(imageSrc, srcWidth, srcHeight, sliceIntArray);
                        newImage.SetName(graphicName);
                        imageArray[0] = newImage;

                    case "over" :
                        var newImage = new Image();
                        newImage.LoadSlice9Image(imageSrc, srcWidth, srcHeight, sliceIntArray);
                        newImage.SetName(graphicName);
                        imageArray[1] = newImage;

                    case "down" :
                        var newImage = new Image();
                        newImage.LoadSlice9Image(imageSrc, srcWidth, srcHeight, sliceIntArray);
                        newImage.SetName(graphicName);
                        imageArray[2] = newImage;
                    case "all" :
                        var newImage = new Image();
                        newImage.LoadSlice9Image(imageSrc, srcWidth, srcHeight, sliceIntArray);
                        newImage.SetName(graphicName);
                        imageArray[0] = imageArray[1] = imageArray[2] = newImage;
                }
            }

            button.SetFrameImage(UIButtonFrameIndex_Normal, imageArray[0]);
            button.SetFrameImage(UIButtonFrameIndex_Over,   imageArray[1]);
            button.SetFrameImage(UIButtonFrameIndex_Down,   imageArray[2]);

            button.SetSize(width, height);
        }

        return button;
    }
}