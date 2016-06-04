module fiiight.core.platform.window;

import fiiight.core.game : Game;
import fiiight.utils.input : InputFactory;

import derelict.opengl3.gl3 :
    DerelictGL3, GLuint, glClearColor, glClear,
    glGenVertexArrays, glBindVertexArray,
    GL_COLOR_BUFFER_BIT, GL_DEPTH_BUFFER_BIT, GL_TRUE, GL_FALSE;
import derelict.glfw3.glfw3 :
    GLFWwindow, DerelictGLFW3, glfwSwapBuffers,
    glfwInit, glfwCreateWindow, glfwGetFramebufferSize, glfwSwapInterval,
    glfwMakeContextCurrent, glfwDestroyWindow, glfwTerminate,
    GLFW_SAMPLES, GLFW_CONTEXT_VERSION_MAJOR, GLFW_CONTEXT_VERSION_MINOR, GLFW_RESIZABLE,
    GLFW_OPENGL_FORWARD_COMPAT, GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE;

debug import derelict.glfw3.glfw3 : glfwSetErrorCallback, glfwWindowHint, GLFW_OPENGL_DEBUG_CONTEXT;

import std.string : toStringz;

import core.memory : GC;

debug {
    import std.stdio : stderr;

    extern(C) {
        /**
         * Handles GLFW error messages.
         *
         * Params:
         *      error        =      the error code
         *      description  =      the error descriptionI
         */
        void glfwErrorCallback(int error, const(char)* description) nothrow
        {
            try {
                stderr.writef("GLFW Error[%d]: %s", error, description);
            } catch (Exception e) { }
        }
    }
}

struct WindowData
{
    /**
     * The game instance.
     */
    public Game* game;

    /**
     * The input factory instance.
     */
    public InputFactory* inputFactory;

    /**
     * We don't want the default construction to be possible.
     */
    @disable this();

    /**
     * Creates for a specific game and input.
     *
     * Params:
     *      game          =     the game instance
     *      inputFactory  =     the input factory instance
     *
     * Returns: this
     */
    public static create(Game* game, InputFactory* inputFactory)
    {
        WindowData* data = cast(WindowData*) GC.malloc(WindowData.sizeof);

        data.game = game;
        data.inputFactory = inputFactory;

        return data;
    }
}

struct Window
{
    /**
     * The title.
     */
    private string title;

    /**
     * The width.
     */
    private int width;

    /**
     * The height.
     */
    private int height;

    /**
     * The GLFWwindow instance.
     */
    private GLFWwindow* glfwWindow;

    /**
     * We don't want the default construction to be possible.
     */
    @disable this();

    /**
     * Sets up the window.
     *
     * Params:
     *     title  =     the title
     *     width  =     the width
     *     height =     the height
     *
     * Returns: this
     */
    public Window* setup(const string title = "fiiight", const int width = 800, const int height = 600)
    {
        this.title = title;
        this.width = width;
        this.height = height;

        return &this;
    }

    /**
     * Opens the window.
     *
     * Returns: this
     */
    public Window* open()
    {
        DerelictGL3.load();
        DerelictGLFW3.load();

        debug glfwSetErrorCallback(&glfwErrorCallback);

        glfwInit();

        debug glfwWindowHint(GLFW_OPENGL_DEBUG_CONTEXT, 1);

        //glfwWindowHint(GLFW_SAMPLES, 4);
        glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 4);
        glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 5);
        glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE);
        glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
        glfwWindowHint(GLFW_RESIZABLE, GL_FALSE);

        this.glfwWindow = glfwCreateWindow(
            this.width,
            this.height,
            this.title.toStringz(),
            null /** Fullscreen: glfwGetPrimaryMonitor() */,
            null
        );

        glfwGetFramebufferSize(this.glfwWindow, &this.width, &this.height);
        glfwMakeContextCurrent(this.glfwWindow);

        DerelictGL3.reload();

        glfwSwapInterval(0);

        // Beautiful "Cornflower Blue"
        glClearColor(0.39f, 0.58f, 0.92f, 1.0f);
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

        glfwSwapBuffers(this.glfwWindow);

        return &this;
    }

    /**
     * Closes the window.
     *
     * Returns: this
     */
    public Window* close()
    {
        if (! this.isOpen()) {
            return &this;
        }

        glfwDestroyWindow(this.glfwWindow);
        glfwTerminate();

        return &this;
    }

    /**
     * Get the window title.
     *
     * Returns: the window title
     */
    public string getTitle()
    {
        return this.title;
    }

    /**
     * Get the width.
     *
     * Returns: the width
     */
    public int getWidth()
    {
        return this.width;
    }

    /**
     * Get the height.
     *
     * Returns: the height
     */
    public int getHeight()
    {
        return this.height;
    }

    /**
     * Get the GLFWwindow instance.
     *
     * Returns: the GLFWwindow instance
     */
    public GLFWwindow* getGlfwWindow()
    {
        return this.glfwWindow;
    }

    /**
     * Check if the window is open.
     *
     * Returns: if the window is open
     */
    public bool isOpen()
    {
        return this.glfwWindow != null;
    }
}
