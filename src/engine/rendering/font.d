module engine.rendering.font;

import common : Files, FileType;

import std.conv : to;
import std.regex : regex, matchFirst, matchAll;

import core.memory : GC;

struct BitmapFontCharacter
{
    public float x;
    public float y;

    public float width;
    public float height;

    public float renderWidth;
    public float renderHeight;

    public float xOffset;
    public float yOffset;

    public float xAdvance;
}

struct BitmapFont
{
    public string face;
    public string texture;

    public bool bold;
    public bool italic;

    public float scale;

    public float lineHeight;
    public float base;

    public BitmapFontCharacter[char] characters;

    public void load(const(float)[const string][const char] characters)
    {
        foreach (ref character, ref definition; characters) {
            BitmapFontCharacter _character = {
                x: definition["x"],
                y: definition["y"],

                width: definition["width"],
                height: definition["height"],

                renderWidth: this.scale * definition["renderWidth"] / 64f,
                renderHeight: this.scale * definition["renderHeight"] / 64f,

                xOffset: this.scale * definition["xoffset"] / 64f,
                yOffset: this.scale * definition["yoffset"] / 64f,
                xAdvance: this.scale * definition["xadvance"] / 64f,
            };

            this.characters[character] = _character;
        }
    }
}

struct BitmapFonts
{
    /**
     * The fonts.
     */
    public static BitmapFont[const string] fonts;

    /**
     * Load a font into the font collection.
     *
     * Params:
     *      name      =     the name
     */
    public static void load(const string name)
    {
        string contents = Files.contents(FileType.FONT_DEFINITION, name);

        import std.stdio;

        auto regex = regex(`(?P<key>\w+)=(?:(?P<value>[\w\d-,]+)|(?:"(?P<quoted_value>[\w\d\s-,]+)"))`, "g");
        auto matches = matchAll(contents, regex);

        string face = name;
        string texture = name;
        ushort size = 0;
        bool bold = false;
        bool italic = false;
        ushort lineHeight = 0;
        ushort base = 0;

        ushort scaleW = 0;
        ushort scaleH = 0;

        float[const string][char] characters;
        bool hasCharacter = false;
        char character;

        bool finishedFace = false;

        foreach (ref match; matches) {
            string key = match["key"];
            string value = match["value"].length > 0 ? match["value"] : match["quoted_value"];

            if (! finishedFace) {
                switch (key) {
                    case "face":
                        face = value;

                        break;
                    case "file":
                        texture = value;

                        break;
                    case "size":
                        size = to!ushort(value);

                        break;
                    case "bold":
                        bold = value == "1";

                        break;
                    case "italic":
                        italic = value == "1";

                        break;
                    case "lineHeight":
                        lineHeight = to!ushort(value);

                        break;
                    case "base":
                        base = to!ushort(value);

                        break;
                    case "scaleW":
                        scaleW = to!ushort(value);

                        break;
                    case "scaleH":
                        scaleH = to!ushort(value);

                        break;
                    case "id":
                        finishedFace = true;

                        break;
                    default: break;
                }
            } else if (key == "id") {
                character = cast(char) to!uint(value);
                hasCharacter = true;
            } else if (hasCharacter) {
                float f = to!float(value);

                switch (key) {
                    case "width":
                        characters[character]["renderWidth"] = f;

                        goto case;
                    case "x":
                        f /= scaleW;

                        break;
                    case "height":
                        characters[character]["renderHeight"] = f;

                        goto case;
                    case "y":
                        f /= scaleH;

                        break;
                    case "xoffset":
                    case "xadvance":
                    case "yoffset":
                        break;
                    default: continue;
                }

                characters[character][key] = f;
            }
        }

        BitmapFont font = {
            face: face,
            texture: texture,
            bold: bold,
            italic: italic,
            scale: 64f / size,
            lineHeight: lineHeight,
            base: base,
        };

        font.load(characters);

        BitmapFonts.set(name, font);
    }

    /**
     * Get a registered font.
     */
    public static BitmapFont* get(const string name)
    {
        return &BitmapFonts.fonts[name];
    }

    /**
     * Register a font.
     */
    public static void set(const string name, BitmapFont font)
    {
        BitmapFonts.fonts[name] = font;
    }
}
