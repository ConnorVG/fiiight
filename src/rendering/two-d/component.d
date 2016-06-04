module fiiight.rendering.two_d.component;

interface Component
{
    /**
     * Loads everything necessary.
     */
    void load();

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
