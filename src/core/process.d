module fiiight.core.process;

import fiiight.core.platform.settings : Settings;

struct Process
{
    /**
     * The settings.
     */
    private Settings* settings;

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
        // ...
    }

    /**
     * Runs the game.
     *
     * Params:
     *      tick  =        the tick duration
     */
    public void run(const float tick)
    {
        // ...
    }
}
