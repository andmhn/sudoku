#include <stdio.h>

extern int tests_run;
extern int tests_failed;

#define assert_eq(message, test)                                                      \
    do                                                                                \
    {                                                                                 \
        tests_run++;                                                                  \
        if (!(test))                                                                  \
        {                                                                             \
            fprintf(stderr, "%s:%d: test failed: %s\n", __FILE__, __LINE__, message); \
            tests_failed++;                                                           \
        }                                                                             \
    } while (0)
