module fiiight.core.scene;

import fiiight.core.platform.settings : Settings;
import fiiight.utils.input : InputFactory;
import fiiight.utils.gl : Programs;

interface Scene
{
    /**
     * Loads everything necessary.
     *
     * Params:
     *     settings      =      the settings
     *     inputFactory  =      the input factory
     *     programs      =      the programs
     */
    void load(Settings* settings, InputFactory* inputFactory, Programs* programs);

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
