module fiiight.state;

import game : IState;

import std.stdio : writeln;
import std.parallelism : TaskPool, task;

class State : IState
{
    /**
     * Load the state.
     */
    void load()
    { /** */ }

    /**
     * Unload the state.
     */
    void unload()
    { /** */ }

    /**
     * Update the state.
     *
     * Params:
     *      tick      =     the tick amount
     *      taskPool  =     the available task pool
     */
    public void update(const float tick, TaskPool* taskPool)
    {
        // ...
    }

    /**
     * Render the state.
     */
    public void render()
    { /** */ }
}
