note
	description: "[
		Interface to class `TagLib::String'
		
			#include toolkit/tstring.h
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-07 10:21:11 GMT (Sunday 7th January 2024)"
	revision: "6"

class
	TL_STRING_CPP_API

inherit
	EL_CPP_API

feature {NONE} -- C++ Externals

	frozen cpp_append (self_ptr, utf_16: POINTER)
		external
			"C++ [TagLib::String %"toolkit/tstring.h%"] (const wchar_t *)"
		alias
			"operator+="
		end

	frozen cpp_clear (self_ptr: POINTER)
		external
			"C++ [TagLib::String %"toolkit/tstring.h%"] ()"
		alias
			"clear"
		end

	frozen cpp_equals (self_ptr, c_str: POINTER): BOOLEAN
		external
			"C++ [TagLib::String %"toolkit/tstring.h%"] (const char *): EIF_BOOLEAN"
		alias
			"operator=="
		end

	frozen cpp_is_latin_1 (self_ptr: POINTER): BOOLEAN
		external
			"C++ [TagLib::String %"toolkit/tstring.h%"] (): EIF_BOOLEAN"
		alias
			"isLatin1"
		end

	frozen cpp_new: POINTER
			--
		external
			"C++ [new TagLib::String %"toolkit/tstring.h%"] ()"
		end

	frozen cpp_size (self_ptr: POINTER): INTEGER
		--	Returns the size of the string.
		-- unsigned int size() const;
		external
			"C++ [TagLib::String %"toolkit/tstring.h%"] (): EIF_INTEGER"
		alias
			"size"
		end

	frozen cpp_i_th (self_ptr: POINTER; i: INTEGER): NATURAL
		require
			attached_pointer: is_attached (self_ptr)
		external
			"C++ inline use <toolkit/tstring.h>"
		alias
			"[
				const wchar_t c = ((TagLib::String*)$self_ptr)->operator[]((int)$i);
				return (EIF_NATURAL)c
			]"
		end

	frozen cpp_delete (self: POINTER)
			--
		external
			"C++ [delete TagLib::String %"toolkit/tstring.h%"] ()"
		end

end