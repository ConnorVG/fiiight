module engine.engine;

import engine.window : Window;
import engine.window.data : WindowUserData;
import engine.window.events : bindCallbacks;
import engine.input : InputFactory;
import common : Settings;

import derelict.glfw3.glfw3 : GLFWwindow, glfwSetWindowUserPointer;

import core.memory : GC;

struct Engine
{
    /**
     * The window.
     */
    private Window* window;

    /**
     * The window user data.
     */
    private WindowUserData* windowUserData;

    /**
     * The settings.
     */
    private Settings* settings;

    /**
     * The closed status.
     */
    private bool closed;

    /**
     * We don't want the default construction to be possible.
     */
    @disable this();

    /**
     * Creates an instance of engine.
     *
     * Params:
     *     settings  =      the settings
     *
     * Returns: a pointer to the engine instance
     */
    public static Engine* create(Settings* settings)
    {
        Engine* engine = cast(Engine*) GC.malloc(Engine.sizeof);

        engine.window = Window.create();
        engine.settings = settings;
        engine.closed = true;

        return engine;
    }

    /**
     * Boots the engine.
     */
    public void boot()
    {
        this.windowUserData = WindowUserData.create();

        this.windowUserData.engine = &this;
        this.windowUserData.inputFactory = InputFactory.create();
    }

    /**
     * Opens a window for the engine.
     *
     * Params:
     *      title       =       the title
     *      width       =       the title
     *      height      =       the title
     *      fullscreen  =       the title
     *      borderless  =       the title
     */
    public void open(
        string title = "[engine 0.0.1]",
        int width = 1080,
        int height = 810,
        bool fullscreen = this.settings.fullscreen,
        bool borderless = this.settings.borderless
    ) {
        this.window.open(title, width, height, fullscreen, borderless);

        glfwSetWindowUserPointer(this.window.pointer(), this.windowUserData);
        bindCallbacks(this.window.pointer());

        this.closed = false;
    }

    /**
     * Closes the engine window.
     *
     * Todo: game.stop()
     */
    public void close()
    {
        this.closed = true;

        this.window.close();
    }

    /**
     * Whether or not the window is closed.
     */
    public bool isClosed()
    {
        return this.closed;
    }

    /**
     * Get the GLFWwindow instance.
     *
     * Returns: the GLFWwindow instance
     */
    public InputFactory* getInputFactory()
    {
        return this.windowUserData.inputFactory;
    }

    /**
     * Get the GLFWwindow instance.
     *
     * Returns: the GLFWwindow instance
     */
    public GLFWwindow* getGlfwWindow()
    {
        return this.window.pointer();
    }
}
