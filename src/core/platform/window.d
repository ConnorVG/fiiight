module fiiight.core.platform.window;

import derelict.opengl3.gl3 :
    DerelictGL3, glClearColor, glClear,
    GL_COLOR_BUFFER_BIT, GL_DEPTH_BUFFER_BIT;
import derelict.glfw3.glfw3 :
    GLFWwindow, DerelictGLFW3, glfwSwapBuffers,
    glfwInit, glfwCreateWindow, glfwGetFramebufferSize, glfwSwapInterval,
    glfwMakeContextCurrent, glfwDestroyWindow, glfwTerminate;

debug import derelict.glfw3.glfw3 : glfwSetErrorCallback, glfwWindowHint, GLFW_OPENGL_DEBUG_CONTEXT;

import std.string : toStringz;

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

struct Window
{
    /**
     * The title.
     */
    private string _title;

    /**
     * The width.
     */
    private int _width;

    /**
     * The height.
     */
    private int _height;

    /**
     * The GLFWwindow instance.
     */
    private GLFWwindow* _glfwWindow;

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
        this._title = title;
        this._width = width;
        this._height = height;

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

        this._glfwWindow = glfwCreateWindow(
            this._width,
            this._height,
            this._title.toStringz(),
            null /** Fullscreen: glfwGetPrimaryMonitor() */,
            null
        );

        glfwGetFramebufferSize(this._glfwWindow, &this._width, &this._height);
        glfwMakeContextCurrent(this._glfwWindow);
        glfwSwapInterval(1);

        debug glfwWindowHint(GLFW_OPENGL_DEBUG_CONTEXT, 1);

        DerelictGL3.reload();

        glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

        glfwSwapBuffers(this._glfwWindow);

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

        glfwDestroyWindow(this._glfwWindow);
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
        return this._title;
    }

    /**
     * Get the width.
     *
     * Returns: the width
     */
    public int getWidth()
    {
        return this._width;
    }

    /**
     * Get the height.
     *
     * Returns: the height
     */
    public int getHeight()
    {
        return this._height;
    }

    /**
     * Get the GLFWwindow instance.
     *
     * Returns: the GLFWwindow instance
     */
    public GLFWwindow* getGlfwWindow()
    {
        return this._glfwWindow;
    }

    /**
     * Check if the window is open.
     *
     * Returns: if the window is open
     */
    public bool isOpen()
    {
        return this._glfwWindow != null;
    }
}
