package gui.mint.render.luxe;

import gui.mint.types.Types;
import gui.mint.render.Rendering;
import gui.mint.render.luxe.LuxeMintRender;
import gui.mint.render.luxe.Convert;
import gui.mint.render.CjingMintRender;

import h2d.Graphics;
import h2d.Sprite;

private typedef LuxeMintCheckboxOptions = {
    var color: UInt;
    var color_hover: UInt;
    var color_node: UInt;
    var color_node_hover: UInt;
    var size_margin: Null<Float>;
}

class Checkbox extends gui.mint.render.Render {

    public var checkbox : gui.mint.Checkbox;
    public var visual : h2d.Sprite;
    public var node : h2d.Sprite;
    public var node_off : h2d.Sprite;

    public var color: UInt;
    public var color_hover: UInt;
    public var color_node: UInt;
    public var color_node_hover: UInt;
    public var size_margin: Float;

    var render: CjingMintRender;

    public function new(_render:CjingMintRender, _control:gui.mint.Checkbox) {

        checkbox = _control;
        render = _render;

        super(render, _control);

        var _opt: LuxeMintCheckboxOptions = checkbox.options.options;

        color = def(_opt.color, new Color().rgb(0x373737));
        color_hover = def(_opt.color_hover, new Color().rgb(0x445158));
        color_node = def(_opt.color_node, new Color().rgb(0x9dca63));
        color_node_hover = def(_opt.color_node_hover, new Color().rgb(0xadca63));
        size_margin = def(_opt.size_margin, 4);

        visual = new luxe.Sprite({
            name: control.name+'.visual',
            batcher: render.options.batcher,
            no_scene: true,
            centered: false,
            pos: new Vector(sx, sy),
            size: new Vector(sw, sh),
            color: color,
            depth: render.options.depth + control.depth,
            visible: control.visible,
        });

        var _margin = cs(size_margin);
        node_off = new luxe.Sprite({
            name: control.name+'.node_off',
            batcher: render.options.batcher,
            no_scene: true,
            centered: false,
            pos: new Vector(sx+_margin, sy+_margin),
            size: new Vector(sw-(_margin*2), sh-(_margin*2)),
            color: color_node.clone().set(null,null,null,0.25),
            depth: render.options.depth + control.depth + 0.001,
            visible: control.visible,
        });

        node = new luxe.Sprite({
            name: control.name+'.node_on',
            batcher: render.options.batcher,
            no_scene: true,
            centered: false,
            pos: new Vector(sx+_margin, sy+_margin),
            size: new Vector(sw-(_margin*2), sh-(_margin*2)),
            color: color_node,
            depth: render.options.depth + control.depth + 0.002,
            visible: control.visible && checkbox.state,
        });

        update_clip(scale);

        checkbox.onmouseenter.listen(function(e,c) { node.color = color_node_hover; visual.color = color_hover; });
        checkbox.onmouseleave.listen(function(e,c) { node.color = color_node; visual.color = color; });

        checkbox.onchange.listen(oncheck);

    } //new

    function update_clip(_scale:Float) {

        var _clip = Convert.clip_bounds(control.clip_with, render.options.batcher.view, _scale);

        visual.clip_rect = _clip;
        node_off.clip_rect = _clip;
        node.clip_rect = _clip;

    } //update_clip

    override function onscale(_scale:Float, _prev_scale:Float) {

        update_clip(_scale);

    } //onscale

    function oncheck(_new:Bool, _old:Bool) {

        node.visible = _new;

    } //oncheck

    override function onbounds() {

        var _margin = cs(size_margin);

        visual.transform.pos.set_xy(sx, sy);
        visual.geometry_quad.resize_xy(sw, sh);
        node_off.transform.pos.set_xy(sx+_margin, sy+_margin);
        node_off.geometry_quad.resize_xy(sw-(_margin*2), sh-(_margin*2));
        node.transform.pos.set_xy(sx+_margin, sy+_margin);
        node.geometry_quad.resize_xy(sw-(_margin*2), sh-(_margin*2));

    } //onbounds

    override function ondestroy() {

        visual.destroy();
        node_off.destroy();
        node.destroy();

        visual = node = node_off = null;

    } //ondestroy

    override function onclip(_disable:Bool, _x:Float, _y:Float, _w:Float, _h:Float) {

        update_clip(scale);

    } //onclip

    override function onvisible(_visible:Bool) {

        visual.visible = node_off.visible = _visible;

        if(_visible) {
            if(checkbox.state) node.visible = _visible;
        } else {
            node.visible = _visible;
        }

    } //onvisible

    override function ondepth(_depth:Float) {

        visual.depth = render.options.depth + _depth;
        node_off.depth = visual.depth + 0.001;
        node.depth = visual.depth + 0.002;

    } //ondepth


} //Checkbox
