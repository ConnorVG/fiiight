import common : Settings;
import engine : Engine;
import game : Game, IState;
import fiiight : State;

void main(string[] args)
{
    Settings* settings = Settings.create(args);

    Engine* engine = Engine.create(settings);
    Game* game = Game.create(engine, settings);

    game.boot();

    IState state = new State();

    game.start(&state);
}
