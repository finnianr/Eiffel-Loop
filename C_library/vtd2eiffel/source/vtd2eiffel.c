/*
	note: "Bridging code for Eiffel interface to VTD-XML"
	author: "Finnian Reilly"
	copyright: "Copyright (c) 2006-2009 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "March 2006"
	last-modified: "Nov 2009"
*/

/* Prevent clash with WinDef.h macro and this typdef found in customTypes.h

typedef enum Bool {FALSE,
					  TRUE}
					Boolean;

*/

#include <autoPilot.h>
#include <vtdGen.h>

#include "vtd2eiffel.h"

struct exception_context the_exception_context[1];

typedef UCSChar* (*string_function_t) (VTDNav*, int);

/* Private functions */

static void raise_eiffel_exception (Exception_handlers_t *p_handlers, exception *e)
	// Private routine (not in header)
{
	if (e->subtype == BASIC_EXCEPTION){
		EIF_OBJECT p_object = p_handlers->basic.p_object;
		(p_handlers->basic.p_procedure) (p_object, e->et, e->msg);
	}
	else {
		EIF_OBJECT p_object = p_handlers->full.p_object;
		(p_handlers->full.p_procedure) (p_object, e->et, e->msg, e->sub_msg);
	}
}

static EIF_POINTER evx_node_context_text (Exception_handlers_t *p_handlers, EIF_POINTER a_node_context, string_function_t string_fn)
	// Node text using function 'string_fn'
{
	VTDNav *node_context = (VTDNav *)a_node_context;
	wchar_t *result = NULL;
	exception e;
	Try {
		int index = getText (node_context);
		if (index != -1){
			result = string_fn (node_context, index);
		}
	}
	Catch (e) {
		// manual garbage collection here
		raise_eiffel_exception (p_handlers, &e);
	}
	return (EIF_POINTER)result;
}

static EIF_POINTER evx_node_context_attribute_text (
	Exception_handlers_t *p_handlers, EIF_POINTER a_node_context, EIF_POINTER a_attr_name, string_function_t string_fn
)
	// Element attribute text using function 'string_fn'
{
	VTDNav *node_context = (VTDNav *)a_node_context;
	UCSChar *attr_name = (UCSChar *)a_attr_name;
	exception e;
	wchar_t *result = NULL;
	Try {
		int index = getAttrVal (node_context, attr_name);
		if (index != -1){
			result = string_fn (node_context, index);
		}
	}
	Catch (e) {
		// manual garbage collection here
		raise_eiffel_exception (p_handlers, &e);
	}
	return (EIF_POINTER)result;
}

static int evx_xpath_query (Exception_handlers_t *p_handlers, EIF_POINTER a_node_context, EIF_POINTER a_xpath_query, Boolean is_start)
	// returns a nodeset index
	// -1 if finished
{
	VTDNav *node_context = (VTDNav *)a_node_context;
	AutoPilot *xpath_query = (AutoPilot *)a_xpath_query;
	exception e;
	int result = 0;
	Try {
		if (is_start) AP_bind (xpath_query, node_context);
		result = evalXPath(xpath_query);
	}
	Catch (e) {
		// manual garbage collection here
		raise_eiffel_exception (p_handlers, &e);
	}
	return result;
}


/* Document parsing functions */

EIF_POINTER evx_create_parser ()
{
	return (EIF_POINTER)createVTDGen();
}

void evx_free_parser (EIF_POINTER a_parser)
{
	freeVTDGen((VTDGen*)a_parser);
}

void evx_parse (Exception_handlers_t *p_handlers, EIF_POINTER a_parser, EIF_BOOLEAN is_namespace_aware)

{
	VTDGen *parser = (VTDGen *)a_parser;
	exception e;
	Try {
		if (is_namespace_aware) {
			parse (parser, TRUE);
		}
		else {
			parse (parser, FALSE);
		}
	}
	Catch (e) {
		raise_eiffel_exception (p_handlers, &e);
	}
}

void evx_set_document (EIF_POINTER a_parser, EIF_POINTER a_string, int string_count)
{
	setDoc ((VTDGen*)a_parser, (UByte*)a_string, string_count);
}

/* Access VTDNav attributes */

