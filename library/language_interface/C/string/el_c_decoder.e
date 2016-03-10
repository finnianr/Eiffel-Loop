note
	description: "Summary description for {EL_UTF8_TO_LATIN1_C_DECODER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "5"

class
	EL_C_DECODER

inherit
	STRING_HANDLER
		redefine
			default_create
		end

feature {NONE} -- Initialization	

	default_create
			--
		do
			create utf8_c_string
		end

feature -- Basic operations

	set_from_utf8 (target: STRING_GENERAL; source_utf8_ptr: POINTER)
			--
		do
			target.set_count (0)
			append_from_utf8 (target, source_utf8_ptr)
		end

	set_from_utf8_of_size (target: STRING_GENERAL; source_utf8_ptr: POINTER; size: INTEGER)
			--
		do
			target.set_count (0)
			append_from_utf8_of_size (target, source_utf8_ptr, size)
		end

	append_from_utf8 (destination: STRING_GENERAL; source_utf8_ptr: POINTER)
			--
		do
			utf8_c_string.set_shared_from_c (source_utf8_ptr)
			utf8_c_string.fill_string (destination)
		end

	append_from_utf8_of_size (destination: STRING_GENERAL; source_utf8_ptr: POINTER; size: INTEGER)
			--
		do
			utf8_c_string.set_shared_from_c_of_size (source_utf8_ptr, size)
			utf8_c_string.fill_string (destination)
		end

feature {NONE} -- Implementation

	utf8_c_string: EL_C_UTF8_STRING_8

end
