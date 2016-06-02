module fiiight;

import fiiight.core.platform.settings : Settings;
import fiiight.core.game : Game;

import core.memory : GC;

void main(string[] args)
{
    Settings* settings = cast(Settings*) GC.malloc(Settings.sizeof);
    settings.load(args);

    Game* game = cast(Game*) GC.malloc(Game.sizeof);

    game.load(settings);
    scope(exit) game.unload();

    game.start();
    scope(exit) game.stop();
}
