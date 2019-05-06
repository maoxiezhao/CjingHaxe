package game.entity.entityStates;

import game.GameCommand;

class EntityState
{
    private var mCurrentEntity:Entity = null;
    private var mName:String = "";

    public function new(entity:Entity, name:String)
    {
        mCurrentEntity = entity;
        mName = name;
    }

    public function Start(prevState:EntityState){}
    public function Stop(prevState:EntityState){}
    public function Update(dt:Float){}
    public function NotifyGameCommand(commandEvent:GameCommandEvent) {}

    public function GetName() {return mName;}
    public function GetEntity() {return mCurrentEntity;}
}