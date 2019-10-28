note
	description: "Interface to class `TagLib::String' in `toolkit/tstring.h'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-28 13:06:04 GMT (Monday   28th   October   2019)"
	revision: "2"

class
	TL_STRING_CPP_API

inherit
	EL_POINTER_ROUTINES
		export
			{NONE} all
			{ANY} is_attached
		end

feature {NONE} -- C++ Externals

	frozen cpp_is_latin_1 (self_ptr: POINTER): BOOLEAN
		--	bool hasID3v2Tag()
		external
			"C++ [TagLib::String %"toolkit/tstring.h%"] (): EIF_BOOLEAN"
		alias
			"isLatin1"
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

feature {NONE} -- C Externals

	frozen c_size_of_utf16: INTEGER
		external
			"C [macro <toolkit/unicode.h>]"
		alias
			"sizeof (Unicode::UTF16)"
		end
end
