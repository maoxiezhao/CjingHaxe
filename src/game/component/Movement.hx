package game.component;

import game.Component;

// base movement component
class Movement extends Component
{
    public function new(name:String)
    {
        super(name, ComponentType_Movement);
    }

    override public function Update(dt:Float)
    {

    }

    override public function Dispose()
    {

    }
}