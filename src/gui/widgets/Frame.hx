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

    public function SetName(name:String) { mName = name; }
    public function GetName() { return mName;}

   
}