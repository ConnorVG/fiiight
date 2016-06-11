module game.ui.ui;

import common : Programs;
import engine : Textures, Polygons, RenderState = State;

import std.parallelism : TaskPool;
import std.stdio : writeln;

import core.memory : GC;

struct UI
{
    // need some sort of NodeList/Tree<IComponent>
    //
    // can traverse with next/prev and preferably always
    // hold a pointer to it's parent just incase we're in
    // a nested / child NodeList/Tree...

    // temp/debug input
    protected string input = "";

    /**
     * We don't want the default construction to be possible.
     */
    @disable this();

    /**
     * Creates a collection of polygons.
     *
     * Returns: the polygons pointer
     */
    public static UI* create()
    {
        return cast(UI*) GC.calloc(UI.sizeof);
    }

    /**
     * Loads the scene.
     *
     * Params:
     *      programs  =     the program collection
     *      textures  =     the texture collection
     *      polygons  =     the polygon collection
     */
    public void load(Programs* programs, Textures* textures, Polygons* polygons)
    {
        // we'll need to know everything the entire menu (including it's children) needs
    }

    /**
     * Unloads the scene.
     *
     * Params:
     *      programs  =     the program collection
     *      textures  =     the texture collection
     *      polygons  =     the polygon collection
     */
    public void unload(Programs* programs, Textures* textures, Polygons* polygons)
    {
        // see above func
    }

    /**
     * Update the scene.
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
     * Renders the scene.
     *
     * Params:
     *      renderState  =      the render state
     */
    public void render(RenderState* renderState)
    {
        // ...
    }

    // generic movement
    public void next() { writeln("next menu item"); }
    public void previous() { writeln("previous menu item"); }

    // generic selection
    public void select() { writeln("enter sub menu / fire button handler"); }
    public void deselect() { writeln("exit menu / fire quit handler"); }

    // generic increase/decrease
    public void increase() { writeln("increase generic input bool / slider"); }
    public void decrease() { writeln("decrease generic input bool / slider"); }

    // generic character
    public void character(wchar character)
    {
        if (this.input.length >= ubyte.max || (character == ' ' && (this.input.length == 0 || this.input[this.input.length - 1] == ' '))) {
            return;
        }

        this.input ~= character;

        writeln("input: '", this.input, "'");
    }

    // generic clear
    public void clear()
    {
        this.input = "";

        writeln("input: '", this.input, "'");
    }

    // generic partial clear
    public void clear(ubyte count)()
    {
        if (this.input.length > 0) {
            if (count > this.input.length) {
                this.clear();

                return;
            }

            this.input = this.input[0..(this.input.length - count)];
        }

        writeln("input: '", this.input, "'");
    }

}
