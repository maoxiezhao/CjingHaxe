package game.entity;

enum EntityType
{
    EntityType_Unknown;
    EntityType_Hero;
    EntityType_Camera;
}

// TODO realize an in-entity event system
enum EntityEvent
{
    EntityEvent_PositionChanged;
}