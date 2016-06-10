module engine.rendering.polygon.textured_matrix_polygon;

import engine.rendering.camera : Camera;
import engine.rendering.texture : Texture;
import engine.rendering.polygon.data : PolygonData;
import engine.rendering.polygon.matrix_polygon : MatrixPolygon;
import common : Programs;

import derelict.opengl3.gl3;

class TexturedMatrixPolygon : MatrixPolygon
{
    /**
     * The texture coordinates.
     */
    protected const float[] textureCoordinates;

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
     *
     * Params:
     *      vertices            =     the vertex array
     *      textureCoordinates  =     the texture coordinates
     *      texture             =     the texture
     */
    public this(const float[] vertices, const float[] textureCoordinates, Texture* texture)
    {
        super(vertices);

        this.textureCoordinates = textureCoordinates;
        this.texture = texture;
    }

    /**
     * Generates the VBAs and VBOs.
     *
     * Params:
     *      programs  =     the program collection
     */
    public override void load(Programs* programs)
    {
        this.program = programs.get("texture-matrix");

        glUseProgram(this.program.id);

        this.attrPosition = this.program.attributes["position"];
        this.attrTexture = this.program.attributes["texture"];
        this.unifColour = this.program.uniforms["colour"];
        this.unifView = this.program.uniforms["view"];
        this.unifModel = this.program.uniforms["model"];

        glEnableVertexAttribArray(this.attrPosition);
        glEnableVertexAttribArray(this.attrTexture);

        super.Polygon.load(programs);

        glGenBuffers(1, &this.textureVbo);
        glBindBuffer(GL_ARRAY_BUFFER, this.textureVbo);
        glBufferData(GL_ARRAY_BUFFER, this.textureCoordinates.length * float.sizeof, this.textureCoordinates.ptr, GL_STATIC_DRAW);

        glVertexAttribPointer(this.attrPosition, 2, GL_FLOAT, GL_FALSE, 0, null);
        glVertexAttribPointer(this.attrTexture, 2, GL_FLOAT, GL_FALSE, 0, null);
    }

    /**
     * Bind the VBAs and VBOs.
     */
    public override void bind() const
    {
        glUseProgram(this.program.id);
        glEnableVertexAttribArray(this.attrPosition);
        glEnableVertexAttribArray(this.attrTexture);

        super.Polygon.bind();
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
        glUseProgram(this.program.id);

        glUniformMatrix4fv(this.unifView, 1, GL_TRUE, camera.matrix.value_ptr);

        glBindTexture(GL_TEXTURE_2D, this.texture.id);
        glActiveTexture(GL_TEXTURE0);

        foreach (ref data; datas) {
            glUniformMatrix4fv(this.unifModel, 1, GL_TRUE, data.matrix.value_ptr);
            glUniform4f(this.unifColour, data.colour.x, data.colour.y, data.colour.z, data.colour.w);

            glDrawArrays(GL_TRIANGLE_FAN, 0, cast(int) this.vertices.length / 2);
        }
    }
}
