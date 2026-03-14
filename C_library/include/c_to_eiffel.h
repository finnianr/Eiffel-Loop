/*

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	http://www.eiffel-loop.com

*/

#ifndef	__C_TO_EIFFEL_H
#define	__C_TO_EIFFEL_H

#include <eif_cecil.h>

/*
	struct for C to Eiffel callbacks
	p_object is protected from garbage collection movement by using EL_GC_PROTECTED_OBJECT

*/
typedef struct {
	EIF_REFERENCE p_object;
	EIF_PROCEDURE p_procedure;
} Eiffel_procedure_t;

typedef struct {
	EIF_REFERENCE p_object;
	EIF_INTEGER_FUNCTION p_function;
} Eiffel_integer_function_t;

#endif
