module fiiight.scenes.menu;

import fiiight.core.scene : Scene;
import fiiight.core.platform.settings : Settings;
import fiiight.utils.input : InputFactory, InputHandler;
import fiiight.rendering.two_d.frame : Frame;
import fiiight.rendering.two_d.components : TestComponent;

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
     * The frame.
     */
    protected Frame* frame;

    /**
     * Constructs a specific type of menu scene.
     *
     * Params:
     *      type  =     the menu scene type
     */
    public this(MenuSceneType type)
    { /** @todo */ }

    /**
     * Loads everything necessary.
     *
     * Params:
     *     settings      =      the settings
     *     inputFactory  =      the input factory
     */
    public void load(Settings* settings, InputFactory* inputFactory)
    {
        this.inputHandler = InputHandler.create();
        this.inputHandler.activate();

        this.frame = Frame.create();

        this.frame.add(new TestComponent());
    }

    /**
     * Unloads everything no longer necessary.
     */
    public void unload()
    {
        this.frame.clear();
        this.frame = null;

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
    public void run(const float tick)
    {
        this.frame.run(tick);
    }
}
