package gui.mint.render.luxe;

import gui.mint.types.Types;

import luxe.Rectangle;
import luxe.Vector;
import luxe.Text;
import luxe.Input;

class Convert {

        /** from gui.mint.TextAlign to luxe.Text.TextAlign */
    public static function text_align( _align:gui.mint.types.TextAlign ) : TextAlign {

        return switch(_align) {
            case gui.mint.types.TextAlign.right:  TextAlign.right;
            case gui.mint.types.TextAlign.center: TextAlign.center;
            case gui.mint.types.TextAlign.top:    TextAlign.top;
            case gui.mint.types.TextAlign.bottom: TextAlign.bottom;
            case _:                           TextAlign.left;
        }

    } //text_align

        /** from gui.mint.Control bounds to luxe.Rectangle */
    public static function bounds( _control:Control, ?_scale:Float=1.0 ) : Rectangle {

        if(_control == null) return null;

        return new Rectangle(_control.x*_scale, _control.y*_scale, _control.w*_scale, _control.h*_scale);

    } //bounds

    static var tmp: luxe.Vector = new luxe.Vector();
    
        /** from gui.mint.Control bounds in canvas space, to window clip space where clipping happens in luxe (OpenGL scissor rect) */
    public static function clip_bounds( _control:Control, _view:phoenix.Camera, ?_scale:Float=1.0 ) : Rectangle {

        if(_control == null) return null;

        tmp.x = _control.x * _scale;
        tmp.y = _control.y * _scale;

        var pos = _view.world_point_to_screen(tmp);

            //we add the width height, because we need the world space position to convert
        tmp.x += _control.w * _scale;
        tmp.y += _control.h * _scale;
        
        var bottom_right = _view.world_point_to_screen(tmp);

            //then we subtract again
        return new Rectangle(pos.x, pos.y, bottom_right.x - pos.x, bottom_right.y - pos.y);

    } //clip_bounds

        /** from luxe.Input.InteractState to gui.mint.InteractState */
    public static function interact_state( _state:InteractState ) : gui.mint.types.InteractState {

        return switch(_state) {
            case InteractState.unknown: gui.mint.types.InteractState.unknown;
            case InteractState.none:    gui.mint.types.InteractState.none;
            case InteractState.down:    gui.mint.types.InteractState.down;
            case InteractState.up:      gui.mint.types.InteractState.up;
            case InteractState.move:    gui.mint.types.InteractState.move;
            case InteractState.wheel:   gui.mint.types.InteractState.wheel;
            case InteractState.axis:    gui.mint.types.InteractState.axis;
        } //state

    } //interact_state

        /** from luxe.Input.MouseButton to gui.mint.MouseButton */
    public static function mouse_button( _button:MouseButton ) : gui.mint.types.MouseButton {

        return switch(_button) {
            case MouseButton.none:      gui.mint.types.MouseButton.none;
            case MouseButton.left:      gui.mint.types.MouseButton.left;
            case MouseButton.middle:    gui.mint.types.MouseButton.middle;
            case MouseButton.right:     gui.mint.types.MouseButton.right;
            case MouseButton.extra1:    gui.mint.types.MouseButton.extra1;
            case MouseButton.extra2:    gui.mint.types.MouseButton.extra2;
        } //state

    } //mouse_button

        /** from luxe.Input.Key to gui.mint.KeyCode */
    public static function key_code( _keycode:Int ) : gui.mint.types.KeyCode {

        return switch(_keycode) {

            case Key.left:      gui.mint.types.KeyCode.left;
            case Key.right:     gui.mint.types.KeyCode.right;
            case Key.up:        gui.mint.types.KeyCode.up;
            case Key.down:      gui.mint.types.KeyCode.down;
            case Key.backspace: gui.mint.types.KeyCode.backspace;
            case Key.delete:    gui.mint.types.KeyCode.delete;
            case Key.tab:       gui.mint.types.KeyCode.tab;
            case Key.enter:     gui.mint.types.KeyCode.enter;
            case Key.escape:    gui.mint.types.KeyCode.escape;
            case _:             gui.mint.types.KeyCode.unknown;

        } //_keycode

    } //key_code

    public static function text_event_type( _type:TextEventType ) : gui.mint.types.TextEventType {

        return switch(_type) {
            case luxe.TextEventType.unknown: gui.mint.types.TextEventType.unknown;
            case luxe.TextEventType.edit:    gui.mint.types.TextEventType.edit;
            case luxe.TextEventType.input:   gui.mint.types.TextEventType.input;
        }

    } //text_event_type

        /** from luxe.Input.ModState to gui.mint.ModState */
    public static function mod_state( _mod:ModState ) : gui.mint.types.ModState {

        return {
            none:   _mod.none,
            lshift: _mod.lshift,
            rshift: _mod.rshift,
            lctrl:  _mod.lctrl,
            rctrl:  _mod.rctrl,
            lalt:   _mod.lalt,
            ralt:   _mod.ralt,
            lmeta:  _mod.lmeta,
            rmeta:  _mod.rmeta,
            num:    _mod.num,
            caps:   _mod.caps,
            mode:   _mod.mode,
            ctrl:   _mod.ctrl,
            shift:  _mod.shift,
            alt:    _mod.alt,
            meta:   _mod.meta,
        };

    } //mod_state

        /** from luxe.Input.MouseEvent to gui.mint.MouseEvent */
    public static function mouse_event( _event:MouseEvent, ?_scale:Float=1.0, ?view:phoenix.Camera ) : gui.mint.types.MouseEvent {

        var _pos = new Vector(_event.x, _event.y);

        if(view != null) {
            _pos = view.screen_point_to_world(_pos);
        }

        return {
            state       : interact_state(_event.state),
            button      : mouse_button(_event.button),
            timestamp   : _event.timestamp,
            x           : Std.int(_pos.x/_scale),
            y           : Std.int(_pos.y/_scale),
            xrel        : Std.int(_event.x_rel/_scale),
            yrel        : Std.int(_event.y_rel/_scale),
            bubble      : true
        };

    } //mouse_event

        /** from luxe.Input.KeyEvent to gui.mint.KeyEvent */
    public static function key_event( _event:KeyEvent ) : gui.mint.types.KeyEvent {

        return {
            state       : interact_state(_event.state),
            keycode     : _event.keycode,
            timestamp   : _event.timestamp,
            key         : key_code(_event.keycode),
            mod         : mod_state(_event.mod),
            bubble      : true
        };

    } //key_event

        /** from luxe.Input.TextEvent to gui.mint.TextEvent */
    public static function text_event( _event:TextEvent ) : gui.mint.types.TextEvent {

        return {
            text      : _event.text,
            type      : text_event_type(_event.type),
            timestamp : _event.timestamp,
            start     : _event.start,
            length    : _event.length,
            bubble    : true
        };

    } //mouse_event

} //Convert
