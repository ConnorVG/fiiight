module fiiight.core.process;

import fiiight.core.platform.settings : Settings;
import fiiight.core.scene : Scene;
import fiiight.utils.input : InputFactory, InputHandler, InputType, KeyInputCommand;
import fiiight.scenes.menu : MenuScene, MenuSceneType;

import derelict.glfw3.glfw3 : glfwSetWindowShouldClose, GLFW_KEY_ESCAPE;

struct Process
{
    /**
     * The settings.
     */
    private Settings* settings;

    /**
     * The input factory.
     */
    private InputFactory* inputFactory;

    /**
     * The current scene.
     */
    private Scene scene;

    /**
     * We don't want the default construction to be possible.
     */
    @disable this();

    /**
     * Loads everything necessary.
     *
     * Params:
     *     settings      =      the settings
     *     inputFactory  =      the input factory
     */
    public void load(Settings* settings, InputFactory* inputFactory)
    {
        this.settings = settings;
        this.inputFactory = inputFactory;

        this.setScene(new MenuScene(MenuSceneType.MAIN_MENU));
    }

    /**
     * Unloads everything no longer necessary.
     */
    public void unload()
    {
        if (this.scene is null) {
            return;
        }

        this.scene.unload();
    }

    /**
     * Runs the process.
     *
     * Params:
     *      tick  =        the tick duration
     */
    public void run(const float tick)
    {
        if (this.scene is null) {
            return;
        }

        this.scene.run(tick);
    }

    /**
     * Sets the scene to use.
     *
     * Params:
     *      scene  =        the scene to use
     */
    public void setScene(Scene scene = null)
    {
        if (this.scene !is null) {
            this.scene.unload();
            this.scene = null;
        }

        if (scene is null) {
            return;
        }

        scene.load(this.settings, this.inputFactory);

        this.scene = scene;
    }
}
