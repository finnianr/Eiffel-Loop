/*
	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	http://www.eiffel-loop.com
*/

#include "el_curl.h"

size_t curl_on_data_transfer (void *ptr, size_t size, size_t nmemb, Eiffel_integer_function_t *callback)
{
	size_t result;
	result = (size_t) ((callback->p_function) (callback->p_object, (EIF_POINTER)ptr, (EIF_INTEGER)size, (EIF_INTEGER)nmemb));
	return result;
}

size_t curl_on_do_nothing_transfer (void *ptr, size_t size, size_t nmemb, void *userdata)
{
	return size * nmemb;
}

