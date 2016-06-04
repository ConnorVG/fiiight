# fiiight
A side-scrolling war game.

`dub run -q -- --updateRate=60`

### Notes
23:38 - Vercas: Also, please keep in mind that mouse coordinates can be relative too. :D
23:38 - Vercas: Eh, s/relative/negative/
23:39 - Vercas: So the (u)int needs to be split into two short. :D
23:39 - Vercas: short x = cast(short)(val & 0xFFFF), y = cast(short)(val >> 16);
