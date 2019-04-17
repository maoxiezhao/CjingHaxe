package game.entity;

// base entity class
class Camera extends Entity
{
    public var mTarget:Entity;

    public function new()
    {
        super("Camera", EntityType_Camera);

    }

    public function TraceTarget(target:Entity, ?immediate = false)
    {
        if (target == mTarget) {
            return;
        }

        mTarget = target;

        if (immediate == true) {
            AdaptCamera();
        }
    }

    private function AdaptCamera()
    {

    }

    override function Update(dt:Float)
    {
        super.Update(dt);
    }
}