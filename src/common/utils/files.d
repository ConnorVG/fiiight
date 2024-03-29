module common.utils.files;

import std.conv : to;
import std.file : read;
import std.format : format;

enum FileType {
    VERTEX_SHADER = "resources/shaders/vertex/%s.glsl",
    FRAGMENT_SHADER = "resources/shaders/fragment/%s.glsl",
    FONT_DEFINITION = "resources/fonts/%s.fnt",
    FONT_TEXTURE = "resources/textures/fonts/%s.fnt",
}

struct Files
{
    /**
     * Get the contents of a file.
     *
     * Params:
     *      type  =     the file type
     *      file  =     the file name
     */
    public static string contents(FileType type, const string file)
    {
        string realFile = type.format(file);

        return to!string(read(realFile));
    }
}
