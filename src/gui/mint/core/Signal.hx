package gui.mint.core;

// Contibuted by Michael Bickel http://github.com/dazKind

import haxe.macro.Expr;
import helper.Log;

class Signal<T> 
{
    public var listeners:Array<T>;

    public function new() {

        listeners = [];
    } 

    public function listen( _handler:T ):Void
    {
        if( listeners.indexOf(_handler) != -1 ) {
            Logger.Error("mint / signal / listen / attempted to add the same listener twice");
            return;
        }

        listeners.push(_handler);
    }

    public function remove( _handler:T ):Void 
    {
        var _index = listeners.indexOf(_handler);
        if(_index != -1) {
            listeners[_index] = null;
        }
    } 

    public inline function has( _handler:T ):Bool 
    {
        return listeners.indexOf(_handler) != -1;
    }

    public inline function clear() {
        listeners = null;
        listeners = [];
    }

    macro public function emit( ethis : Expr, args:Array<Expr> ) {
        return macro {
            var _idx = 0;
            var _count = $ethis.listeners.length;
            while(_idx < _count) {
                if($ethis != null) {
                    var fn = $ethis.listeners[_idx];
                    if(fn != null) {
                        fn($a{args});
                    }
                }
                _idx++;
            }

            if($ethis != null) {
                while(_count > 0) {
                    var fn = $ethis.listeners[_count-1];
                    if(fn == null) $ethis.listeners.splice(_count-1, 1);
                    _count--;
                }
            }
        }
    } 
} 
