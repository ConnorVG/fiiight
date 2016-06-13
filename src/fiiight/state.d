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
    protected TextMatrixPolygon fpsPolygon;

    /**
     * The fps data.
     */
    protected TextPolygonData fpsData;

    /**
     * Debug shizzle.
     */
    protected TextPolygonData fpsChildData;

    /**
     * Recorded frame times.
     */
    protected ulong[] frames;

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

        this.fpsPolygon = new TextMatrixPolygon(TextMatrixPolygonFonts.DEFAULT);
        this.fpsPolygon.load(this.stateCollections.programs, this.stateCollections.textures);

        this.fpsData = new TextPolygonData("0 fps");

        this.fpsData.position.x = 0.015f;
        this.fpsData.position.y = 0.01f;

        this.fpsData.scale.x = 0.03f;
        this.fpsData.scale.y = 0.03f;

        this.fpsChildData = new TextPolygonData("this should be anchored around the fps counter! :-(");

        this.fpsChildData.position.x = 0.15f;
        this.fpsChildData.position.y = 0.01f;

        this.fpsChildData.scale.x = 0.6f;
        this.fpsChildData.scale.y = 0.6f;

        this.fpsChildData.parent = this.fpsData;
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
        this.camera.update(tick, taskPool);

        if (! this.scene) {
            return;
        }

        this.scene.update(tick, taskPool);

        this.fpsData.position.x += tick / 6000f;
        this.fpsData.position.y += tick / 6000f;
        this.fpsData.rotation += tick / 600f;
    }

    /**
     * Render the state.
     */
    public void render()
    {
        ulong now = MonoTime.currTime.ticks;

        this.frames ~= now;
        this.frames = this.frames.remove!(time => time + MonoTime.ticksPerSecond < now);

        this.fpsData.text = "%d fps".format(this.frames.length);

        if (this.frames.length <= 30) {
            this.fpsData.colour.r = 1.0f;
            this.fpsData.colour.g = 0.3f;
            this.fpsData.colour.b = 0.3f;
        } else if (this.frames.length <= 50) {
            this.fpsData.colour.r = 1.0f;
            this.fpsData.colour.g = 1.0f;
            this.fpsData.colour.b = 0.6f;
        } else {
            this.fpsData.colour.r = 0.6f;
            this.fpsData.colour.g = 1.0f;
            this.fpsData.colour.b = 0.6f;
        }

        this.renderState.clear();

        if (this.scene) {
            this.scene.render(this.renderState);
        }

        this.renderState.render(this.fpsPolygon, this.fpsData);
        this.renderState.render(this.fpsPolygon, this.fpsChildData);

        this.renderState.render(this.camera);
    }
}
