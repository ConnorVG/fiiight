module fiiight.utils.input.commands;

/**
 * The base input command class.
 */
interface InputCommand { }

class KeyInputCommand : InputCommand
{
    /**
     * The command handler.
     */
    protected void delegate(bool, bool) handler;

    /**
     * Construct with the command handler.
     *
     * Params:
     *      handler  =      the command handler
     */
    public this(void delegate(bool, bool) handler)
    {
        this.handler = handler;
    }

    /**
     * Execute the command.
     *
     * Params:
     *      active    =     the state of the key
     *      repeated  =     if it's a repeat
     */
    public void execute(bool active, bool repeat)
    {
        this.handler(active, repeat);
    }
}

class CharInputCommand : InputCommand
{
    /**
     * The command handler.
     */
    protected void delegate(uint) handler;

    /**
     * Construct with the command handler.
     *
     * Params:
     *      handler  =      the command handler
     */
    public this(void delegate(uint) handler)
    {
        this.handler = handler;
    }

    /**
     * Execute the command.
     *
     * Params:
     *      charCode  =     the UTF-32 char code
     */
    public void execute(uint charCode)
    {
        this.handler(charCode);
    }
}
