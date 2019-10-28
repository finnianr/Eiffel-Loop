note
	description: "Interface to class `TagLib::String' in `toolkit/tstring.h'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-27 16:49:47 GMT (Sunday   27th   October   2019)"
	revision: "1"

class
	TL_STRING_CPP_API

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

feature {NONE} -- C Externals

	frozen c_size_of: INTEGER
		external
			"C [macro <toolkit/tstring.h>]"
		alias
			"sizeof (TagLib::String)"
		end

	frozen c_size_of_utf16: INTEGER
		external
			"C [macro <toolkit/unicode.h>]"
		alias
			"sizeof (Unicode::UTF16)"
		end
end
