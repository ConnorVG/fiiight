module engine.window.data;

import engine.engine : Engine;
import engine.input : InputFactory;

import core.memory : GC;

struct WindowUserData
{
    /**
     * The engine instance.
     */
    public Engine* engine;

    /**
     * The input factory instance.
     */
    public InputFactory* inputFactory;

    /**
     * We don't want the default construction to be possible.
     */
    @disable this();

    /**
     * Creates an instance of window user data.
     *
     * Returns: a pointer to the window data instance
     */
    public static create()
    {
        return cast(WindowUserData*) GC.malloc(WindowUserData.sizeof);
    }
}
