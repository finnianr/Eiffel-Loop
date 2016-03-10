/*********************************************************************************

	Author: Finnian Reilly
	Part of the "Eiffel LOOP library".
	http://www.eiffel-loop.com

*********************************************************************************/

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

#endif
