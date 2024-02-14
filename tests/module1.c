#include "unit.h"

static void test1() {
     lok('a' == 'a');
     lequal(20, 20);
     lfequal(40.001, 40.001);
     lfequal(40.0001, 40.0002); // tolerated
     lsequal("hi", "hi");
}

TEST love(){
     lok('a' == 'a');
}

void module2_test()
{

  lrun("module2 test", test1);
  lrun("love test", love);
}
