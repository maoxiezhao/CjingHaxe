package gui.mint.render.luxe;

import gui.mint.types.Types;
import gui.mint.core.Macros.*;
import gui.mint.render.Rendering;

import gui.mint.render.luxe.LuxeMintRender;
import gui.mint.render.luxe.Convert;

import luxe.Color;
import luxe.Sprite;
import luxe.Vector;

private typedef LuxeMintImageOptions = {
    @:optional var uv: luxe.Rectangle;
    @:optional var color: luxe.Color;
    @:optional var sizing: ImageSizing;
}

@:enum abstract ImageSizing(Int) from Int to Int {
    var contain = 0;
    var fit     = 1;
    var cover   = 2;
} //ImageSizing

class Image extends gui.mint.render.Render {

    public var image : gui.mint.Image;
    public var visual : Sprite;
    public var color : Color;

    var ratio_w : Float = 1.0;
    var ratio_h : Float = 1.0;

    var render: LuxeMintRender;

    public function new( _render:LuxeMintRender, _control:gui.mint.Image ) {

        image = _control;
        render = _render;

        super(render, _control);

        var _opt: LuxeMintImageOptions = image.options.options;

        var _texture = Luxe.resources.texture(image.options.path);
        
        if(_texture != null && _opt.sizing != null) {

            switch(_opt.sizing) {
                
                //sets the uv to be the size on the longest edge
                //possibly leaving whitespace on the sides (pillarbox) or top (letterbox)
                case ImageSizing.fit: {
                    if(_texture.width > _texture.height) {
                        ratio_h = _texture.height/_texture.width;
                    } else {
                        ratio_w = _texture.width/_texture.height;
                    }
                } //fit

                    // cover the viewport with the size (possible cropping)
                case ImageSizing.cover: {
                    var _rx = 1.0;
                    var _ry = 1.0;
                    if(_texture.width > _texture.height) {
                        _rx = _texture.height/_texture.width;
                    } else {
                        _ry = _texture.width/_texture.height;
                    }
                    _opt.uv = new luxe.Rectangle(0,0,_texture.width*_rx,_texture.height*_ry);
                } //cover

                case _:

            } //switch sizing

        } //if opt.sizing != null

        visual = new luxe.Sprite({
            name: control.name+'.visual',
            batcher: render.options.batcher,
            centered: false,
            no_scene: true,
            texture: _texture,
            pos: new Vector(sx, sy),
            size: new Vector(sw*ratio_w, sh*ratio_h),
            depth: render.options.depth + control.depth,
            visible: control.visible,
            uv: _opt.uv,
            color: _opt.color
        });

        update_clip(scale);

    } //new

    function update_clip(_scale:Float) {
        
        visual.clip_rect = Convert.clip_bounds(control.clip_with, render.options.batcher.view, _scale);

    } //update_clip

    override function onscale(_scale:Float, _prev_scale:Float) {
        
        update_clip(_scale);
        visual.pos.set_xy(sx, sy);
        visual.size.set_xy(sw*ratio_w, sh*ratio_h);

    } //onscale

    override function onbounds() {

        visual.transform.pos.set_xy(sx, sy);
        visual.geometry_quad.resize_xy(sw*ratio_w, sh*ratio_h);

    } //onbounds

    override function ondestroy() {

        visual.destroy();
        visual = null;

    } //ondestroy

    override function onclip(_disable:Bool, _x:Float, _y:Float, _w:Float, _h:Float) {

        update_clip(scale);

    } //onclip

    override function onvisible( _visible:Bool ) {

        visual.visible = _visible;

    } //onvisible

    override function ondepth( _depth:Float ) {

        visual.depth = render.options.depth + _depth;

    } //ondepth

} //Image
