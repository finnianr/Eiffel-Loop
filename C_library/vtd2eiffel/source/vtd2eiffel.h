/*
	note: "Eiffel interface to VTD-XML"
	author: "Finnian Reilly"
	copyright: "Copyright (c) 2006-2009 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "March 2006"
*/

#ifndef VTD_2_EIFFEL_H
#define VTD_2_EIFFEL_H

#include <c_to_eiffel.h>

/*
	IMPORTANT: do not include anything that might include VTD-XML "customTypes.h" because the types in there 
	sometimes clash with other libraries.
*/

typedef struct {
	Eiffel_procedure_t basic;
	Eiffel_procedure_t full;
} Exception_handlers_t;

void evx_parse (
	Exception_handlers_t *p_handlers, EIF_POINTER a_parser, EIF_BOOLEAN is_namespace_aware
);

/* Xpath query */
EIF_POINTER evx_create_xpath_query (
	Exception_handlers_t *p_handlers, EIF_POINTER a_xpath
);
EIF_POINTER evx_create_xpath_query_for_namespace (
	Exception_handlers_t *p_handlers, EIF_POINTER a_xpath, EIF_POINTER a_ns_prefix, EIF_POINTER a_ns_url
);
EIF_DOUBLE evx_evaluate_xpath_to_Number (
	Exception_handlers_t *p_handlers, EIF_POINTER a_node_context, EIF_POINTER  a_xpath_query
);
EIF_BOOLEAN evx_evaluate_xpath_to_Boolean (
	Exception_handlers_t *p_handlers, EIF_POINTER a_node_context, EIF_POINTER  a_xpath_query
);
EIF_POINTER evx_evaluate_xpath_to_String (
	Exception_handlers_t *p_handlers, EIF_POINTER a_node_context, EIF_POINTER  a_xpath_query
);
int evx_xpath_query_start (
	Exception_handlers_t *p_handlers, EIF_POINTER a_node_context, EIF_POINTER  a_xpath_query
);
int evx_xpath_query_forth (
	Exception_handlers_t *p_handlers, EIF_POINTER a_node_context, EIF_POINTER  a_xpath_query
);

void evx_reset_xpath_query (EIF_POINTER a_xpath_query);
void evx_free_xpath_query (EIF_POINTER a_xpath_query);

/* Access node value */
EIF_POINTER evx_node_text_at_index (
	Exception_handlers_t *p_handlers, EIF_POINTER a_node_context, int index
);
/* Access node context */

EIF_POINTER evx_node_context_String (
	Exception_handlers_t *p_handlers, EIF_POINTER a_node_context
);
EIF_POINTER evx_node_context_NormalizedString (
	Exception_handlers_t *p_handlers, EIF_POINTER a_node_context
);
EIF_POINTER evx_node_context_RawString (
	Exception_handlers_t *p_handlers, EIF_POINTER a_node_context
);
EIF_INTEGER evx_node_context_Int (
	Exception_handlers_t *p_handlers, EIF_POINTER a_node_context
);
EIF_REAL evx_node_context_Float (
	Exception_handlers_t *p_handlers, EIF_POINTER a_node_context
);
EIF_DOUBLE evx_node_context_Double (
	Exception_handlers_t *p_handlers, EIF_POINTER a_node_context
);
EIF_POINTER evx_node_context_name (
	Exception_handlers_t *p_handlers, EIF_POINTER a_node_context
);
/* Access element attributes */
EIF_POINTER evx_node_context_attribute_string (
	Exception_handlers_t *p_handlers, EIF_POINTER a_node_context, EIF_POINTER a_attr_name
);
EIF_POINTER evx_node_context_attribute_raw_string (
	Exception_handlers_t *p_handlers, EIF_POINTER a_node_context, EIF_POINTER a_attr_name
);
EIF_INTEGER evx_node_context_attribute_Int (
	Exception_handlers_t *p_handlers, EIF_POINTER a_node_context, EIF_POINTER a_attr_name
);
EIF_REAL evx_node_context_attribute_Float (
	Exception_handlers_t *p_handlers, EIF_POINTER a_node_context, EIF_POINTER a_attr_name
);
EIF_DOUBLE evx_node_context_attribute_Double (
	Exception_handlers_t *p_handlers, EIF_POINTER a_node_context, EIF_POINTER a_attr_name
);

EIF_POINTER evx_create_context_copy (Exception_handlers_t *p_handlers, EIF_POINTER a_other_node_context);

/* Saving and restoring element contexts */
void evx_set_node_context (EIF_POINTER a_node_context, int *context_image);
void evx_read_node_context (EIF_POINTER a_node_context, int *context_image_dest);

int evx_get_token_count (EIF_POINTER a_node_context);
int evx_size_of_node_context_image (EIF_POINTER a_node_context);
EIF_INTEGER evx_node_context_encoding (EIF_POINTER a_node_context);
EIF_POINTER evx_node_context_encoding_type (EIF_POINTER a_node_context);
int evx_get_token_type (EIF_POINTER a_node_context, int index);
int evx_get_token_depth (EIF_POINTER a_node_context, int index);
void evx_free_node_context (EIF_POINTER a_node_context);

EIF_POINTER evx_root_node_context (EIF_POINTER a_parser);
EIF_POINTER evx_create_parser ();

void evx_free_parser (EIF_POINTER a_parser);
void evx_set_document (EIF_POINTER a_parser, EIF_POINTER a_string, int string_count);

#endif
