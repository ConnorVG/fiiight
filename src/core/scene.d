module fiiight.core.scene;

import fiiight.core.platform.settings;
import fiiight.utils.input : InputFactory;

interface Scene
{
    /**
     * Loads everything necessary.
     *
     * Params:
     *     settings      =      the settings
     *     inputFactory  =      the input factory
     */
    void load(Settings* settings, InputFactory* inputFactory);

    /**
     * Unloads everything no longer necessary.
     */
    void unload();

    /**
     * Runs the scene.
     *
     * Params:
     *      tick  =        the tick duration
     */
    void run(const float tick);
}
