module engine.rendering.texture;

import core.memory : GC;

struct Texture
{
    /**
     * The texture id.
     */
    protected const uint id;

    /**
     * Create a new texture.
     *
     * Params:
     *      source  =       the source of the texture
     */
    public this(const string source)
    {
        // ...
    }
}

struct Textures
{
    /**
     * The registered textures.
     */
    private Texture*[const string] textures;

    /**
     * We don't want the default construction to be possible.
     */
    @disable this();

    /**
     * Creates a collection of textures.
     *
     * Returns: the textures pointer
     */
    public static Textures* create()
    {
        return cast(Textures*) GC.calloc(Textures.sizeof);
    }

    /**
     * Get a registered texture.
     *
     * Params:
     *      name  =     the name
     */
    public Texture* get(const string name)
    {
        return this.textures[name];
    }

    /**
     * Register a texture.
     *
     * Params:
     *      name     =      the name
     *      texture  =      the texture
     */
    public void set(const string name, Texture* texture)
    {
        this.textures[name] = texture;
    }

    /**
     * Clear the collection.
     */
    public void clear()
    {
        this.textures.clear();
    }
}
