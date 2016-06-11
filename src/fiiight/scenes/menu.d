module fiiight.scenes.menu;

import common : Programs, DelegateCommand;
import engine : Textures, Polygons, RenderState = State, InputFactory, InputHandler, Key, CharInputCommand;
import game : IScene, UI;

import std.parallelism : TaskPool;

class MenuScene : IScene
{
    /**
     * The current ui.
     */
    protected UI* ui;

    /**
     * The input handler.
     */
    protected InputHandler* inputHandler;

    /**
     * Loads the scene.
     *
     * Params:
     *      programs  =     the program collection
     *      textures  =     the texture collection
     *      polygons  =     the polygon collection
     */
    public void load(Programs* programs, Textures* textures, Polygons* polygons, InputFactory* inputFactory)
    {
        this.ui = UI.create();
        this.ui.load(programs, textures, polygons);

        this.bind(inputFactory);
    }

    /**
     * Unloads the scene.
     */
    public void unload(Programs* programs, Textures* textures, Polygons* polygons, InputFactory* inputFactory)
    {
        this.unbind(inputFactory);

        this.ui.unload(programs, textures, polygons);
    }

    /**
     * Update the scene.
     *
     * Params:
     *      tick      =     the tick amount
     *      taskPool  =     the available task pool
     */
    public void update(const float tick, TaskPool* taskPool)
    {
        this.ui.update(tick, taskPool);
    }

    /**
     * Renders the scene.
     *
     * Params:
     *      renderState  =      the render state
     */
    public void render(RenderState* renderState)
    {
        this.ui.render(renderState);
    }

    /**
     * Bind UI inputs.
     *
     * Params:
     *      inputFactory  =     the input factory
     */
    protected void bind(InputFactory* inputFactory)
    {
        this.inputHandler = InputHandler.create();

        this.inputHandler.register(new DelegateCommand(&this.ui.next), Key.DOWN);
        this.inputHandler.register(new DelegateCommand(&this.ui.previous), Key.UP);

        this.inputHandler.register(new DelegateCommand(&this.ui.select), Key.ENTER);
        this.inputHandler.register(new DelegateCommand(&this.ui.deselect), Key.ESCAPE);

        this.inputHandler.register(new DelegateCommand(&this.ui.increase), Key.RIGHT);
        this.inputHandler.register(new DelegateCommand(&this.ui.decrease), Key.LEFT);

        this.inputHandler.register(new CharInputCommand(&this.ui.character));

         this.inputHandler.register(new DelegateCommand(&this.ui.clear!(1)), Key.BACKSPACE);
        this.inputHandler.register(new DelegateCommand(&this.ui.clear), Key.DELETE);

        this.inputHandler.activate();
        inputFactory.register(this.inputHandler);
    }

    /**
     * Unbind UI inputs.
     *
     * Params:
     *      inputFactory  =     the input factory
     */
    protected void unbind(InputFactory* inputFactory)
    {
        this.inputHandler.deactivate();
        this.inputHandler.clear();

        inputFactory.unregister(this.inputHandler);

        delete this.inputHandler;
    }
}
