module game.game;

import game.state : IState;
import common : Settings;
import engine : Engine;

import derelict.glfw3.glfw3 : glfwPollEvents, glfwSwapBuffers;
import derelict.opengl3.gl3 :
    glClear, glEnable, glBlendFunc, glCullFace, glFrontFace,
    GL_BLEND, GL_SRC_ALPHA, GL_CULL_FACE, GL_BACK, GL_CCW,
    GL_COLOR_BUFFER_BIT, GL_DEPTH_BUFFER_BIT, GL_ONE_MINUS_SRC_ALPHA;

import std.parallelism : TaskPool;

import core.time : MonoTime, Duration, dur;
import core.thread : Thread;
import core.memory : GC;

struct Game
{
    /**
     * The engine.
     */
    private Engine* engine;

    /**
     * The settings.
     */
    private Settings* settings;

    /**
     * The running state.
     */
    private shared bool running = false;

    /**
     * We don't want the default construction to be possible.
     */
    @disable this();

    /**
     * Creates an instance of game.
     *
     * Params:
     *     engine    =      the engine
     *     settings  =      the settings
     *
     * Returns: a pointer to the game instance
     */
    public static Game* create(Engine* engine, Settings* settings)
    {
        Game* game = cast(Game*) GC.malloc(Game.sizeof);

        game.engine = engine;
        game.settings = settings;

        return game;
    }

    /**
     * Boots the game.
     */
    public void boot()
    {
        this.engine.boot();
    }

    /**
     * Starts the game.
     */
    public void start(IState* state)
    {
        this.engine.open(
            "fiiight [common:0.0.1, engine:0.0.1, game:0.0.1]",
            1080,
            608,
            this.settings.fullscreen,
            this.settings.borderless
        );

        state.load(this.engine.getInputFactory());

        this.run(state);
    }

    /**
     * Runs the game loop.
     */
    private void run(IState* state)
    {
        this.running = true;

        float updateRateBase = 1000000f / 30f;
        float updateRate = 1000000f / this.settings.updateRate;
        float renderRate = 1000000f / this.settings.renderRate;

        if (this.settings.renderRate == ubyte.max) {
            renderRate = 0;
        }

        int updateDelay = 0;
        int renderDelay = 0;

        auto window = this.engine.getGlfwWindow();

        MonoTime updateBefore = MonoTime.currTime;
        MonoTime renderBefore = MonoTime.currTime;
        MonoTime now;
        Duration elapsed;
        long elapsedTotal;
        while (this.running && ! this.engine.isClosed()) {
            now = MonoTime.currTime;
            elapsed = now - updateBefore;
            elapsedTotal = elapsed.total!"usecs";
            updateBefore = now;

            TaskPool taskPool;

            updateDelay += elapsedTotal;
            if (updateDelay >= -1) {
                glfwPollEvents();

                float updateTick = updateRate / updateRateBase;

                if (updateDelay > 0) {
                    updateTick += (updateDelay / updateRate) / updateRateBase;
                }

                taskPool = new TaskPool();
                state.update(updateTick, &taskPool);

                updateDelay = cast(int) -updateRate;
            }

            now = MonoTime.currTime;
            elapsed = now - renderBefore;
            elapsedTotal = elapsed.total!"usecs";
            renderBefore = now;

            renderDelay += elapsedTotal;
            if (renderDelay >= -1) {
                glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

                glEnable(GL_BLEND);
                glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

                //glEnable(GL_CULL_FACE);
                //glCullFace(GL_BACK);
                //glFrontFace(GL_CCW);

                state.render();

                glfwSwapBuffers(window);

                renderDelay = cast(int) -renderRate;
            }

            // Not sure if this should just be in the update block or not, honestly.
            if (taskPool) {
                taskPool.finish(true);
            }

            int delay = updateDelay < renderDelay ? renderDelay : updateDelay;
            if (delay < -1) {
                Thread.sleep(dur!"usecs"(delay * -1));
            }
        }

        if (! this.engine.isClosed()) {
            state.unload();

            this.engine.close();
        }
    }

    /**
     * Stops the game.
     */
    public void stop()
    {
        this.running = false;
    }
}
