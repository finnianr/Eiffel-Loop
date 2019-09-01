

#include <assert.h>

#ifdef __cplusplus
extern "C"
#endif
char mkstemp();

int main() {
#if defined (__stub_mkstemp) || defined (__stub___mkstemp)
  fail fail fail
#else
  mkstemp();
#endif

  return 0;
}