int evx_get_token_count (EIF_POINTER a_node_context)
	// Document token count
{
	return getTokenCount ((VTDNav *)a_node_context);
}
int evx_size_of_node_context_image (EIF_POINTER a_node_context)
	// Access element context
{
	VTDNav *node_context = (VTDNav *)a_node_context;
	// size of 'stackTemp' int array in struct VTDNav
	return node_context->nestingLevel + 9;
}
EIF_INTEGER evx_node_context_encoding (EIF_POINTER a_node_context)
	// If ISO-8859 encoding returns 1-16
	// If UTF encoding returns 8 or 16
	// If WINDOWS encoding return 1250 - 1258
{
	VTDNav *node_context = (VTDNav *)a_node_context;
	encoding_t encoding = node_context->encoding;
	int result;
	if (encoding == FORMAT_ISO_8859_1) result = 1;
	else if (encoding >= FORMAT_ISO_8859_2 && encoding <= FORMAT_ISO_8859_16) result = encoding - 1;
	else if (encoding >= FORMAT_WIN_1250 && encoding <= FORMAT_WIN_1258) result = encoding - FORMAT_WIN_1250 + 1;
	else if (encoding == FORMAT_UTF8) result = 8;
	else if (encoding == FORMAT_UTF_16BE || encoding == FORMAT_UTF_16LE) result = 16;
	return (EIF_INTEGER)result;
}
EIF_POINTER evx_node_context_encoding_type (EIF_POINTER a_node_context)
	// If ISO-8859 encoding returns 1-16
	// If UTF encoding returns 8 or 16
	// If WINDOWS encoding return 1250 - 1258
{
	VTDNav *node_context = (VTDNav *)a_node_context;
	encoding_t encoding = node_context->encoding;
	const char * result;
	if (encoding == FORMAT_ISO_8859_1 || (encoding >= FORMAT_ISO_8859_2 && encoding <= FORMAT_ISO_8859_16)) result = "ISO-8859";
	else if (encoding >= FORMAT_WIN_1250 && encoding <= FORMAT_WIN_1258) result = "WINDOWS";
	else if (encoding == FORMAT_UTF8 || encoding == FORMAT_UTF_16BE || encoding == FORMAT_UTF_16LE) result = "UTF";
	return (EIF_POINTER)result;
}


/* Node context mangement functions */
EIF_POINTER evx_create_context_copy (Exception_handlers_t *p_handlers, EIF_POINTER a_other_node_context)

{
	VTDNav* result = NULL, *other_node_context = a_other_node_context; // This is the VTDNav that navigates the VTD records
	exception e;
	Try {
		result = createVTDNav (
			other_node_context->rootIndex,
			other_node_context->encoding,
			other_node_context->ns,
			other_node_context->nestingLevel - 1,
			other_node_context->XMLDoc,
			other_node_context->bufLen,
			other_node_context->vtdBuffer,
			other_node_context->l1Buffer,
			other_node_context->l2Buffer,
			other_node_context->l3Buffer,
			other_node_context->docOffset,
			other_node_context->docLen,
			other_node_context->br
		);
		result->br = TRUE;
	}
	Catch (e) {
		// manual garbage collection here
		freeVTDNav (result);
		raise_eiffel_exception (p_handlers, &e);
	}
	return (EIF_POINTER)result;
}

void evx_set_node_context (EIF_POINTER a_node_context, int *context_image)
	// Restore context from saved image
{
	VTDNav *node_context = (VTDNav *)a_node_context;
	int i, nestingLevel = node_context->nestingLevel;
	for (i = 0; i < nestingLevel; i++) {
		node_context->context[i] = context_image[i];
	}
	node_context->l1index = context_image [nestingLevel];
	node_context->l2index = context_image [nestingLevel + 1];
	node_context->l3index = context_image [nestingLevel + 2];
	node_context->l2lower = context_image [nestingLevel + 3];
	node_context->l2upper = context_image [nestingLevel + 4];
	node_context->l3lower = context_image [nestingLevel + 5];
	node_context->l3upper = context_image [nestingLevel + 6];
	node_context->atTerminal = (context_image [nestingLevel + 7] == 1);
	node_context->LN  = context_image [nestingLevel + 8];
}

void evx_read_node_context (EIF_POINTER a_node_context, int *context_image_dest)
{
	VTDNav *node_context = (VTDNav *)a_node_context;
	int i, nestingLevel = node_context->nestingLevel;
	for (i = 0; i < nestingLevel; i++) {
		context_image_dest[i] = node_context->context[i];
	}
	context_image_dest [nestingLevel] = node_context->l1index;
	context_image_dest [nestingLevel + 1] = node_context->l2index;
	context_image_dest [nestingLevel + 2] = node_context->l3index;
	context_image_dest [nestingLevel + 3] = node_context->l2lower;
	context_image_dest [nestingLevel + 4] = node_context->l2upper;
	context_image_dest [nestingLevel + 5] = node_context->l3lower;
	context_image_dest [nestingLevel + 6] = node_context->l3upper;
	if (node_context->atTerminal)
		context_image_dest [nestingLevel + 7] = 1;
	else
		context_image_dest [nestingLevel + 7] = 0;
	context_image_dest [nestingLevel + 8] = node_context->LN;
}
EIF_POINTER evx_root_node_context (EIF_POINTER a_parser){
	return (EIF_POINTER) getNav ((VTDGen*)a_parser);
}
void evx_free_node_context (EIF_POINTER a_node_context)
{
	freeVTDNav((VTDNav *)a_node_context);
}

