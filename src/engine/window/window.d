module engine.window.window;

import engine.window.data : WindowUserData;

import derelict.opengl3.gl3;
import derelict.glfw3.glfw3;

debug import derelict.glfw3.glfw3 : glfwSetErrorCallback, GLFW_OPENGL_DEBUG_CONTEXT;

import std.string : toStringz;

import core.memory : GC;

debug {
    import std.conv : to;
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
                stderr.writef("GLFW Error[%d]: %s", error, to!string(description));
            } catch (Exception e) { }
        }
    }
}

struct Window
{
    /**
     * The GLFWwindow instance.
     */
    protected GLFWwindow* glfwWindow;

    /**
     * The frame width.
     */
    protected int width;

    /**
     * The frame height.
     */
    protected int height;

    /**
     * We don't want the default construction to be possible.
     */
    @disable this();

    /**
     * Creates an instance of window.
     *
     * Returns: a pointer to the window instance
     */
    public static Window* create()
    {
        return cast(Window*) GC.malloc(Window.sizeof);
    }

    /**
     * Opens the window.
     *
     * Params:
     *      title       =       the title
     *      width       =       the width
     *      height      =       the height
     *      fullscreen  =       whether or not to be fullscreen
     *      borderless  =       whether or not to be borderless
     */
    public void open(string title, int width, int height, bool fullscreen, bool borderless) {
        DerelictGL3.load();

        version (Win64) {
            DerelictGLFW3.load("./lib/glfw3-win64.dll");
        } else version (Win32) {
            DerelictGLFW3.load("./lib/glfw3-win32.dll");
        } else {
            DerelictGLFW3.load("./lib/libglfw.so");
        }

        debug glfwSetErrorCallback(&glfwErrorCallback);

        glfwInit();

        debug glfwWindowHint(GLFW_OPENGL_DEBUG_CONTEXT, GL_TRUE);

        glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 4);
        glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 5);

        glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE);
        glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);

        glfwWindowHint(GLFW_SAMPLES, 4);
        glfwWindowHint(GLFW_RESIZABLE, GL_FALSE);

        if (borderless) {
            const GLFWvidmode* mode = glfwGetVideoMode(glfwGetPrimaryMonitor());

            glfwWindowHint(GLFW_RED_BITS, mode.redBits);
            glfwWindowHint(GLFW_GREEN_BITS, mode.greenBits);
            glfwWindowHint(GLFW_BLUE_BITS, mode.blueBits);
            glfwWindowHint(GLFW_REFRESH_RATE, mode.refreshRate);
        }

        this.glfwWindow = glfwCreateWindow(
            width,
            height,
            title.toStringz(),
            fullscreen ? glfwGetPrimaryMonitor() : null,
            null
        );

        glfwGetFramebufferSize(this.glfwWindow, &this.width, &this.height);
        glfwMakeContextCurrent(this.glfwWindow);

        DerelictGL3.reload();

        // Beautiful "Cornflower Blue"
        glClearColor(0.39f, 0.58f, 0.92f, 1.0f);
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

        glfwSwapBuffers(this.glfwWindow);
    }

    /**
     * Close the window.
     */
    public void close()
    {
        if (! this.glfwWindow) {
            return;
        }

        glfwDestroyWindow(this.glfwWindow);
        glfwTerminate();
    }

    /**
     * Get the GLFWwindow instance.
     *
     * Returns: the GLFWwindow instance
     */
    public GLFWwindow* pointer()
    {
        return this.glfwWindow;
    }
}
