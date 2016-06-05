module common.commands.command;

interface ICommand
{
    // ...
}

class DelegateCommand
{
    /**
     * The command handler;
     */
    protected void delegate() handler;

    /**
     * Construct the delegate command with a specific handler.
     */
    public this(void delegate() handler)
    {
        this.handler = handler;
    }

    /**
     * Executes the command.
     */
    public void execute()
    {
        this.handler();
    }
}
