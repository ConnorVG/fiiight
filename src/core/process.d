module fiiight.core.process;

import fiiight.core.platform.settings : Settings;
import fiiight.core.scene : Scene;

struct Process
{
    /**
     * The settings.
     */
    private Settings* settings;

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
    public void load(Settings* settings)
    {
        this.settings = settings;
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
    public void setScene(Scene* scene)
    {
        if (this.scene is null) {
            this.scene.unload();
        }

        scene.load(this.settings);

        this.scene = scene;
    }
}
