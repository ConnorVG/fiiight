module fiiight.core.process;

import fiiight.core.platform.settings : Settings;
import fiiight.core.scene : Scene;
import fiiight.utils.input : InputFactory, InputHandler, InputType, KeyInputCommand;
import fiiight.utils.gl : Programs, Program;
import fiiight.scenes.menu : MenuScene, MenuSceneType;

import derelict.glfw3.glfw3 : glfwSetWindowShouldClose, GLFW_KEY_ESCAPE;
import derelict.opengl3.gl3 : glGetAttribLocation;

struct Process
{
    /**
     * The settings.
     */
    private Settings* settings;

    /**
     * The input factory.
     */
    private InputFactory* inputFactory;

    /**
     * The current scene.
     */
    private Scene scene;

    /**
     * The programs.
     */
    private Programs* programs;

    /**
     * We don't want the default construction to be possible.
     */
    @disable this();

    /**
     * Loads everything necessary.
     *
     * Params:
     *     settings      =      the settings
     *     inputFactory  =      the input factory
     */
    public void load(Settings* settings, InputFactory* inputFactory)
    {
        this.settings = settings;
        this.inputFactory = inputFactory;
        this.programs = Programs.create();

        this.loadPrograms();

        this.setScene(new MenuScene(MenuSceneType.MAIN_MENU));
    }

    /**
     * Load the programs.
     */
    protected void loadPrograms()
    {
        uint id;
        string vertexShader, fragmentShader;
        Program* program;

        // 2d-basic
        vertexShader = "#version 450 core\n"
                       "layout(location = 0) in vec2 position;\n"
                       "void main() {\n"
                         "gl_Position = vec4(position, 0.0, 1.0);\n"
                       "}";

        fragmentShader = "#version 450 core\n"
                         "precision highp float;\n"
                         "layout(location = 0) out vec4 colour;\n"
                         "void main() {\n"
                           "colour = vec4(1.0, 1.0, 1.0, 1.0);\n"
                         "}";

        id = Program.create(vertexShader, fragmentShader);
        program = Program.create(id);

        program.attributes["position"] = glGetAttribLocation(program.id, "position");

        this.programs.set("2d-basic", program);
    }

    /**
     * Unloads everything no longer necessary.
     */
    public void unload()
    {
        if (this.scene is null) {
            return;
        }

        this.scene.unload();
    }

    /**
     * Runs the process.
     *
     * Params:
     *      tick  =        the tick duration
     */
    public void run(const float tick)
    {
        if (this.scene is null) {
            return;
        }

        this.scene.run(tick);
    }

    /**
     * Sets the scene to use.
     *
     * Params:
     *      scene  =        the scene to use
     */
    public void setScene(Scene scene = null)
    {
        if (this.scene !is null) {
            this.scene.unload();
            this.scene = null;
        }

        if (scene is null) {
            return;
        }

        scene.load(this.settings, this.inputFactory, this.programs);

        this.scene = scene;
    }
}
