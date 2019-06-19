package gui.widgets;

import h2d.Tile;
import h2d.Sprite;
import gui.widgets.Image;

enum UIButtonFrameIndex
{
    UIButtonFrameIndex_Normal;
    UIButtonFrameIndex_Over;
    UIButtonFrameIndex_Down;
}

class Button extends Frame
{
    private var mButtonImages:Map<UIButtonFrameIndex, Image>;

    public function new()
    {
        super();

        mButtonImages = new Map();
    }

    override public function Initialize()
    {
        super.Initialize();

        var overImage = GetFrameImage(UIButtonFrameIndex_Over);
        if (overImage != null) {
            overImage.visible = false;
        }

        var downImage = GetFrameImage(UIButtonFrameIndex_Down);
        if (downImage != null) {
            downImage.visible = false;
        }

        var normalImage = GetFrameImage(UIButtonFrameIndex_Normal);
        if (normalImage != null) {
            normalImage.visible = true;
        }

        mInteraction.onOver = function(event : hxd.Event) {
            OnOverHandler(event);
        }

        mInteraction.onOut = function(event : hxd.Event) {
            OnOutHandler(event);
        }
    }

    public function LoadImage(imageArray:Array<Image>)
    {
        for (image in imageArray) {
            this.addFrameChild(image);
        }
    }

    public function SetFrameImage(index:UIButtonFrameIndex, image:Image)
    {
        this.addFrameChild(image);
        mButtonImages.set(index, image);
    }

    public function GetFrameImage(index:UIButtonFrameIndex)
    {
        return mButtonImages.get(index);
    }

    public function SetTargetFrameImageVisible(index:UIButtonFrameIndex)
    {
        for (image in mButtonImages) {
            image.visible = false;
        }

        var targetImage = GetFrameImage(index);
        if (targetImage != null) {
            targetImage.visible = true;
        }
    }

    public function OnOutHandler(event : hxd.Event)
    {
        SetTargetFrameImageVisible(UIButtonFrameIndex_Normal);
        FireEvent(UIEventType_MouseOut);
    }

    public function OnOverHandler(event : hxd.Event)
    {
        SetTargetFrameImageVisible(UIButtonFrameIndex_Over);
        FireEvent(UIEventType_MouseOver);
    }

    public function OnDownHandler(event : hxd.Event)
    {
        SetTargetFrameImageVisible(UIButtonFrameIndex_Down);
    }

    public function OnUpHandler(event : hxd.Event)
    {
        SetTargetFrameImageVisible(UIButtonFrameIndex_Normal);
    }
}