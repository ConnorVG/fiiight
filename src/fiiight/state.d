module fiiight.state;

import fiiight.scenes : MenuScene;
import common : Programs, Program, DelegateCommand;
import engine : InputFactory, InputHandler, RenderState = State, Textures, Polygons, Camera, Key;
import game : IState, IScene;

import std.parallelism : TaskPool;

class State : IState
{
    /**
     * The input factory.
     */
    protected InputFactory* inputFactory;

    /**
     * The render state.
     */
    protected RenderState* renderState;

    /**
     * The camera.
     */
    protected Camera* camera;

    /**
     * The program collection.
     */
    protected Programs* programs;

    /**
     * The texture collection.
     */
    protected Textures* textures;

    /**
     * The polygon collection.
     */
    protected Polygons* polygons;

    /**
     * The current scene.
     */
    protected IScene scene;

    /**
     * Load the state.
     */
    void load(InputFactory* inputFactory)
    {
        this.inputFactory = inputFactory;

        this.renderState = RenderState.create();
        this.camera = Camera.create();

        this.programs = Programs.create();

        this.programs.load(
            "colour-matrix", "colour-matrix", "basic",
            [ "position" ],
            [ "colour", "model", "view" ]
        );

        this.programs.load(
            "texture-matrix", "texture-matrix", "texture",
            [ "position", "texture" ],
            [ "colour", "model", "view" ]
        );

        this.textures = Textures.create();
        this.polygons = Polygons.create();

        this.scene = new MenuScene();
        this.scene.load(this.programs, this.textures, this.polygons, this.inputFactory);
    }

    /**
     * Unload the state.
     */
    void unload()
    {
        this.scene.unload(this.programs, this.textures, this.polygons, this.inputFactory);
        this.scene = null;

        //this.programs.clear();
        this.polygons.clear();
        this.textures.clear();

        this.renderState.clear();
        this.inputFactory.clear();
    }

    /**
     * Update the state.
     *
     * Params:
     *      tick      =     the tick amount
     *      taskPool  =     the available task pool
     */
    public void update(const float tick, TaskPool* taskPool)
    {
        this.camera.update(tick, taskPool);

        if (! this.scene) {
            return;
        }

        this.scene.update(tick, taskPool);
    }

    /**
     * Render the state.
     */
    public void render()
    {
        this.renderState.clear();

        if (this.scene) {
            this.scene.render(this.renderState);
        }

        this.renderState.render(this.camera);
    }
}
