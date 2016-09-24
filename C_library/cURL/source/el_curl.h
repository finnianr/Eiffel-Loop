/*
	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	http://www.eiffel-loop.com

*/

#ifndef _el_curl_h_
#define _el_curl_h_

#include "c_to_eiffel.h"

/* unix-specific */
#ifndef EIF_WINDOWS 
#include <sys/time.h>
#include <unistd.h> 
#endif

#include <curl/curl.h>

#ifdef __cplusplus
extern "C" {
#endif

size_t curl_on_data_transfer (void *ptr, size_t size, size_t nmemb, Eiffel_integer_function_t *callback);
 
#ifdef __cplusplus
}
#endif

#endif	
