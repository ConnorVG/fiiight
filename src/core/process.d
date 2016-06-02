module fiiight.core.process;

import fiiight.core.platform.settings : Settings;

import derelict.opengl3.gl3 : GL_TRUE;

struct Process
{
    /**
     * The settings.
     */
    private Settings* _settings;

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
        this._settings = settings;

        // Nothing yet.
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
