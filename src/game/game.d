module game.game;

import game.state : IState;
import common : Settings;
import engine : Engine;

import derelict.glfw3.glfw3 : glfwPollEvents, glfwSwapBuffers;
import derelict.opengl3.gl3 : glClear, GL_COLOR_BUFFER_BIT, GL_DEPTH_BUFFER_BIT;

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
            810,
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

        float updateRateBase = 1000f / 30f;
        float updateRate = 1000f / this.settings.updateRate;
        float renderRate = 1000f / this.settings.renderRate;

        int updateDelay = 0;
        int renderDelay = 0;

        MonoTime before = MonoTime.currTime;

        auto window = this.engine.getGlfwWindow();

        while (this.running) {
            MonoTime now = MonoTime.currTime;
            Duration elapsed = now - before;
            long elapsedTotal = elapsed.total!"msecs";

            TaskPool taskPool;

            updateDelay += elapsedTotal;
            if (updateDelay >= 0) {
                glfwPollEvents();

                float updateTick = updateRate / updateRateBase;
                updateTick += updateTick * updateDelay / updateRate;

                taskPool = new TaskPool();
                state.update(updateTick, &taskPool);

                updateDelay = cast(int) -updateRate;
            }

            now = MonoTime.currTime;
            elapsed = now - before;
            elapsedTotal = elapsed.total!"msecs";

            renderDelay += elapsedTotal;
            if (renderDelay >= 0) {
                glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
                state.render();
                glfwSwapBuffers(window);

                renderDelay = cast(int) -renderRate;
            }

            // Not sure if this should just be in the update block or not, honestly.
            if (taskPool) {
                taskPool.finish(true);
            }

            int delay = updateDelay < renderDelay ? renderDelay : updateDelay;
            if (delay < 0) {
                Thread.sleep(dur!"msecs"(delay * -1));
            }

            before = now;
        }

        state.unload();

        this.engine.close();
    }

    /**
     * Stops the game.
     */
    public void stop()
    {
        this.running = false;
    }
}
