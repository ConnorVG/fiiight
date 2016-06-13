module game.state;

import common : Programs;
import engine : Textures, Polygons, InputFactory;

import std.parallelism : TaskPool;

import core.memory : GC;

struct StateCollections
{
    /**
     * The programs.
     */
    public Programs* programs;

    /**
     * The textures.
     */
    public Textures* textures;

    /**
     * The polygons.
     */
    public Polygons* polygons;

    /**
     * The input factory.
     */
    public InputFactory* inputFactory;

    /**
     * Creates an instance of state collections.
     *
     * Params:
     *      programs      =     the programs
     *      textures      =     the textures
     *      polygons      =     the polygons
     *      inputFactory  =     the input factory
     *
     * Returns: a pointer to the state collections instance
     */
    public static StateCollections* create(Programs* programs, Textures* textures, Polygons* polygons, InputFactory* inputFactory)
    {
        StateCollections* collections = cast(StateCollections*) GC.malloc(StateCollections.sizeof);

        collections.programs = programs;
        collections.textures = textures;
        collections.polygons = polygons;
        collections.inputFactory = inputFactory;

        return collections;
    }

    /**
     * Clears the collections.
     */
    void clear()
    {
        this.programs.clear();
        this.textures.clear();
        this.polygons.clear();
        this.inputFactory.clear();
    }
}

interface IState
{
    /**
     * Load the state.
     */
    void load(InputFactory* inputFactory);

    /**
     * Unload the state.
     */
    void unload();

    /**
     * Update the state.
     *
     * Params:
     *      tick      =     the tick amount
     *      taskPool  =     the available task pool
     */
    void update(const float tick, TaskPool* taskPool);

    /**
     * Render the state.
     */
    void render();
}
