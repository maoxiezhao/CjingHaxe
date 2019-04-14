package game.entity;

// base entity class
class Camera extends Entity
{
    public var mTarget:Entity;

    public function new()
    {
        super("Camera");

        mEntityType = EntityType_Camera;
    }

    override function Update(dt:Float)
    {
        
    }
}