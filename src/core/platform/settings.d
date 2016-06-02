module fiiight.core.platform.settings;

import std.getopt : getopt;

struct Settings
{
    /**
     * The fullscreen flag.
     */
    public bool fullscreen = false;

    /**
     * The update rate.
     */
    public ubyte updateRate = 60;

    /**
     * We don't want the default construction to be possible.
     */
    @disable this();

    /**
     * Loads all the settings.
     *
     * Params:
     *     args  =     the arguments
     */
    public void load(string[] args)
    {
        try {
            getopt(
                args,
                "fullscreen", &fullscreen,
                "updateRate", &updateRate
            );
        } catch (Exception e) { }
    }
}
