module game.game;

import common : Settings;
import engine : Engine;

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
    public void start()
    {
        this.engine.open(
            "fiiight [common:0.0.1, engine:0.0.1, game:0.0.1]",
            1080,
            810,
            this.settings.fullscreen,
            this.settings.borderless
        );

        this.run();
    }

    /**
     * Runs the game loop.
     */
    private void run()
    {
        this.running = true;

        ubyte updateRate = cast(ubyte) (1000 / this.settings.updateRate);
        ubyte renderRate = cast(ubyte) (1000 / this.settings.renderRate);

        int updateDelay = 0;
        int renderDelay = 0;

        MonoTime before = MonoTime.currTime;

        while (this.running) {
            MonoTime now = MonoTime.currTime;
            Duration elapsed = now - before;
            long elapsedTotal = elapsed.total!"msecs";

            TaskPool taskPool;

            updateDelay += elapsedTotal;
            if (updateDelay >= 0) {
                float updateTick = updateRate / 32f;
                updateTick += updateTick * updateDelay / updateRate;

                taskPool = new TaskPool();
                // add updates to task pool

                updateDelay = 0 - updateRate;
            }

            renderDelay += elapsedTotal;
            if (renderDelay >= 0) {
                // ... render

                renderDelay = 0 - renderRate;
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