/* Xpath query functions */

void evx_reset_xpath_query (EIF_POINTER a_xpath_query)
{
	resetXPath ((AutoPilot *)a_xpath_query);
}
void evx_free_xpath_query (EIF_POINTER a_xpath_query)
{
	freeAutoPilot ((AutoPilot *)a_xpath_query);
}

EIF_POINTER evx_create_xpath_query (Exception_handlers_t *p_handlers, EIF_POINTER a_xpath)

{
	UCSChar *xpath = (UCSChar *)a_xpath;
	exception e;
	AutoPilot *result = NULL;
	Try {
		result = createAutoPilot2();
		selectXPath(result, xpath);
	}
	Catch (e) {
		// manual garbage collection here
		freeAutoPilot(result);
		raise_eiffel_exception (p_handlers, &e);
	}
	return (EIF_POINTER)result;
}

EIF_POINTER evx_create_xpath_query_for_namespace (
	Exception_handlers_t *p_handlers, EIF_POINTER a_xpath, EIF_POINTER a_ns_prefix, EIF_POINTER a_ns_url
){
	UCSChar *xpath = (UCSChar *)a_xpath, *ns_prefix = (UCSChar *)a_ns_prefix, *ns_url = a_ns_url;
	exception e;
	AutoPilot *result = NULL;
	Try {
		result = createAutoPilot2();
		declareXPathNameSpace (result, ns_prefix, ns_url);
		selectXPath(result, xpath);
	}
	Catch (e) {
		// manual garbage collection here
		freeAutoPilot(result);
		raise_eiffel_exception (p_handlers, &e);
	}
	return (EIF_POINTER)result;
}

#define DEFINE_FUNCTION_GET_VALUE_AT_XPATH(EIF_RESULT_TYPE, init_value, query_type) \
EIF_RESULT_TYPE evx_evaluate_xpath_to_##query_type (Exception_handlers_t *p_handlers, EIF_POINTER a_node_context, EIF_POINTER a_xpath_query) \
{ \
	VTDNav *node_context = (VTDNav *)a_node_context; \
	AutoPilot *xpath_query = (AutoPilot *)a_xpath_query; \
	exception e; \
	EIF_RESULT_TYPE result = init_value; \
	Try { \
		AP_bind (xpath_query, node_context); \
		result = (EIF_RESULT_TYPE) evalXPathTo##query_type (xpath_query); \
	} \
	Catch (e) { \
		raise_eiffel_exception (p_handlers, &e); \
	} \
	return result; \
}

DEFINE_FUNCTION_GET_VALUE_AT_XPATH (EIF_DOUBLE, 0, Number)
DEFINE_FUNCTION_GET_VALUE_AT_XPATH (EIF_BOOLEAN, FALSE, Boolean)
DEFINE_FUNCTION_GET_VALUE_AT_XPATH (EIF_POINTER, NULL, String)

int evx_xpath_query_start (Exception_handlers_t *p_handlers, EIF_POINTER a_node_context, EIF_POINTER a_xpath_query)
	// returns a nodeset index
	// -1 if finished
{
	return evx_xpath_query (p_handlers, a_node_context, a_xpath_query, TRUE);
}

int evx_xpath_query_forth (Exception_handlers_t *p_handlers, EIF_POINTER a_node_context, EIF_POINTER a_xpath_query)
	// returns a nodeset index
	// -1 if finished
{
	return evx_xpath_query (p_handlers, a_node_context, a_xpath_query, FALSE);
}

/* Element value queries */

