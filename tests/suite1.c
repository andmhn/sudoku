#include "unit.h"

static void test_foo()
{
    int foo = 8;
    assert_eq("error, foo != 7", foo == 7);
    assert_eq("error, foo != 1", foo == 1);
    assert_eq("error, foo != 3", foo == 3);
    assert_eq("error, foo != 8", foo == 8);
    assert_eq("error, foo != 8", foo == 8);
    assert_eq("error, foo != 8", foo == 8);
    assert_eq("error, foo != 8", foo == 8);
    assert_eq("error, foo != 9", foo == 9);
}

static void test_bar()
{
    int bar = 5;
    assert_eq("error, bar != 5", bar == 4);
}

void suite1()
{
    test_foo();
    test_bar();
}
