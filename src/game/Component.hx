package game;

import game.entity.Entity;

enum ComponentType
{
    ComponentType_Movement;
    ComponentType_BoundingBox;
}

class Component
{
    public var mName(default, null):String;
    public var mCurrentEntity:Entity = null;
    public var mManager:ComponentManager = null;
    public var mType:ComponentType = null;

    public function new(name:String, type:ComponentType)
    {
        mName = name;
        mType = type;
    }

    public function Clear()
    {
        mCurrentEntity = null;
        mManager = null;
    }

    public function Added(entity:Entity, componentManager:ComponentManager)
    {
        mCurrentEntity = entity;
        mManager = componentManager;

        AddedImpl();
    }

    public function AddedImpl() {}
    public function Update(dt:Float){}
    public function Dispose(){}
}

class ComponentManager
{
    public var mCurrentEntity:Entity;

    private var mComponentMap:Map<String, Component>;
    private var mComponentArray:Array<Component>;

    public function new(currentEntity:Entity)
    {
        mCurrentEntity = currentEntity;
        mComponentMap = new Map();
        mComponentArray = new Array();
    }   

    public function Dispose() {
        for(component in mComponentArray) {
            component.Dispose();
        }

        mComponentArray = null;
        mComponentMap = null;
        mCurrentEntity = null;
    }

    public function Add(component:Component)
    {
        if (component == null) return;
        Remove(component.mName);

        mComponentMap.set(component.mName, component);
        mComponentArray.push(component);

        component.Added(mCurrentEntity, this);
    }

    public function Remove(name:String)
    {
        var component = GetComponent(name);
        if (component != null) 
        {
            mComponentMap.remove(component.mName);
            mComponentArray.remove(component);
            component.Clear();

            return component;
        }
        return null;
    }

    public inline function GetComponent(name:String)
    {
        return mComponentMap.get(name);
    }

    public inline function GetComponentsByType(type:ComponentType)
    {
        var components:Array<Component> = new Array();
        for(component in mComponentArray) {
            if(component.mType == type) {
                components.push(component);
            }
        }
        return components;
    }

    public function Update(dt:Float)
    {
        for(component in mComponentArray) {
            component.Update(dt);
        }
    }
}