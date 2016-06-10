module engine.rendering.texture;

import common : Images, Image;

import derelict.opengl3.gl3 :
    glGenTextures, glBindTexture, glTexImage2D, glTexParameteri, glGenerateMipmap,
    GL_TEXTURE_2D, GL_RGBA, GL_UNSIGNED_BYTE, GL_TEXTURE_MAG_FILTER, GL_TEXTURE_MIN_FILTER, GL_LINEAR, GL_LINEAR_MIPMAP_LINEAR;

import std.conv : to;
import std.array : replace;

import core.memory : GC;

struct Texture
{
    /**
     * The texture id.
     */
    public uint id;

    /**
     * Create a new texture.
     *
     * Params:
     *      source  =       the source of the texture
     */
    public this(const string source)
    {
        Image* image = Images.load(to!string("resources/textures/" ~ source.dup.replace(".", "/") ~ ".png"));

        glGenTextures(1, &this.id);
        glBindTexture(GL_TEXTURE_2D, this.id);

        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, image.width, image.height, 0, GL_RGBA, GL_UNSIGNED_BYTE, image.pixels.ptr);

        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);

        glGenerateMipmap(GL_TEXTURE_2D);
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
     * Load a texture.
     *
     * Params:
     *      name    =       the name
     *      source  =       the source
     */
    public void load(const string name, const string source = null)
    {
        if (name in this.textures) {
            return;
        }

        Texture texture = Texture(source == null ? name : source);

        this.set(name, &texture);
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
