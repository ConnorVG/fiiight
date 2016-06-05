module engine.input.commands;

import engine.input.definitions : Key, MouseButton, Action, Modifier;
import common : ICommand;

class MouseInputCommand : ICommand
{
    /**
     * The command handler;
     */
    protected void delegate(MouseButton, Action, Modifier) handler;

    /**
     * Construct the delegate command with a specific handler.
     */
    public this(void delegate(MouseButton, Action, Modifier) handler)
    {
        this.handler = handler;
    }

    /**
     * Executes the command.
     */
    public void execute(MouseButton button, Action action, Modifier modifier)
    {
        this.handler(button, action, modifier);
    }
}


class KeyInputCommand : ICommand
{
    /**
     * The command handler;
     */
    protected void delegate(Key, Action, Modifier) handler;

    /**
     * Construct the delegate command with a specific handler.
     */
    public this(void delegate(Key, Action, Modifier) handler)
    {
        this.handler = handler;
    }

    /**
     * Executes the command.
     */
    public void execute(Key key, Action action, Modifier modifier)
    {
        this.handler(key, action, modifier);
    }
}

class CharInputCommand : ICommand
{
    /**
     * The command handler;
     */
    protected void delegate(wchar) handler;

    /**
     * Construct the delegate command with a specific handler.
     */
    public this(void delegate(wchar) handler)
    {
        this.handler = handler;
    }

    /**
     * Executes the command.
     */
    public void execute(wchar character)
    {
        this.handler(character);
    }
}
