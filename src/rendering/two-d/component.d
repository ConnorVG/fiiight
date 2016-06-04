module fiiight.rendering.two_d.component;

import fiiight.utils.gl : Programs;

interface Component
{
    /**
     * Loads everything necessary.
     *
     * Params:
     *      programs  =     the programs
     */
    void load(Programs* programs);

    /**
     * Unloads everything no longer necessary.
     */
    void unload();

    /**
     * Update the component.
     *
     * Params:
     *      tick  =        the tick duration
     */
    void update(const float tick);

    /**
     * Render the component.
     *
     * Params:
     *      tick  =        the tick duration
     */
    void render(const float tick);
}
