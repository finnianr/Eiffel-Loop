note
	description: "System encodings accessible via [$source EL_SHARED_ENCODINGS]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-11 10:14:47 GMT (Friday 11th February 2022)"
	revision: "3"

class
	EL_SYSTEM_ENCODINGS

inherit
	SYSTEM_ENCODINGS
		rename
			Console_encoding as Console,
			System_encoding as System,
			Utf8 as Utf_8,
			Utf16 as Utf_16,
			Utf32 as Unicode,
			Iso_8859_1 as Latin_1
		end
end