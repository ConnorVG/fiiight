module engine.rendering.polygon.data.text_data;

import engine.rendering.polygon.data.data : PolygonData;

import gl3n.linalg : Vector;

alias vec2 = Vector!(float, 2);
alias vec4 = Vector!(float, 4);

class TextPolygonData : PolygonData
{
    /**
     * The text.
     */
    public string text;

    /**
     * Creates an instance of text data.
     *
     * Returns: the data instance
     */
    public this(
        string text,
        vec2 position = vec2(0f, 0f),
        vec2 scale = vec2(1f, 1f),
        float rotation = 0f,
        vec4 colour = vec4(1f, 1f, 1f, 1f)
    ) {
        super(position, scale, rotation, colour);

        this.text = text;
    }
}
