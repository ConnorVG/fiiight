module engine.engine;

import engine.window : Window;
import common : Settings;

import core.memory : GC;

struct Engine
{
    /**
     * The window.
     */
    private Window* window;

    /**
     * The settings.
     */
    private Settings* settings;

    /**
     * We don't want the default construction to be possible.
     */
    @disable this();

    /**
     * Creates an instance of engine.
     *
     * Params:
     *     settings  =      the settings
     *
     * Returns: a pointer to the engine instance
     */
    public static Engine* create(Settings* settings)
    {
        Engine* engine = cast(Engine*) GC.malloc(Engine.sizeof);

        engine.window = Window.create();
        engine.settings = settings;

        return engine;
    }

    /**
     * Boots the engine.
     */
    public void boot()
    {
        // ...
    }

    /**
     * Opens a window for the engine.
     *
     * Params:
     *      title       =       the title
     *      width       =       the title
     *      height      =       the title
     *      fullscreen  =       the title
     *      borderless  =       the title
     */
    public void open(
        string title = "[engine 0.0.1]",
        int width = 1080,
        int height = 810,
        bool fullscreen = this.settings.fullscreen,
        bool borderless = this.settings.borderless
    ) {
        // ...
    }

    /**
     * Closes the engine window.
     */
    public void close()
    {
        // ...
    }
}
