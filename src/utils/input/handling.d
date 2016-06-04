module fiiight.utils.input.handling;

import fiiight.utils.input.types : InputType;
import fiiight.utils.input.commands : InputCommand, KeyInputCommand, CharInputCommand;

import std.algorithm : remove;
import std.parallelism : parallel;

import core.memory : GC;

struct InputHandler
{
    /**
     * The handler's active state.
     */
    protected bool active = false;

    /**
     * The key command bindings.
     */
    protected KeyInputCommand[int] keyCommands;

    /**
     * The char command binding.
     */
    protected CharInputCommand charCommand;

    /**
     * We don't want the default construction to be possible.
     */
    @disable this();

    /**
     * Creates an input handler.
     *
     * Returns: the input handler pointer
     */
    public static InputHandler* create()
    {
        return cast(InputHandler*) GC.calloc(InputHandler.sizeof);
    }

    /**
     * Registers an input command.
     *
     * Params:
     *      type     =      the input type
     *      command  =      the command
     *      key      =      the key code
     */
    public void register(InputType type, InputCommand command, int key = int.max)
    {
        auto keyCommand = cast(KeyInputCommand) command;
        if (type == InputType.KEY && keyCommand) {
            this.keyCommands[key] = keyCommand;

            return;
        }

        auto charCommand = cast(CharInputCommand) command;
        if (type == InputType.CHAR && charCommand) {
            this.charCommand = charCommand;

            return;
        }
    }

    /**
     * Fires a key input command.
     *
     * Params:
     *      key       =     the key
     *      scanCode  =     the scanCode
     *      active    =     the state
     *      mods      =     the mods
     */
    public void fire(int key, int scanCode, bool active, int mods)
    {
        if (! this.active || key !in this.keyCommands) {
            return;
        }

        this.keyCommands[key].execute(active);
    }

    /**
     * Fires a char input command.
     *
     * Params:
     *      charCode  =     the UTF-32 char code
     */
    public void fire(uint charCode)
    {
        if (! this.active || ! this.charCommand) {
            return;
        }

        this.charCommand.execute(charCode);
    }

    /**
     * Activates the handler.
     */
    void activate()
    {
        this.active = true;
    }

    /**
     * Deactivates the handler.
     */
    void deactivate()
    {
        this.active = false;
    }

    /**
     * Clears the handler's mapping.
     */
    void clear()
    {
        this.keyCommands.clear();
        this.charCommand = null;
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
        this.handlers.remove!(a => a == inputHandler);
    }

    /**
     * Handles a key input event.
     *
     * Params:
     *      key       =     the key
     *      scanCode  =     the scanCode
     *      action    =     the action
     *      mods      =     the mods
     */
    public void handleKey(int key, int scanCode, int action, int mods)
    {
        // Don't support key-repeat.
        if (action > 1) {
            return;
        }

        foreach (InputHandler* inputHandler; parallel(this.handlers)) {
            inputHandler.fire(key, scanCode, action == 1, mods);
        }
    }

    /**
     * Handles a char input event.
     *
     * Params:
     *      codePoint  =        the UTF-32 char code
     */
    public void handleChar(uint charCode)
    {
        foreach (InputHandler* inputHandler; parallel(this.handlers)) {
            inputHandler.fire(charCode);
        }
    }
}
