module engine.window;

import core.memory : GC;

struct Window
{
    /**
     * We don't want the default construction to be possible.
     */
    @disable this();

    /**
     * Creates an instance of window.
     *
     * Returns: a pointer to the window instance
     */
    public static Window* create()
    {
        return cast(Window*) GC.malloc(Window.sizeof);
    }
}
