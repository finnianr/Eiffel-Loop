

#include <assert.h>

#ifdef __cplusplus
extern "C"
#endif
char truncate();

int main() {
#if defined (__stub_truncate) || defined (__stub___truncate)
  fail fail fail
#else
  truncate();
#endif

  return 0;
}