#define DEFINE_FUNCTION_GET_CONTEXT_STRING(string_type) \
EIF_POINTER evx_node_context_##string_type (Exception_handlers_t *p_handlers, EIF_POINTER a_node_context) \
{ \
	return evx_node_context_text (p_handlers, a_node_context, to##string_type); \
}
DEFINE_FUNCTION_GET_CONTEXT_STRING (String)
DEFINE_FUNCTION_GET_CONTEXT_STRING (NormalizedString)
DEFINE_FUNCTION_GET_CONTEXT_STRING (RawString)

#define DEFINE_FUNCTION_GET_CONTEXT_VALUE(EIF_RESULT_TYPE, init_value, query_type) \
EIF_RESULT_TYPE evx_node_context_##query_type (Exception_handlers_t *p_handlers, EIF_POINTER a_node_context) \
{ \
	VTDNav *node_context = (VTDNav *)a_node_context; \
	EIF_RESULT_TYPE result = init_value; \
	exception e; \
	Try { \
		int index = getText (node_context); \
		if (index != -1){ \
			result = (EIF_RESULT_TYPE) parse##query_type (node_context, index); \
		} \
	} \
	Catch (e) { \
		raise_eiffel_exception (p_handlers, &e); \
	} \
	return result; \
}

DEFINE_FUNCTION_GET_CONTEXT_VALUE (EIF_INTEGER, 0, Int)
DEFINE_FUNCTION_GET_CONTEXT_VALUE (EIF_INTEGER_64, 0, Long)
DEFINE_FUNCTION_GET_CONTEXT_VALUE (EIF_REAL, 0, Float)
DEFINE_FUNCTION_GET_CONTEXT_VALUE (EIF_DOUBLE, 0, Double)

EIF_POINTER evx_node_context_name (Exception_handlers_t *p_handlers, EIF_POINTER a_node_context)

{
	VTDNav *node_context = (VTDNav *)a_node_context;
	wchar_t *result = NULL;
	exception e;
	Try {
		int i = getCurrentIndex(node_context);
		if (i != -1){
			result = toString(node_context,i);
		}
	}
	Catch (e) {
		// manual garbage collection here
		raise_eiffel_exception (p_handlers, &e);
	}
	return (EIF_POINTER)result;
}

/* Attribute value query */

EIF_POINTER evx_node_context_attribute_string (Exception_handlers_t *p_handlers, EIF_POINTER a_node_context, EIF_POINTER a_attr_name)

{
	return evx_node_context_attribute_text (p_handlers, a_node_context, a_attr_name, toString);
}

EIF_POINTER evx_node_context_attribute_raw_string (Exception_handlers_t *p_handlers, EIF_POINTER a_node_context, EIF_POINTER a_attr_name)

{
	return evx_node_context_attribute_text (p_handlers, a_node_context, a_attr_name, toRawString);
}

#define DEFINE_FUNCTION_GET_ATTRIBUTE_VALUE(EIF_RESULT_TYPE, init_value, query_type) \
EIF_RESULT_TYPE evx_node_context_attribute_##query_type (Exception_handlers_t *p_handlers, EIF_POINTER a_node_context, EIF_POINTER a_attr_name) \
{ \
	VTDNav *node_context = (VTDNav *)a_node_context; \
	UCSChar *attr_name = (UCSChar *)a_attr_name; \
	EIF_RESULT_TYPE result = init_value; \
	exception e; \
	Try { \
		int index = getAttrVal (node_context, attr_name); \
		if (index != -1){ \
			result = (EIF_RESULT_TYPE)parse##query_type (node_context, index); \
		} \
	} \
	Catch (e) { \
		raise_eiffel_exception (p_handlers, &e); \
	} \
	return result; \
}
DEFINE_FUNCTION_GET_ATTRIBUTE_VALUE (EIF_INTEGER, 0, Int)
DEFINE_FUNCTION_GET_ATTRIBUTE_VALUE (EIF_INTEGER_64, 0, Long)
DEFINE_FUNCTION_GET_ATTRIBUTE_VALUE (EIF_REAL, 0, Float)
DEFINE_FUNCTION_GET_ATTRIBUTE_VALUE (EIF_DOUBLE, 0, Double)

/* Access node properties by index */

EIF_POINTER evx_node_text_at_index (Exception_handlers_t *p_handlers, EIF_POINTER a_node_context, int index)
	//
{
	VTDNav *node_context = (VTDNav *)a_node_context;
	wchar_t *result = NULL;
	exception e;
	Try {
		result = toString(node_context, index);
	}
	Catch (e) {
		raise_eiffel_exception (p_handlers, &e);
	}
	return (EIF_POINTER)result;
}

int evx_get_token_type (EIF_POINTER a_node_context, int index)
{
	return (int)getTokenType ((VTDNav *)a_node_context, index);
}
int evx_get_token_depth (EIF_POINTER a_node_context, int index)
{
	return (int)getTokenDepth ((VTDNav *)a_node_context, index);
}

