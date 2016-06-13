module fiiight.state;

import fiiight.scenes : MenuScene;
import common : Programs, DelegateCommand;
import engine : InputFactory, RenderState = State, Textures, Polygons, Camera, Key, TextMatrixPolygonFonts, TextMatrixPolygon, TextPolygonData;
import game : StateCollections, IState, IScene;

import std.format : format;
import std.algorithm : remove;
import std.parallelism : TaskPool;

import core.time : MonoTime, dur;

class State : IState
{
    /**
     * The render state.
     */
    protected RenderState* renderState;

    /**
     * The camera.
     */
    protected Camera* camera;

    /**
     * The state collections.
     */
    protected StateCollections* stateCollections;

    /**
     * The current scene.
     */
    protected IScene scene;

    /**
     * The fps polygon.
     */
    protected TextMatrixPolygon textPolygon;

    /**
     * The fps/tps data.
     */
    protected TextPolygonData psData;

    /**
     * Recorded frame times.
     */
    protected ulong[] frames;


    /**
     * Recorded tick times.
     */
    protected ulong[] ticks;

    /**
     * Load the state.
     */
    public void load(InputFactory* inputFactory)
    {
        this.renderState = RenderState.create();
        this.camera = Camera.create();

        this.stateCollections =  StateCollections.create(
            Programs.create(),
            Textures.create(),
            Polygons.create(),
            inputFactory
        );

        this.stateCollections.programs.load(
            "colour-matrix", "colour-matrix", "basic",
            [ "position" ],
            [ "colour", "model", "view" ]
        );

        this.stateCollections.programs.load(
            "texture-matrix", "texture-matrix", "texture",
            [ "position", "texture" ],
            [ "colour", "model", "view" ]
        );

        this.scene = new MenuScene();
        this.scene.load(this.stateCollections);

        this.textPolygon = new TextMatrixPolygon(TextMatrixPolygonFonts.DEFAULT);
        this.textPolygon.load(this.stateCollections.programs, this.stateCollections.textures);

        this.psData = new TextPolygonData("[0 fps]");

        this.psData.position.x = 0.01f;
        this.psData.position.y = 0.01f;

        this.psData.scale.x = 0.0125f;
        this.psData.scale.y = 0.03f;
    }

    /**
     * Unload the state.
     */
    public void unload()
    {
        this.scene.unload(this.stateCollections);
        this.scene = null;

        this.stateCollections.clear();
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
        ulong now = MonoTime.currTime.ticks;

        this.ticks ~= now;
        this.ticks = this.ticks.remove!(time => time + MonoTime.ticksPerSecond < now);

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
        ulong now = MonoTime.currTime.ticks;

        this.frames ~= now;
        this.frames = this.frames.remove!(time => time + MonoTime.ticksPerSecond < now);

        this.psData.text = "[%d fps]\n[%d tps]".format(this.frames.length, this.ticks.length);

        if (this.frames.length <= 30 || this.ticks.length < 15) {
            this.psData.colour.r = 1.0f;
            this.psData.colour.g = 0.3f;
            this.psData.colour.b = 0.3f;
        } else if (this.frames.length <= 50 || this.ticks.length < 25) {
            this.psData.colour.r = 1.0f;
            this.psData.colour.g = 1.0f;
            this.psData.colour.b = 0.6f;
        } else {
            this.psData.colour.r = 0.6f;
            this.psData.colour.g = 1.0f;
            this.psData.colour.b = 0.6f;
        }

        this.renderState.clear();

        if (this.scene) {
            this.scene.render(this.renderState);
        }

        this.renderState.render(this.textPolygon, this.psData);

        this.renderState.render(this.camera);
    }
}
