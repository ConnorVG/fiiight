module fiiight.scenes.menu;

import common : DelegateCommand;
import engine : RenderState = State, InputFactory, InputHandler, Key, CharInputCommand;
import game : StateCollections, IScene, UI;

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
     *      stateCollections  =     the state collections
     */
    public void load(StateCollections* stateCollections)
    {
        this.ui = UI.create();

        this.ui.load(stateCollections);

        this.bind(stateCollections.inputFactory);
    }

    /**
     * Unloads the scene.
     *
     * Params:
     *      stateCollections  =     the state collections
     */
    public void unload(StateCollections* stateCollections)
    {
        this.unbind(stateCollections.inputFactory);

        this.ui.unload(stateCollections);
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
        // if we have a background scene, update that? idk

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
        // if we have a background scene, render that

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
        this.inputHandler.activate();

        this.inputHandler.register(new DelegateCommand(&this.ui.next), Key.DOWN);
        this.inputHandler.register(new DelegateCommand(&this.ui.previous), Key.UP);

        this.inputHandler.register(new DelegateCommand(&this.ui.select), Key.ENTER);
        this.inputHandler.register(new DelegateCommand(&this.ui.deselect), Key.ESCAPE);

        this.inputHandler.register(new DelegateCommand(&this.ui.increase), Key.RIGHT);
        this.inputHandler.register(new DelegateCommand(&this.ui.decrease), Key.LEFT);

        this.inputHandler.register(new CharInputCommand(&this.ui.character));

        this.inputHandler.register(new DelegateCommand(&this.ui.clear!1), Key.BACKSPACE);
        this.inputHandler.register(new DelegateCommand(&this.ui.clear), Key.DELETE);

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
