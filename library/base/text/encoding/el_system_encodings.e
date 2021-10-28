note
	description: "System encodings accessible via [$source EL_MODULE_ENCODINGS]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-10-28 9:28:28 GMT (Thursday 28th October 2021)"
	revision: "1"

class
	EL_SYSTEM_ENCODINGS

inherit
	SYSTEM_ENCODINGS
		rename
			Console_encoding as Console,
			System_encoding as System,
			Utf8 as Utf_8,
			Utf16 as Utf_16,
			Utf32 as Unicode
		end
end