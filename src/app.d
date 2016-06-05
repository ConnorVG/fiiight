module fiiight;

import common : Settings;
import engine : Engine;
import game : Game;

void main(string[] args)
{
    Settings* settings = Settings.create(args);

    Engine* engine = Engine.create(settings);
    Game* game = Game.create(engine, settings);

    game.boot();
    game.start();
}
