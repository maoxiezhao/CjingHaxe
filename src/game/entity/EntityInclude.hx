package game.entity;

enum EntityType
{
    EntityType_Unknown;
    EntityType_Hero;
    EntityType_Camera;
    EntityType_Pickable;
}

// TODO realize an in-entity event system
enum EntityEvent
{
    EntityEvent_PositionChanged;
    EntityEvent_ObstacleReached;
    EntityEvent_ToBeRemoved;
}

class EventManagement
{
    private var mEventCallBacks:Map<EntityEvent, Array<Void->Void>>;

    public function new()
    {
        mEventCallBacks = new Map();
    }

    public function Add(event:EntityEvent, callback:Void->Void)
    {
        var callbacks = mEventCallBacks.get(event);
        if (callbacks == null)
        {
            callbacks = new Array();
            mEventCallBacks.set(event, callbacks);
        }
        callbacks.push(callback);
    }

    public function Remove(event:EntityEvent, ?callback:Void->Void)
    {
        var callbacks = mEventCallBacks.get(event);
        if (callbacks != null)
        {
            if (callback != null)
            {
                callbacks.remove(callback);
            }
            else 
            {
                mEventCallBacks.remove(event);
            }
        }
    }

    public function NotifyEvent(event:EntityEvent)
    {
        var callbacks = mEventCallBacks.get(event);
        if (callbacks != null)
        {
            for(callback in callbacks)
            {
                callback();
            }
        }
    }
}