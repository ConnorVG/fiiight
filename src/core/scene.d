module fiiight.core.scene;

import fiiight.core.platform.settings;

interface Scene
{
    /**
     * Loads everything necessary.
     *
     * Params:
     *     settings  =     the settings
     */
    void load(Settings* settings);

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
