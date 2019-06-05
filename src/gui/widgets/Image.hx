package gui.widgets;

import hxd.clipper.Rect;
import h2d.Bitmap;
import helper.Log;

import Std.int;

class Image extends Frame
{
    public var mOriginTile:h2d.Tile;
    public var mSlice9Images:Array<h2d.Bitmap>;
    public var mPosNameImageMap:Map<String, h2d.Bitmap>;

    public function new()
    {
        super();

        mSlice9Images = new Array();
        mPosNameImageMap = new Map();
    }

    public function LoadSlice9Image(src:String, slice9:Array<Int>)
    {
        if (slice9.length < 4) 
        {
            Logger.Error("Invalid slice9, src:" + src);
            return;
        }

        var srcTile = hxd.Res.loader.load(src + ".png").toImage().toTile();
        var srcWidth = Std.int(srcTile.width);
        var srcHeight = Std.int(srcTile.height);

	    var x1:Int = slice9[0];
        var y1:Int = slice9[1];
        var x2:Int = slice9[2];
        var y2:Int = slice9[3];

	    var rects = new Map<String, Rect>();
        rects.set("top.left", new Rect(0, 0, x1, y1));
        rects.set("top", new Rect(x1, 0, x2-x1, y1));
        rects.set("top.right", new Rect(x2, 0, srcWidth-x2, y1));
        rects.set("left", new Rect(0, y1, x1, y2-y1));
        rects.set("middle", new Rect(x1, y1, x2-x1, y2-y1));
        rects.set("right", new Rect(x2, y1, srcWidth-x2, y2-y1));
        rects.set("bottom.left", new Rect(0, y2, x1, srcHeight-y2));
        rects.set("bottom", new Rect(x1, y2, x2-x1, srcHeight-y2));
        rects.set("bottom.right", new Rect(x2, y2, srcWidth-x2, srcHeight-y2));

        for (i in 0...9)
        {
            var name = GetPosNameByIndex(i);
            var rect = rects.get(name);
           
            var newTile = srcTile.sub(rect.left, rect.top, rect.right, rect.bottom);
            var newImage = new h2d.Bitmap(newTile);
            newImage.x = rect.left;
            newImage.y = rect.top;

            mSlice9Images.push(newImage);
            mPosNameImageMap.set(name, newImage);

            this.addChild(newImage);
        }

        mOriginTile = srcTile;
    }

    public function Resize(newWidth:Float, newHeight:Float)
    {
        // var oldWidth = mOriginTile.width;
        // var oldHeight = mOriginTile.height;

        // var tl = mPosNameImageMap.get("top.left");
        // var tr = mPosNameImageMap.get("top.right");
        // if (tr != null) {
        //     tr.x = newWidth - tr.width;
        // }
        // var t = mPosNameImageMap.get("top");
        // if (t != null) 
        // {
        //     t.x = tl.width;
        //     t.width = newWidth - tl.width - tr.width; 
        // }

        // mPosNameImageMap.get("bottom").scaleX = scaleX;

        // mPosNameImageMap.get("left").scaleY = scaleY;
        // mPosNameImageMap.get("right").scaleY = scaleY;

        // mPosNameImageMap.get("middle").scaleX = scaleX;
        // mPosNameImageMap.get("middle").scaleY = scaleY;
    }    

    private function GetPosNameByIndex(index:Int)
    {
        var name = "top.left";
        switch(index)
        {
            case 0: name = "top.left";
            case 1: name = "top";
            case 2: name = "top.right";
            case 3: name = "left";
            case 4: name = "middle";
            case 5: name = "right";
            case 6: name = "bottom.left";
            case 7: name = "bottom";
            case 8: name = "bottom.right";
            default: name = "top.left";
        }
        return name;
    }

    override public function SetSize(width:Int, height:Int)
    {
        Resize(width, height);
    }
}