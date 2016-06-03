module fiiight.core.game;

import fiiight.core.platform.settings : Settings;
import fiiight.core.platform.window : Window;
import fiiight.core.process : Process;

import derelict.opengl3.gl3 : glClear, GL_COLOR_BUFFER_BIT, GL_DEPTH_BUFFER_BIT;
import derelict.glfw3.glfw3 :
    GLFWwindow, glfwSetWindowUserPointer, glfwGetWindowUserPointer,
    glfwSetWindowCloseCallback, glfwPollEvents, glfwSwapBuffers;

import std.conv : to;

import core.memory : GC;
import core.time : MonoTime, Duration, dur;
import core.thread : Thread;

extern (C) {
    /**
     * Handle the GLFWwindow close event.
     *
     * Params:
     *     window  =        the window
     */
    void onClose(GLFWwindow* window) nothrow
    {
        Game* game = cast(Game*) glfwGetWindowUserPointer(window);

        try {
            game.stop();
        } catch (Exception e) { }
    }
}

struct Game
{
    /**
     * The settings.
     */
    private Settings* settings;

    /**
     * The window.
     */
    private Window* window;

    /**
     * The process.
     */
    private Process* process;

    /**
     * Whether the process is running or not.
     */
    private bool running = false;

    /**
     * We don't want the default construction to be possible.
     */
    @disable this();

    /**
     * Loads everything necessary.
     *
     * Params:
     *     settings  =      the settings
     */
    public void load(Settings* settings)
    {
        this.settings = settings;

        this.window = cast(Window*) GC.malloc(Window.sizeof);
        this.window.setup("fiiight", 1080, 810).open();

        GLFWwindow* window = this.window.getGlfwWindow();

        glfwSetWindowUserPointer(window, &this);
        glfwSetWindowCloseCallback(window, &onClose);

        this.process = cast(Process*) GC.malloc(Process.sizeof);
        this.process.load(settings);
    }

    /**
     * Unloads everything no longer necessary.
     */
    public void unload()
    {
        if (! this.window.isOpen()) {
            return;
        }

        this.window.close();
    }

    /**
     * Starts the game.
     */
    public void start()
    {
        this.running = true;

        this.run();
    }

    /**
     * Runs the main loop.
     */
    public void run()
    {
        GLFWwindow* window = this.window.getGlfwWindow();
        ulong rate = 1000L / this.settings.updateRate;
        MonoTime before = MonoTime.currTime;

        while (this.running) {
            glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

            MonoTime now = MonoTime.currTime;
            Duration elapsed = now - before;

            long delay = elapsed.total!"msecs" - rate;
            float tick = rate / 16f;

            if (delay > 0) {
                tick += tick * delay / rate;
            } else if (delay < 0) {
                Thread.sleep(dur!"msecs"(delay * -1));
            }

            this.process.run(tick);

            glfwSwapBuffers(window);
            glfwPollEvents();

            before = now;
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
