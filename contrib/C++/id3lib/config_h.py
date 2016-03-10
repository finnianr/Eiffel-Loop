# Originally from autoconf output	

header_text = """
/* Define if you need to in order for stat and other things to work. */
/* #undef _POSIX_SOURCE */

/* Define to `unsigned' if <sys/types.h> does not define. */
/* #undef size_t */
/* This is the bottom section */

#if defined (ID3_ENABLE_DEBUG) && defined (HAVE_LIBCW_SYS_H) && defined (__cplusplus)

#define DEBUG

#include <libcw/sys.h>
#include <libcw/debug.h>

#define ID3D_INIT_DOUT()    Debug( libcw_do.on() )
#define ID3D_INIT_WARNING() Debug( dc::warning.on() )
#define ID3D_INIT_NOTICE()  Debug( dc::notice.on() )
#define ID3D_NOTICE(x)      Dout( dc::notice, x )
#define ID3D_WARNING(x)     Dout( dc::warning, x )

#else

#  define ID3D_INIT_DOUT()
#  define ID3D_INIT_WARNING()
#  define ID3D_INIT_NOTICE()
#  define ID3D_NOTICE(x)
#  define ID3D_WARNING(x)

#endif /* defined (ID3_ENABLE_DEBUG) && defined (HAVE_LIBCW_SYS_H) */
"""
