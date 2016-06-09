module common.utils.images;

import imageformats : read_image, ColFmt;

import core.memory : GC;

struct Image
{
    /**
     * The raw pixels in RGBA format.
     */
    public ubyte[] pixels;

    /**
     * The width.
     */
    public uint width;

    /**
     * The height.
     */
    public uint height;

    /**
     * Creates an image
     *
     * Params:
     *      pixels  =       the pixels
     *      width   =       the width
     *      height  =       the pixels
     *
     * Returns: the image pointer
     */
    public static Image* create(ubyte[] pixels, uint width, uint height)
    {
        Image* image = cast(Image*) GC.malloc(Image.sizeof);

        image.pixels = pixels;
        image.width = width;
        image.height = height;

        return image;
    }
}

struct Images
{
    /**
     * Load an image.
     *
     * Params:
     *      source  =       the image source
     *
     * Returns: a pointer to the image instance
     */
    public static Image* load(const string source)
    {
        auto data = read_image(source, ColFmt.RGBA);

        return Image.create(data.pixels, data.w, data.h);
    }
}
