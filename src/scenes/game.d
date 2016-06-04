module fiiight.scenes.game;

import fiiight.core.scene : Scene;
import fiiight.core.platform.settings : Settings;
import fiiight.utils.input : InputFactory;
import fiiight.utils.gl : Programs;

class GameScene : Scene
{
    /**
     * Loads everything necessary.
     *
     * Params:
     *     settings      =      the settings
     *     inputFactory  =      the input factory
     *     programs      =      the programs
     */
    public void load(Settings* settings, InputFactory* inputFactory, Programs* programs)
    { /** */ }

    /**
     * Unloads everything no longer necessary.
     */
    public void unload()
    { /** */ }

    /**
     * Runs the scene.
     *
     * Params:
     *      tick  =        the tick duration
     */
    public void run(const float tick)
    { /** */ }
}
