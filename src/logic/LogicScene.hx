package logic;

class LogicScene
{
    private var mSceneManager:LogicSceneManager;

    public function new(manager:LogicSceneManager)
    {
        mSceneManager = manager;
    }

    public function GetSceneManager() { return mSceneManager; }
    public function OnEnter() {}
    public function OnLeave() {}
    public function Update(dt:Float) {}
}

class LogicSceneManager
{
    private var mCurrentApp:App;
    private var mCurrentScene:LogicScene = null;
    private var mNextScene:LogicScene = null;
    private var mSceneStack:Array<LogicScene>;
    private var mForceRequest:Bool = false;

    public function new(app:App)
    {
        mCurrentApp = app;
        mSceneStack = new Array();
    }

    public function Dispose()
    {
        if (mCurrentScene != null) {
            mCurrentScene.OnLeave();
        }
    }

    public function RequsetScene(scene:LogicScene, forceRequest:Bool = false)
    {
        mNextScene = scene;
        mForceRequest = forceRequest;
    }

    public function Update(dt:Float)
    {
        if (mCurrentScene != null) {
            mCurrentScene.Update(dt);
        }

        if (mNextScene != null && mNextScene != mCurrentScene)
        {
            if (mCurrentScene != null) {
                mCurrentScene.OnLeave();
            }

            mCurrentScene = mNextScene;
            mCurrentScene.OnEnter();

            if (mForceRequest == false) {
                mSceneStack.push(mCurrentScene);
            }
        }
    }

    public function PopScene()
    {
        mSceneStack.pop();

        if (mSceneStack.length > 0) {
            mNextScene = mSceneStack[mSceneStack.length - 1];
        }
    }

    public function GetApp() { return mCurrentApp; }
}