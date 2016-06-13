module engine.rendering.polygon.text_matrix_polygon;

import engine.rendering.font : BitmapFonts, BitmapFont;
import engine.rendering.camera : Camera;
import engine.rendering.texture : Texture, Textures;
import engine.rendering.polygon.data : PolygonData, TextPolygonData;
import engine.rendering.polygon.matrix_polygon : MatrixPolygon;
import common : Programs;

import derelict.opengl3.gl3;

enum TextMatrixPolygonFonts : string {
    SOURCE_CODE_PRO_LIGHT = "source-code-pro-light",

    DEFAULT = SOURCE_CODE_PRO_LIGHT,
}

class TextMatrixPolygon : MatrixPolygon
{
    /**
     * The font name.
     */
    protected const string fontName;

    /**
     * The font.
     */
    protected BitmapFont* font;

    /**
     * The texture coordinates.
     */
    protected float[] textureCoordinates = [
        0.0f, 0.0f,
        0.0f, 1.0f,
        1.0f, 1.0f,
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
    public this(const string fontName)
    {
        super([]);

        this.fontName = fontName;
    }

    /**
     * Generates the VBAs and VBOs.
     *
     * Params:
     *      programs  =     the program collection
     *      textures  =     the texture collection
     */
    public void load(Programs* programs, Textures* textures)
    {
        BitmapFonts.load(this.fontName);

        this.font = BitmapFonts.get(this.fontName);

        textures.load("fonts." ~ this.font.texture);
        this.texture = textures.get("fonts." ~ this.font.texture);

        this.load(programs);
    }

    /**
     * Generates the VBAs and VBOs.
     *
     * Params:
     *      programs  =     the program collection
     */
    public override void load(Programs* programs)
    {
        assert(this.texture, "texture not set...");

        this.program = programs.get("texture-matrix");

        glUseProgram(this.program.id);

        this.attrPosition = this.program.attributes["position"];
        this.attrTexture = this.program.attributes["texture"];
        this.unifColour = this.program.uniforms["colour"];
        this.unifView = this.program.uniforms["view"];
        this.unifModel = this.program.uniforms["model"];

        glEnableVertexAttribArray(this.attrPosition);
        glEnableVertexAttribArray(this.attrTexture);

        glGenBuffers(1, &this.vbo);
        glBindBuffer(GL_ARRAY_BUFFER, this.vbo);
        glBufferData(GL_ARRAY_BUFFER, 6 * 255 * float.sizeof, this.vertices.ptr, GL_STREAM_DRAW);

        glGenBuffers(1, &this.textureVbo);
        glBindBuffer(GL_ARRAY_BUFFER, this.textureVbo);
        glBufferData(GL_ARRAY_BUFFER, 6 * 255 * float.sizeof, this.textureCoordinates.ptr, GL_STREAM_DRAW);

        glGenVertexArrays(1, &this.vao);
        glBindVertexArray(this.vao);

        glBindBuffer(GL_ARRAY_BUFFER, this.vbo);
        glVertexAttribPointer(this.attrPosition, 2, GL_FLOAT, GL_FALSE, 0, null);

        glBindBuffer(GL_ARRAY_BUFFER, this.textureVbo);
        glVertexAttribPointer(this.attrTexture, 2, GL_FLOAT, GL_FALSE, 0, null);
    }

    /**
     * Bind the VBAs and VBOs.
     */
    public override void bind()
    {
        glUseProgram(this.program.id);

        super.Polygon.bind();

        glEnableVertexAttribArray(this.attrPosition);
        glEnableVertexAttribArray(this.attrTexture);

        glBindTexture(GL_TEXTURE_2D, this.texture.id);
        glActiveTexture(GL_TEXTURE0);
    }

    /**
     * Render the data.
     *
     * Params:
     *      camera  =       the camera
     *      datas   =       the data collection
     */
    public override void render(Camera* camera, PolygonData[] datas)
    {
        camera.apply(this.unifView);

        foreach (ref data; datas) {
            if (auto textData = cast(TextPolygonData) data) {
                this.bindCharacters(textData.text);
            } else { continue; }

            glUniformMatrix4fv(this.unifModel, 1, GL_TRUE, data.matrix.value_ptr);
            glUniform4f(this.unifColour, data.colour.x, data.colour.y, data.colour.z, data.colour.w);

            glDrawArrays(GL_TRIANGLES, 0, cast(int) this.vertices.length / 2);
        }
    }

    /**
     * Bind the VBOs for characters.
     */
    protected void bindCharacters(string text)
    {
        auto characters = this.font.characters;

        this.vertices = [];
        this.textureCoordinates = [];
        float cursor = 0f;
        float scale = this.font.scale;
        foreach (ref index, ref character; text) {
            if (character !in characters) {
                continue;
            }

            auto def = characters[character];

            this.vertices ~= [
                cursor + def.xOffset, def.yOffset,
                cursor + def.xOffset, def.renderHeight + def.yOffset,
                cursor + def.xOffset + def.renderWidth, def.renderHeight + def.yOffset,

                cursor + def.xOffset, def.yOffset,
                cursor + def.xOffset + def.renderWidth, def.yOffset,
                cursor + def.xOffset + def.renderWidth, def.renderHeight + def.yOffset,
            ];

            this.textureCoordinates ~= [
                def.x, def.y,
                def.x, def.y + def.height,
                def.x + def.width, def.y + def.height,

                def.x, def.y,
                def.x + def.width, def.y,
                def.x + def.width, def.y + def.height,
            ];

            cursor += def.xAdvance;
        }

        glBindBuffer(GL_ARRAY_BUFFER, this.vbo);
        glBufferSubData(GL_ARRAY_BUFFER, 0, this.vertices.length * float.sizeof, this.vertices.ptr);

        glBindBuffer(GL_ARRAY_BUFFER, this.textureVbo);
        glBufferSubData(GL_ARRAY_BUFFER, 0, this.textureCoordinates.length * float.sizeof, this.textureCoordinates.ptr);
    }

    /**
     * Unbinds the VBAs and VBOs.
     */
    public override void unbind()
    {
        glDisableVertexAttribArray(this.attrTexture);
        glDisableVertexAttribArray(this.attrPosition);

        this.Polygon.unbind();
    }
}
