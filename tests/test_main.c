#include "unit.h"

size_t ltests = 0;
size_t lfails = 0;

void module2_test();

int run_all_test()
{
  module2_test();
  lresults();
  return lfails != 0;

}
