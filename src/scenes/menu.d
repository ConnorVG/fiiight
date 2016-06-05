module fiiight.scenes.menu;

import fiiight.core.scene : Scene;
import fiiight.core.platform.settings : Settings;
import fiiight.utils.gl : Programs;
import fiiight.utils.input : InputFactory, InputHandler;
import fiiight.rendering.two_d.frame : Frame;
import fiiight.rendering.two_d.components : ButtonComponent;

import derelict.glfw3.glfw3 : GLFW_KEY_UP, GLFW_KEY_DOWN;

import std.stdio : writeln;

enum MenuSceneType {
    MAIN_MENU,
}

class MenuScene : Scene
{
    /**
     * The input factory.
     */
    protected InputFactory* inputFactory;

    /**
     * The input handler.
     */
    protected InputHandler* inputHandler;

    /**
     * The programs.
     */
    protected Programs* programs;

    /**
     * The frame.
     */
    protected Frame* frame;

    protected ButtonComponent[] buttons;
    protected uint selected = 0;

    /**
     * Constructs a specific type of menu scene.
     *
     * Params:
     *      type  =     the menu scene type
     */
    public this(MenuSceneType type)
    { /** @todo */ }

    /**
     * Loads everything necessary.
     *
     * Params:
     *     settings      =      the settings
     *     inputFactory  =      the input factory
     *     programs      =      the programs
     */
    public void load(Settings* settings, InputFactory* inputFactory, Programs* programs)
    {
        this.inputFactory = inputFactory;
        this.inputHandler = InputHandler.create();

        this.inputHandler.register(&onUp, GLFW_KEY_UP);
        this.inputHandler.register(&onDown, GLFW_KEY_DOWN);

        this.inputHandler.activate();
        this.inputFactory.register(this.inputHandler);

        this.programs = programs;

        this.frame = Frame.create(this.programs);

        this.buttons = [
            new ButtonComponent(0.1f, 0.1f, 0.8f, 0.1f),
            new ButtonComponent(0.1f, 0.3f, 0.8f, 0.1f),
            new ButtonComponent(0.1f, 0.5f, 0.8f, 0.1f),
            new ButtonComponent(0.1f, 0.7f, 0.8f, 0.1f),
        ];

        this.frame.add(this.buttons[0]);
        this.frame.add(this.buttons[1]);
        this.frame.add(this.buttons[2]);
        this.frame.add(this.buttons[3]);

        this.buttons[0].select();
    }

    /**
     * Unloads everything no longer necessary.
     */
    public void unload()
    {
        this.frame.clear();
        this.frame = null;

        this.inputFactory.unregister(this.inputHandler);

        this.inputHandler.clear();
        this.inputHandler = null;
    }

    /**
     * Runs the scene.
     *
     * Params:
     *      tick  =        the tick duration
     */
    public void run(const float tick)
    {
        this.frame.run(tick);
    }

    void onUp(bool active, bool repeated)
    {
        if (! active) {
            return;
        }

        this.buttons[this.selected].deselect();
        this.selected = (this.selected - 1) % this.buttons.length;
        this.buttons[this.selected].select();
    }

    void onDown(bool active, bool repeated)
    {
        if (! active) {
            return;
        }

        this.buttons[this.selected].deselect();
        this.selected = (this.selected + 1) % this.buttons.length;
        this.buttons[this.selected].select();
    }
}
