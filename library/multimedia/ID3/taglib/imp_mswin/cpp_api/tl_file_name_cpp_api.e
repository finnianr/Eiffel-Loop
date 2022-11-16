note
	description: "Windows wrapper fro TagLib::FileName"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "2"

class
	TL_FILE_NAME_CPP_API

feature {NONE} -- C++ Constructor

	cpp_new (utf_16: POINTER): POINTER
			-- FileName(const wchar_t *name)
		external
			"C++ [new TagLib::FileName %"toolkit/tiostream.h%"] (const wchar_t *)"
		end
end