

#include <assert.h>

#ifdef __cplusplus
extern "C"
#endif
char getopt_long();

int main() {
#if defined (__stub_getopt_long) || defined (__stub___getopt_long)
  fail fail fail
#else
  getopt_long();
#endif

  return 0;
}
