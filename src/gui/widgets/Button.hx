package gui.widgets;

import h2d.Tile;
import h2d.Sprite;

class Button extends Frame
{
    public var mFrameIndeces:Array<Int>;
    public var mFrameSprites:Array<h2d.Bitmap>;

    public function new()
    {
        super();

        mFrameIndeces = new Array();
    }

    public function LoadImage(imageArray:Array<Image>, width:Int, height:Int)
    {
      
        for (image in imageArray)
        {
            this.addChild(image);
        }

        // Button Frame:normal hover down
        //this.addChild(src);
    }

    private function ProcessScaleSlice(sliceArray:Array<Int>, srcImage:h2d.Bitmap, scaleX:Float, scaleY:Float)
    {

    }
}