module engine.input.handling;

import engine.input.definitions : Key, MouseButton, Modifier, Action;
import engine.input.commands : KeyInputCommand, CharInputCommand, MouseInputCommand;
import common : ICommand, DelegateCommand;

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
     * The mouse command bindings.
     */
    protected ICommand[int] mouseCommands;

    /**
     * The key command bindings.
     */
    protected ICommand[int] keyCommands;

    /**
     * The char command bindings.
     */
    protected ICommand[] charCommands;

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
     * Registers a mouse input command.
     *
     * Params:
     *      command  =      the command
     *      button   =      the mouse button
     */
    public void register(ICommand command, MouseButton button)
    {
        this.mouseCommands[button] = command;
    }

    /**
     * Registers a key input command.
     *
     * Params:
     *      command  =      the command
     *      key      =      the key
     */
    public void register(ICommand command, Key key)
    {
        this.keyCommands[key] = command;
    }

    /**
     * Registers a char input command.
     *
     * Params:
     *      command  =      the command
     */
    public void register(ICommand command)
    {
        this.charCommands ~= command;
    }

    /**
     * Unregister a mouse input command.
     *
     * Params:
     *      command  =      the command
     *      button   =      the mouse button
     */
    public void unregister(ICommand command, MouseButton button)
    {
        this.mouseCommands.remove(button);
    }

    /**
     * Unregister a key input command.
     *
     * Params:
     *      command  =      the command
     *      key      =      the key
     */
    public void unregister(ICommand command, Key key)
    {
        this.keyCommands.remove(key);
    }

    /**
     * Unregister a char input command.
     *
     * Params:
     *      command  =      the command
     */
    public void unregister(ICommand command)
    {
        this.charCommands.remove!(val => val == command);
    }

    /**
     * Fires a command handler for mouse input.
     *
     * Params:
     *      button    =     the button
     *      action    =     the action
     *      modifier  =     the modifier
     */
    public void fire(MouseButton button, Action action, Modifier modifier)
    {
        foreach (ref command; parallel(this.mouseCommands.byValue())) {
            if (auto mouseCommand = cast(MouseInputCommand) command) {
                mouseCommand.execute(button, action, modifier);
            }

            if (auto delegateCommand = cast(DelegateCommand) command) {
                delegateCommand.execute();
            }
        }
    }

    /**
     * Fires a command handler for key input.
     *
     * Params:
     *      key       =     the key
     *      action    =     the action
     *      modifier  =     the modifier
     */
    public void fire(Key key, Action action, Modifier modifier)
    {
        foreach (ref command; parallel(this.keyCommands.byValue())) {
            if (auto keyCommand = cast(KeyInputCommand) command) {
                keyCommand.execute(key, action, modifier);
            }

            if (auto delegateCommand = cast(DelegateCommand) command) {
                delegateCommand.execute();
            }
        }
    }

    /**
     * Fires a command handler for character input.
     *
     * Params:
     *      character  =        the character
     */
    public void fire(wchar character)
    {
        foreach (ref command; parallel(this.charCommands)) {
            if (auto charCommand = cast(CharInputCommand) command) {
                charCommand.execute(character);
            }

            if (auto delegateCommand = cast(DelegateCommand) command) {
                delegateCommand.execute();
            }
        }
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
        this.mouseCommands.clear();
        this.keyCommands.clear();
        this.charCommands = [];
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
     * Creates an input factory.
     *
     * Returns: the input factory pointer
     */
    public static InputFactory* create()
    {
        return cast(InputFactory*) GC.calloc(InputFactory.sizeof);
    }

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
        this.handlers.remove!(handler => handler == inputHandler);
    }

    /**
     * Handles a mouse input event.
     *
     * Params:
     *      button    =     the button
     *      action    =     the action
     *      modifier  =     the modifier
     */
    public void handleMouse(MouseButton button, Action action, Modifier modifier)
    {
        foreach (InputHandler* inputHandler; parallel(this.handlers)) {
            inputHandler.fire(button, action, modifier);
        }
    }

    /**
     * Handles a key input event.
     *
     * Params:
     *      key       =     the key
     *      action    =     the action
     *      modifier  =     the modifier
     */
    public void handleKey(Key key, Action action, Modifier modifier)
    {
        foreach (InputHandler* inputHandler; parallel(this.handlers)) {
            inputHandler.fire(key, action, modifier);
        }
    }

    /**
     * Handles a char input event.
     *
     * Params:
     *      character  =        the character
     */
    public void handleChar(wchar character)
    {
        foreach (InputHandler* inputHandler; parallel(this.handlers)) {
            inputHandler.fire(character);
        }
    }
}
