note
	description: "System encodings accessible via [$source EL_SHARED_ENCODINGS]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-14 12:42:16 GMT (Monday 14th February 2022)"
	revision: "4"

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

feature -- Access

	standard: ARRAY [ENCODING]
		do
			Result := << Latin_1, Utf_8, Utf_16, Unicode >>
		end
end