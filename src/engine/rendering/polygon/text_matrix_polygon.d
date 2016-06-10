module engine.rendering.polygon.text_matrix_polygon;

import engine.rendering.camera : Camera;
import engine.rendering.texture : Texture;
import engine.rendering.polygon.data : PolygonData;
import engine.rendering.polygon.matrix_polygon : MatrixPolygon;
import common : Programs;

import derelict.opengl3.gl3;

class TextMatrixPolygon : MatrixPolygon
{
    /**
     * The texture coordinates.
     */
    protected const float[] textureCoordinates = [
        -1.0f, 1.0f,
        1.0f, 1.0f,
        1.0f, -1.0f,
        -1.0f, -1.0f,
    ];

    /**
     * The textures.
     */
    protected Texture* texture;

    /**
     * The texture vertex buffer object.
     */
    protected uint textureVbo;

    /**
     * The texture location.
     */
    protected int attrTexture;

    /**
     * Create a new polygon.
     */
    public this()
    {
        super([
            0.0f, 0.0f,
            1.0f, 0.0f,
            0.0f, 1.0f,
            1.0f, 1.0f,
        ]);
    }

    /**
     * Generates the VBAs and VBOs.
     *
     * Params:
     *      programs  =     the program collection
     */
    public override void load(Programs* programs)
    {
        // ...
    }

    /**
     * Bind the VBAs and VBOs.
     */
    public override void bind() const
    {
        // ...
    }

    /**
     * Render the data.
     *
     * Params:
     *      camera  =       the camera
     *      datas   =       the data collection
     */
    public override void render(Camera* camera, PolygonData[] datas) const
    {
        // ...
    }

    /**
     * Unbinds the VBAs and VBOs.
     */
    public override void unbind() const
    {
        super.unbind();
    }
}
