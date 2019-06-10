package gui.mint.render.luxe;

import gui.mint.types.Types;
import gui.mint.render.Rendering;
import gui.mint.render.luxe.LuxeMintRender;
import gui.mint.render.luxe.Convert;
import gui.mint.render.CjingMintRender;

import h2d.Graphics;
import h2d.Sprite;

private typedef LuxeMintButtonOptions = {
    var color: UInt;
    var color_hover: UInt;
    var color_down: UInt;
}

class Button extends gui.mint.render.Render {

    public var button : gui.mint.Button;
    public var visual : Sprite;
    
    public var mGraphics : h2d.Graphics;
    public var color: UInt;
    public var color_hover: UInt;
    public var color_down: UInt;

    private var mRender: CjingMintRender;

    public function new(_render:CjingMintRender, _control:gui.mint.Button) 
    {
        super(render, _control);

        render = _render;
        button = _control;
        var _opt: LuxeMintButtonOptions = button.options.options;

        color = 0x373737;
        color_hover = 0x445158;
        color_down = 0x444444;

        mGraphics = new h2d.Graphics(this);
        mGraphics.color = color;
        mGraphics.visible = control.visible;

        mGraphics.clear();
        mGraphics.drawRect(sx, sy, sx + sw, sy + sh);
        
        update_clip(scale);

        button.onmouseenter.listen(function(e,c) { visual.color = color_hover; });
        button.onmouseleave.listen(function(e,c) { visual.color = color; });
        button.onmousedown.listen(function(e,c) { visual.color = color_down; });
        button.onmouseup.listen(function(e,c) { visual.color = color; });

    } //new

    function update_clip(_scale:Float) 
    {
        // color button dont't need clip
        // visual.clip_rect = Convert.clip_bounds(control.clip_with, render.options.batcher.view, _scale);

    } //update_clip

    override function onscale(_scale:Float, _prev_scale:Float) 
    {  
        update_clip(_scale);
    }

    override function onbounds() 
    {
        mGraphics.clear();
        mGraphics.drawRect(sx, sy, sx + sw, sy + sh);
    } 

    override function ondestroy() {

        mGraphics.remove();
        mGraphics = null;
    } 

    override function onclip(_disable:Bool, _x:Float, _y:Float, _w:Float, _h:Float) 
    {
        update_clip(scale);
    } 

    override function onvisible(_visible:Bool) 
    {
        mGraphics.visible = _visible;
    } 

    override function ondepth(_depth:Float) 
    {
    } //ondepth


} //Button
