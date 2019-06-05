package gui.mint.render.luxe;

import gui.mint.types.Types;
import luxe.Log.*;

class LuxeMintRender extends gui.mint.render.Rendering {

    public var options: luxe.options.RenderProperties;

    public function new( ?_options:luxe.options.RenderProperties ) {

        super();

        options = def(_options, {});
        def(options.batcher, Luxe.renderer.batcher);
        def(options.depth, 0);
        def(options.immediate, false);
        def(options.visible, true);

    } //new

    override function get<T:Control, T1>( type:Class<T>, control:T ) : T1 {
        return cast switch(type) {
            case gui.mint.Canvas:       new gui.mint.render.luxe.Canvas(this, cast control);
            case gui.mint.Label:        new gui.mint.render.luxe.Label(this, cast control);
            case gui.mint.Button:       new gui.mint.render.luxe.Button(this, cast control);
            case gui.mint.Image:        new gui.mint.render.luxe.Image(this, cast control);
            case gui.mint.List:         new gui.mint.render.luxe.List(this, cast control);
            case gui.mint.Scroll:       new gui.mint.render.luxe.Scroll(this, cast control);
            case gui.mint.Panel:        new gui.mint.render.luxe.Panel(this, cast control);
            case gui.mint.Checkbox:     new gui.mint.render.luxe.Checkbox(this, cast control);
            case gui.mint.Window:       new gui.mint.render.luxe.Window(this, cast control);
            case gui.mint.TextEdit:     new gui.mint.render.luxe.TextEdit(this, cast control);
            case gui.mint.Dropdown:     new gui.mint.render.luxe.Dropdown(this, cast control);
            case gui.mint.Slider:       new gui.mint.render.luxe.Slider(this, cast control);
            case gui.mint.Progress:     new gui.mint.render.luxe.Progress(this, cast control);
            case _:                 null;
        }
    } //render

} //LuxeMintRender