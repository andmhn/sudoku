#include "unit.h"

int tests_run = 0;
int tests_failed = 0;

// list all of tests module here
//------------------------------
void suite1();
void suite2();

void all_tests()
{
    suite1();
    suite2();
}

int run_all_test()
{
    all_tests();

    if (tests_failed != 0)
    {
        printf("FAILED: %d\n", tests_failed);
    }
    else
    {
        printf("ALL TESTS PASSED\n");
    }
    printf("Tests run: %d\n", tests_run);

    return tests_failed;
}
