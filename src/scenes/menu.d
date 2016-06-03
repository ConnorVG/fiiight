module fiiight.scenes.menu;

import fiiight.core.scene : Scene;
import fiiight.core.platform.settings : Settings;
import fiiight.utils.input : InputFactory, InputHandler;

enum MenuSceneType {
    MAIN_MENU,
}

class MenuScene : Scene
{
    /**
     * The input handler.
     */
    protected InputHandler* inputHandler;

    /**
     * Constructs a specific type of menu scene.
     *
     * Params:
     *      type  =     the menu scene type
     */
    this(MenuSceneType type)
    { /** @todo */ }

    /**
     * Loads everything necessary.
     *
     * Params:
     *     settings      =      the settings
     *     inputFactory  =      the input factory
     */
    void load(Settings* settings, InputFactory* inputFactory)
    {
        this.inputHandler = InputHandler.create();
        this.inputHandler.activate();
    }

    /**
     * Unloads everything no longer necessary.
     */
    void unload()
    {
        this.inputHandler.deactivate();
        this.inputHandler.clear();
        this.inputHandler = null;
    }

    /**
     * Runs the scene.
     *
     * Params:
     *      tick  =        the tick duration
     */
    void run(const float tick)
    {
        // ...
    }
}
