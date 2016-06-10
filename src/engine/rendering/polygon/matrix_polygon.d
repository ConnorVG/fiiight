module engine.rendering.polygon.matrix_polygon;

import engine.rendering.camera : Camera;
import engine.rendering.polygon.data : PolygonData;
import engine.rendering.polygon.polygon : Polygon;
import common : Program, Programs;

import derelict.opengl3.gl3;

class MatrixPolygon : Polygon
{
    /**
     * The matrix polygon shader program.
     */
    protected Program* program;

    /**
     * The position location.
     */
    protected int attrPosition;

    /**
     * The colour location.
     */
    protected int unifColour;

    /**
     * The view location.
     */
    protected int unifView;

    /**
     * The model location.
     */
    protected int unifModel;

    /**
     * Create a new polygon.
     *
     * Params:
     *      vertices  =     the vertex array
     */
    public this(const float[] vertices)
    {
        super(vertices);
    }

    /**
     * Generates the VBAs and VBOs.
     *
     * Params:
     *      programs  =     the program collection
     */
    public override void load(Programs* programs)
    {
        this.program = programs.get("colour-matrix");

        glUseProgram(this.program.id);

        this.attrPosition = this.program.attributes["position"];
        this.unifColour = this.program.uniforms["colour"];
        this.unifView = this.program.uniforms["view"];
        this.unifModel = this.program.uniforms["model"];

        glEnableVertexAttribArray(this.attrPosition);

        super.load(programs);

        glVertexAttribPointer(this.attrPosition, 2, GL_FLOAT, GL_FALSE, 0, null);
    }

    /**
     * Bind the VBAs and VBOs.
     */
    public override void bind() const
    {
        glUseProgram(this.program.id);
        glEnableVertexAttribArray(this.attrPosition);

        super.bind();
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

        foreach (ref data; datas) {
            glUniform4f(this.unifColour, data.colour.r, data.colour.g, data.colour.b, data.colour.a);
            glUniformMatrix4fv(this.unifModel, 1, GL_TRUE, data.matrix.value_ptr);

            glDrawArrays(GL_TRIANGLE_FAN, 0, cast(int) this.vertices.length / 2);
        }
    }
}
