note
	description: "Windows wrapper fro TagLib::FileName"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-25 17:55:21 GMT (Friday 25th October 2019)"
	revision: "1"

class
	TL_FILE_NAME_CPP_API

feature {NONE} -- C++ Constructor

	cpp_new (utf_16: POINTER): POINTER
			-- FileName(const wchar_t *name)
		external
			"C++ [new TagLib::FileName %"toolkit/tiostream.h%"] (const wchar_t *)"
		end
end
