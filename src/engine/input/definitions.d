module engine.input.definitions;

enum Types {
    KEY,
    CHAR,
    MOUSE,
}

enum Key : uint {
    UNKNOWN = 1,

    SPACE = 32,

    APOSTROPHE = 39,
    COMMA = 44,
    MINUS = 45,
    PERIOD = 46,
    SLASH = 47,

    NUM_0 = 48,
    NUM_1 = 49,
    NUM_2 = 50,
    NUM_3 = 51,
    NUM_4 = 52,
    NUM_5 = 53,
    NUM_6 = 54,
    NUM_7 = 55,
    NUM_8 = 56,
    NUM_9 = 57,

    SEMICOLON = 59,
    EQUAL = 61,

    CHAR_A = 65,
    CHAR_B = 66,
    CHAR_C = 67,
    CHAR_D = 68,
    CHAR_E = 69,
    CHAR_F = 70,
    CHAR_G = 71,
    CHAR_H = 72,
    CHAR_I = 73,
    CHAR_J = 74,
    CHAR_K = 75,
    CHAR_L = 76,
    CHAR_M = 77,
    CHAR_N = 78,
    CHAR_O = 79,
    CHAR_P = 80,
    CHAR_Q = 81,
    CHAR_R = 82,
    CHAR_S = 83,
    CHAR_T = 84,
    CHAR_U = 85,
    CHAR_V = 86,
    CHAR_W = 87,
    CHAR_X = 88,
    CHAR_Y = 89,
    CHAR_Z = 90,

    LEFT_BRACKET = 91,
    BACKSLASH = 92,
    RIGHT_BRACKET = 93,
    GRAVE_ACCENT = 96,
    WORLD_1 = 161,
    WORLD_2 = 162,

    ESCAPE = 256,
    ENTER = 257,
    TAB = 258,

    BACKSPACE = 259,
    INSERT = 260,
    DELETE = 261,

    RIGHT = 262,
    LEFT = 263,
    DOWN = 264,
    UP = 265,

    PAGE_UP = 266,
    PAGE_DOWN = 267,
    HOME = 268,
    END = 269,

    CAPS_LOCK = 280,
    SCROLL_LOCK = 281,
    NUM_LOCK = 282,
    PRINT_SCREEN = 283,
    PAUSE = 284,

    F1 = 290,
    F2 = 291,
    F3 = 292,
    F4 = 293,
    F5 = 294,
    F6 = 295,
    F7 = 296,
    F8 = 297,
    F9 = 298,
    F10 = 299,
    F11 = 300,
    F12 = 301,
    F13 = 302,
    F14 = 303,
    F15 = 304,
    F16 = 305,
    F17 = 306,
    F18 = 307,
    F19 = 308,
    F20 = 309,
    F21 = 310,
    F22 = 311,
    F23 = 312,
    F24 = 313,
    F25 = 314,

    KP_0 = 320,
    KP_1 = 321,
    KP_2 = 322,
    KP_3 = 323,
    KP_4 = 324,
    KP_5 = 325,
    KP_6 = 326,
    KP_7 = 327,
    KP_8 = 328,
    KP_9 = 329,

    KP_DECIMAL = 330,
    KP_DIVIDE = 331,
    KP_MULTIPLY = 332,
    KP_SUBTRACT = 333,
    KP_ADD = 334,
    KP_ENTER = 335,
    KP_EQUAL = 336,

    LEFT_SHIFT = 340,
    LEFT_CONTROL = 341,
    LEFT_ALT = 342,
    LEFT_SUPER = 343,
    RIGHT_SHIFT = 344,
    RIGHT_CONTROL = 345,
    RIGHT_ALT = 346,
    RIGHT_SUPER = 347,

    MENU = 348,
    LAST = 348,
}

enum MouseButton : uint {
    ONE = 0,
    TWO = 1,
    THREE = 2,
    FOUR = 3,
    FIVE = 4,
    SIX = 5,
    SEVEN = 6,
    EIGHT = 7,

    LEFT = 0,
    RIGHT = 1,
    MIDDLE = 2,

    LAST = 7,
}

enum Modifier : int {
    SHIFT = 1,
    CONTROL = 2,
    ALT = 4,
    SUPER = 8,

    SHIFT_CONTROL = 1 + 2,
    SHIFT_ALT = 1 + 4,
    SHIFT_SUPER = 1 + 8,

    SHIFT_ALT_SUPER = 1 + 4 + 8,

    SHIFT_CONTROL_ALT = 1 + 2 + 4,
    SHIFT_CONTROL_SUPER = 1 + 2 + 8,
    SHIFT_CONTROL_ALT_SUPER = 1 + 2 + 4 + 8,

    CONTROL_ALT = 2 + 4,
    CONTROL_SUPER = 2 + 8,
    CONTROL_ALT_SUPER = 2 + 4 + 8,

    ALT_SUPER = 4 + 8,
}

enum Action {
    RELEASE,
    PRESS,
    REPEAT,
}
