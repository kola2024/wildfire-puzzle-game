level builder


creative:
the goal is to stop the fire/protect an area or majority.
level 1: fire top corner, player has the default "grass cut" ability to prevent fire from spreading further by isolation

misc:
mechanics
    wind mechanic: fire spreads faster in one direction (doubt i can do this with any angle, probably just spread 1 tile normally and 2/0 tile in wind direction but aCTUALLY this doesnt make sense. think abt l8r)

grass types
    regular -> fire -> empty
    rebirth/pheonic -> fire -> seed -> regular
    explosion -> wipes out area: crucially does not do fire! so can be used to clear an area for isolation

player interaction
    regular axe swing/ cut
    release animal : eats grass ahead
    hose?

dynamic letterbox with shader?

notes

need a label string method (rec, string)
need a better state machine. i have menu and game state: maybe make menu its own fsM? (game)



small

can get rid of dt entirely.. only reason i keep is in case i want animatrions for firwe and such
get rid of mouse support? mouse isnt used in game so makes no sense to allow in menus