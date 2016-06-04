module fiiight.scenes.loading;

import fiiight.core.scene : Scene;
import fiiight.core.platform.settings : Settings;
import fiiight.utils.input : InputFactory;

class LoadingScene : Scene
{
    /**
     * Loads everything necessary.
     *
     * Params:
     *     settings      =      the settings
     *     inputFactory  =      the input factory
     */
    public void load(Settings* settings, InputFactory* inputFactory)
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
