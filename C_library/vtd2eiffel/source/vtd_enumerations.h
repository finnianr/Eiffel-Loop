/*
Copied from vtd-xml customTypes.h
 */
#ifndef VTD_ENUMERATIONS_H
#define VTD_ENUMERATIONS_H

typedef enum VTDtokentype {TOKEN_STARTING_TAG,
						   TOKEN_ENDING_TAG,
						   TOKEN_ATTR_NAME,
						   TOKEN_ATTR_NS,
						   TOKEN_ATTR_VAL,
						   TOKEN_CHARACTER_DATA,
						   TOKEN_COMMENT,
						   TOKEN_PI_NAME,
						   TOKEN_PI_VAL,
						   TOKEN_DEC_ATTR_NAME,
						   TOKEN_DEC_ATTR_VAL,
						   TOKEN_CDATA_VAL,
						   TOKEN_DTD_VAL,
						   TOKEN_DOCUMENT}
					tokenType;

enum exception_type {out_of_mem,
  					 invalid_argument,
					 array_out_of_bound,
					 parse_exception,
					 nav_exception,
					 pilot_exception,
					 number_format_exception,
					 xpath_parse_exception,
					 xpath_eval_exception,
					 modify_exception,
					 index_write_exception,
					 index_read_exception,
					 io_exception,
					 transcode_exception,
					 other_exception};

#endif
