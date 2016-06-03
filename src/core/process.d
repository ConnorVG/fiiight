module fiiight.core.process;

import fiiight.core.platform.settings : Settings;
import fiiight.core.scene : Scene;
import fiiight.utils.input : InputFactory, InputHandler;

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
    private Scene* scene;

    /**
     * We don't want the default construction to be possible.
     */
    @disable this();

    /**
     * Loads everything necessary.
     *
     * Params:
     *     settings  =     the settings
     */
    public void load(Settings* settings, InputFactory* inputFactory)
    {
        this.settings = settings;
        this.inputFactory = inputFactory;

        // some test shizzle
        this.inputFactory.register(InputHandler.create());
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
    public void setScene(Scene* scene = null)
    {
        if (this.scene is null) {
            this.scene.unload();
        }

        if (scene is null) {
            this.scene = null;

            return;
        }

        scene.load(this.settings);

        this.scene = scene;
    }
}
