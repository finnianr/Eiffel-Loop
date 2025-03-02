note
	description: "[
		${ZSTRING} implementation of ${EL_TEXT_FILE_ITERATION_CURSOR} to decode
		lines from raw `file.last_string" text.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-02-28 16:34:05 GMT (Friday 28th February 2025)"
	revision: "2"

class
	EL_TEXT_FILE_DECODED_LINE_CURSOR

inherit
	EL_TEXT_FILE_ITERATION_CURSOR [ZSTRING]

create
	make

feature -- Access

	item_32: STRING_32
		do
			Result := file.last_decoded.to_string_32
		end

	shared_item: ZSTRING
		do
			Result := file.last_decoded
		end

end