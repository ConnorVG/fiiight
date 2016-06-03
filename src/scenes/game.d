module fiiight.scenes.game;

import fiiight.core.scene : Scene;
import fiiight.core.platform.settings : Settings;
import fiiight.utils.input : InputFactory;

class GameScene : Scene
{
    /**
     * Loads everything necessary.
     *
     * Params:
     *     settings      =      the settings
     *     inputFactory  =      the input factory
     */
    void load(Settings* settings, InputFactory* inputFactory)
    { /** */ }

    /**
     * Unloads everything no longer necessary.
     */
    void unload()
    { /** */ }

    /**
     * Runs the scene.
     *
     * Params:
     *      tick  =        the tick duration
     */
    void run(const float tick)
    { /** */ }
}