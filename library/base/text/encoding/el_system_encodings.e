note
	description: "System encodings accessible via ${EL_SHARED_ENCODINGS}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "5"

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