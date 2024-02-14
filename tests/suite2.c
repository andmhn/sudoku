#include "unit.h"

void suite2()
{
    int foo = 8;
    assert_eq("error, foo != 7", foo == 7);
    assert_eq("error, foo != 8", foo == 8);
}
