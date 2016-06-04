module fiiight.rendering.two_d.frame;

import fiiight.rendering.two_d.component : Component;

import derelict.glfw3.glfw3 : GLFWwindow, glfwGetCurrentContext, glfwGetFramebufferSize;
import derelict.opengl3.gl3 : glViewport;

import std.algorithm : remove;
import std.parallelism : parallel;

import core.memory : GC;

struct Frame
{
    /**
     * The components.
     */
    private Component[] components;

    /**
     * The viewport x position.
     */
    private int x;

    /**
     * The viewport y position.
     */
    private int y;

    /**
     * The viewport width.
     */
    private int width;

    /**
     * The viewport height.
     */
    private int height;

    /**
     * We don't want the default construction to be possible.
     */
    @disable this();

    /**
     * Creates a frame.
     *
     * Returns: the frame pointer
     */
    public static Frame* create(float x = 0.0f, float y = 0.0f, float width = 1.0f, float height = 1.0f)
    {
        Frame* frame = cast(Frame*) GC.calloc(Frame.sizeof);

        GLFWwindow* window = glfwGetCurrentContext();
        int windowWidth, windowHeight;
        glfwGetFramebufferSize(window, &windowWidth, &windowHeight);

        frame.x = cast(int) (x * windowWidth);
        frame.width = cast(int) (width * windowWidth);
        frame.y = cast(int) (y * windowHeight);
        frame.height = cast(int) (height * windowHeight);

        return frame;
    }

    /**
     * Runs the frame.
     *
     * Params:
     *      tick  =        the tick duration
     */
    public void run(const float tick)
    {
        foreach (Component component; parallel(this.components)) {
            component.update(tick);
        }

        //glViewport(this.x, this.y, this.width, this.height);
        foreach (Component component; this.components) {
            component.render(tick);
        }
    }

    /**
     * Add a component.
     *
     * Params:
     *      component  =     the component
     */
    public void add(Component component)
    {
        component.load();

        this.components ~= component;
    }

    /**
     * Remove a component.
     *
     * Params:
     *      component  =     the component
     */
    public void remove(Component component)
    {
        this.components.remove!(a => a == component);

        component.unload();
    }

    /**
     * Clears the components.
     */
    public void clear()
    {
        foreach (Component component; parallel(this.components)) {
            this.remove(component);
        }
    }
}
