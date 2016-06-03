module fiiight.utils.input;

import derelict.glfw3.glfw3 : GLFWwindow;

import std.stdio : writeln;
import std.algorithm : remove;
import std.parallelism : parallel;

import core.vararg : __va_argsave_t, __va_list_tag;
import core.memory : GC;

enum InputType {
    ALL,
    KEY,
    CHAR,
    MOUSE,
    MOUSE_MOVE,
}

struct InputHandler
{
    /**
     * Creates and input handler.
     *
     * Returns: the input handler pointer
     */
    public static InputHandler* create()
    {
        InputHandler* inputHandler = cast(InputHandler*) GC.malloc(InputHandler.sizeof);

        inputHandler.clear();

        return inputHandler;
    }

    /**
     * Fires an input command.
     *
     * Params:
     *      type  =     the command type
     *
     */
    public void fire(InputType type, ...)
    {
        writeln(_arguments);
    }

    /**
     * Clears the input maps.
     *
     * Params:
     *      type  =     the input type
     */
    public void clear(InputType type = InputType.ALL)
    {
        if (type != InputType.ALL) {
            // empty just type

            return;
        }

        // empty all
    }
}

struct InputFactory
{
    /**
     * The registered handlers.
     */
    protected InputHandler*[] handlers;

    /**
     * We don't want the default construction to be possible.
     */
    @disable this();

    /**
     * Register a new input handler.
     *
     * Params:
     *      inputHandler  =     the input handler
     */
    public void register(InputHandler* inputHandler)
    {
        this.handlers ~= inputHandler;
    }

    /**
     * Unregister an input handler.
     *
     * Params:
     *      inputHandler  =     the input handler
     */
    public void unregister(InputHandler* inputHandler)
    {
        remove!(a => a == inputHandler)(this.handlers);
    }

    /**
     * Handles a key input event.
     *
     * Params:
     *     key       =      the key
     *     scanCode  =      the scanCode
     *     action    =      the action
     *     mods      =      the mods
     */
    public void handleKey(int key, int scanCode, int action, int mods)
    {
        foreach (InputHandler* inputHandler; parallel(this.handlers)) {
            inputHandler.fire(InputType.KEY, key, scanCode, action, mods);
        }
    }

    /**
     * Handles a char input event.
     *
     * Params:
     *     codePoint  =     the UTF-32 char code
     */
    public void handleChar(uint charCode)
    {
        foreach (InputHandler* inputHandler; parallel(this.handlers)) {
            inputHandler.fire(InputType.CHAR, charCode);
        }
    }
}
