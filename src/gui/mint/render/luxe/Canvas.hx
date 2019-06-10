package gui.mint.render.luxe;

import gui.mint.types.Types;
import gui.mint.render.Rendering;
import gui.mint.render.luxe.LuxeMintRender;
import gui.mint.render.luxe.Convert;

import gui.mint.render.CjingMintRender;
import h2d.Graphics;
import h2d.Sprite;

private typedef LuxeMintCanvasOptions = {
    var color: UInt;
}

class Canvas extends gui.mint.render.Render {

    public var canvas : gui.mint.Canvas;
    public var visual : h2d.Object;

    public var color : UInt;

    var render: CjingMintRender;

    public function new(_render:CjingMintRender, _control:gui.mint.Canvas) 
    {
        super(render, _control);
        canvas = _control;
        render = _render;

        var _opt: LuxeMintCanvasOptions = canvas.options.options;
        color = 0x0c0c0c;

        visual = new h2d.Object(this);

        update_clip(scale);

    } //new

    function update_clip(_scale:Float) {
        
        //visual.clip_rect = Convert.clip_bounds(control.clip_with, render.options.batcher.view, _scale);

    } //update_clip

    override function onscale(_scale:Float, _prev_scale:Float) {
    
        update_clip(_scale);
    
    } //onscale

    override function ondestroy() {

        visual.remove();
        visual = null;

    } //ondestroy

    override function onbounds() {

        visual.x = sx;
        visual.y = sy;

    } //onbounds

    override function onclip(_disable:Bool, _x:Float, _y:Float, _w:Float, _h:Float) {
        
        update_clip(scale);
        
    } //onclip

    override function onvisible(_visible:Bool) {

        visual.visible = _visible;

    } //onvisible

    override function ondepth(_depth:Float) {

        //visual.depth = render.options.depth + _depth;

    } //ondepth

} //Canvas
