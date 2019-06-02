package gui.widgets;

import hxd.clipper.Rect;
import h2d.Bitmap;
import helper.Log;

import Std.int;

class Image extends Frame
{
    public var mSlice9Images:Array<h2d.Bitmap>;

    public function new()
    {
        super();

        mSlice9Images = new Array<h2d.Bitmap>();
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
            var rect = 
            switch(i)
            {
                case 0: rects.get("top.left");
                case 1: rects.get("top");
                case 2: rects.get("top.right");
                case 3: rects.get("left");
                case 4: rects.get("middle");
                case 5: rects.get("right");
                case 6: rects.get("bottom.left");
                case 7: rects.get("bottom");
                case 8: rects.get("bottom.right");
                default: rects.get("top.left");
            }
            var newTile = srcTile.sub(rect.left, rect.top, rect.right, rect.bottom);
            var newBitmap = new h2d.Bitmap(newTile);
            newBitmap.x = rect.left;
            newBitmap.y = rect.top;

            mSlice9Images.push(newBitmap);
            this.addChild(newBitmap);
        }
    }

    public function Resize(w:Float, h:Float)
    {
        var oldWidth = this.getSize().width;
        var oldHeight = this.getSize().height;

        var scaleX = w / oldWidth;
        var scaleY = h / oldHeight;
    }    
}