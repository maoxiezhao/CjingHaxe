package game.entity;

class Hero extends Entity
{
    public function new()
    {
        super("Hero");

        trace("Init Hero");

        mEntityType = EntityType_Hero;
    }
}