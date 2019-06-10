package gui.mint;

import gui.mint.Control;

import gui.mint.types.Types;
import gui.mint.core.Signal;
import gui.mint.core.Macros.*;


/** Options for constructing a Panel */
typedef PanelOptions = {

    > ControlOptions,

} //PanelOptions


/**
    A simple blank panel control
    Additional Signals: none
*/
@:allow(gui.mint.render.Renderer)
class Panel extends Control {

    var options: PanelOptions;

    public function new( _options:PanelOptions ) {

        options = _options;

        def(options.name, 'panel.${Helper.uniqueid()}');

        super(options);

        renderer = rendering.get(Panel, this);

        oncreate.emit();

    } //new

} //Panel
