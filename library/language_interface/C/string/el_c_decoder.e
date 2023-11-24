note
	description: "C decoder accessible via [$source EL_MODULE_C_DECODER]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-24 17:34:22 GMT (Friday 24th November 2023)"
	revision: "9"

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
			create utf_8_c_string
		end

feature -- Basic operations

	set_from_utf_8 (target: STRING_GENERAL; source_utf_8_ptr: POINTER)
			--
		do
			target.set_count (0)
			append_from_utf_8 (target, source_utf_8_ptr)
		end

	set_from_utf_8_of_size (target: STRING_GENERAL; source_utf_8_ptr: POINTER; size: INTEGER)
			--
		do
			target.set_count (0)
			append_from_utf_8_of_size (target, source_utf_8_ptr, size)
		end

	append_from_utf_8 (destination: STRING_GENERAL; source_utf_8_ptr: POINTER)
			--
		do
			utf_8_c_string.set_shared_from_c (source_utf_8_ptr)
			utf_8_c_string.fill_string (destination)
		end

	append_from_utf_8_of_size (destination: STRING_GENERAL; source_utf_8_ptr: POINTER; size: INTEGER)
			--
		do
			utf_8_c_string.set_shared_from_c_of_size (source_utf_8_ptr, size)
			utf_8_c_string.fill_string (destination)
		end

feature {NONE} -- Implementation

	utf_8_c_string: EL_C_UTF_STRING_8

end