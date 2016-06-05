module common.settings;

import std.getopt : getopt;

import core.memory : GC;

struct Settings
{
    /**
     * The fullscreen flag.
     */
    public bool fullscreen = false;

    /**
     * The borderless flag.
     */
    public bool borderless = false;

    /**
     * The render rate.
     */
    public ubyte renderRate = 60;

    /**
     * The update rate.
     */
    public ubyte updateRate = 30;

    /**
     * We don't want the default construction to be possible.
     */
    @disable this();

    /**
     * Creates an instance of settings.
     *
     * Params:
     *     args  =     the arguments
     *
     * Returns: a pointer to the settings instance
     */
    public static Settings* create(string[] args = [])
    {
        Settings* settings = cast(Settings*) GC.calloc(Settings.sizeof);

        try {
            getopt(
                args,
                "fullscreen|fs", &settings.fullscreen,
                "borderless|bl", &settings.borderless,
                "renderRate|rr", &settings.renderRate,
                "updateRate|ur", &settings.updateRate
            );
        } catch (Exception e) { }

        settings.renderRate = settings.renderRate == 0 ? 30 : settings.renderRate;
        settings.updateRate = settings.updateRate == 0 ? 30 : settings.updateRate;

        return settings;
    }
}
