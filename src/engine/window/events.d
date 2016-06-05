module engine.window.events;

import engine.window.data : WindowUserData;
import engine.input.definitions : Key, MouseButton, Action, Modifier;

import derelict.glfw3.glfw3 :
    GLFWwindow, glfwSetMouseButtonCallback, glfwGetWindowUserPointer, glfwSetWindowCloseCallback, glfwSetKeyCallback, glfwSetCharCallback;

extern (C) {
    /**
     * Handle the GLFWwindow close event.
     *
     * Params:
     *     window  =        the window
     */
    void onClose(GLFWwindow* window) nothrow
    {
        WindowUserData* data = cast(WindowUserData*) glfwGetWindowUserPointer(window);

        auto engine = data.engine;

        try {
            engine.close();
        } catch (Exception e) { }
    }

    /**
     * Handle the GLFWwindow mouse input event.
     *
     * Params:
     *     window    =      the window
     *     charCode  =      the UTF-32 char code
     */
    void onMouseInputEvent(GLFWwindow* window, int button, int action, int mods) nothrow
    {
        WindowUserData* data = cast(WindowUserData*) glfwGetWindowUserPointer(window);

        auto inputFactory = data.inputFactory;

        try {
            inputFactory.handleMouse(cast(MouseButton) MouseButton(button), cast(Action) Action(action), cast(Modifier) Modifier(mods));
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
        WindowUserData* data = cast(WindowUserData*) glfwGetWindowUserPointer(window);

        auto inputFactory = data.inputFactory;

        try {
            inputFactory.handleKey(cast(Key) Key(key), cast(Action) Action(action), cast(Modifier) Modifier(mods));
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
        WindowUserData* data = cast(WindowUserData*) glfwGetWindowUserPointer(window);

        auto inputFactory = data.inputFactory;

        try {
            inputFactory.handleChar(cast(wchar) charCode);
        } catch (Exception e) { }
    }
}

/**
 * Bind all related window events.
 *
 * Params:
 *      window  =       the glfw window instance
 */
void bindCallbacks(GLFWwindow* window)
{
    glfwSetWindowCloseCallback(window, &onClose);

    glfwSetMouseButtonCallback(window, &onMouseInputEvent);
    glfwSetKeyCallback(window, &onKeyInputEvent);
    glfwSetCharCallback(window, &onCharInputEvent);
}
