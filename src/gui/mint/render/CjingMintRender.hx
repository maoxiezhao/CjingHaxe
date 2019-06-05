package gui.mint.render;

import gui.mint.render.Rendering;
import gui.mint.types.Types;
import helper.Log;

class CjingMintRender extends Rendering {

    public function new() {

        super();
    } 

    override function get<T:Control, T1>( type:Class<T>, control:T ) : T1 {
        return null;
    } //render

} //LuxeMintRender