module fiiight.core.game;

import fiiight.core.platform.settings : Settings;
import fiiight.core.platform.window : Window, WindowData;
import fiiight.core.process : Process;
import fiiight.utils.input : InputFactory;

import derelict.opengl3.gl3 : glClear, glGetError, GL_COLOR_BUFFER_BIT, GL_DEPTH_BUFFER_BIT, GL_NO_ERROR;
import derelict.glfw3.glfw3 :
    GLFWwindow, glfwSetWindowUserPointer, glfwGetWindowUserPointer,
    glfwSetWindowCloseCallback, glfwSetKeyCallback, glfwSetCharCallback,
    glfwPollEvents, glfwSwapBuffers;

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
        WindowData* data = cast(WindowData*) glfwGetWindowUserPointer(window);
        Game* game = data.game;

        try {
            game.stop();
        } catch (Exception e) { }
    }

    /**
     * Handle the GLFWwindow key input event.
     *
     * Params:
     *     window    =      the window
     *     key       =      the key
     *     scanCode  =      the scanCode
     *     action    =      the action
     *     mods      =      the mods
     */
    void onKeyInputEvent(GLFWwindow* window, int key, int scanCode, int action, int mods) nothrow
    {
        WindowData* data = cast(WindowData*) glfwGetWindowUserPointer(window);
        InputFactory* inputFactory = data.inputFactory;

        try {
            inputFactory.handleKey(key, scanCode, action, mods);
        } catch (Exception e) { }
    }

    /**
     * Handle the GLFWwindow char input event.
     *
     * Params:
     *     window    =      the window
     *     charCode  =      the UTF-32 char code
     */
    void onCharInputEvent(GLFWwindow* window, uint charCode) nothrow
    {
        WindowData* data = cast(WindowData*) glfwGetWindowUserPointer(window);
        InputFactory* inputFactory = data.inputFactory;

        try {
            inputFactory.handleChar(charCode);
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
     * The input factory.
     */
    private InputFactory* inputFactory;

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

        this.inputFactory = cast(InputFactory*) GC.calloc(InputFactory.sizeof);

        GLFWwindow* window = this.window.getGlfwWindow();

        glfwSetWindowUserPointer(window, WindowData.create(&this, this.inputFactory));

        glfwSetWindowCloseCallback(window, &onClose);

        glfwSetKeyCallback(window, &onKeyInputEvent);
        glfwSetCharCallback(window, &onCharInputEvent);

        this.process = cast(Process*) GC.calloc(Process.sizeof);
        this.process.load(this.settings, this.inputFactory);
    }

    /**
     * Unloads everything no longer necessary.
     */
    public void unload()
    {
        this.process.unload();

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
            MonoTime now = MonoTime.currTime;
            Duration elapsed = now - before;

            long delay = elapsed.total!"msecs" - rate;
            float tick = rate / 16f;

            if (delay > 0) {
                tick += tick * delay / rate;
            } else if (delay < 0) {
                Thread.sleep(dur!"msecs"(delay * -1));
            }

            glfwPollEvents();
            glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

            this.process.run(tick);

            glfwSwapBuffers(window);
            assert(glGetError() == GL_NO_ERROR, "GL error!");

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
