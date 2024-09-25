note
	description: "Media type constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-23 12:30:19 GMT (Monday 23rd September 2024)"
	revision: "5"

class
	EL_MEDIA_TYPE_CONSTANTS

inherit
	ANY

	EL_MODULE_TUPLE

feature {NONE} -- Constants

	Media_type_table: EL_HASH_TABLE [STRING, STRING]
		once
			Result := <<
				["png", Type.png], ["html", Type.html], ["ncx", Type.ncx], ["txt", Type.txt]
			>>
		end

	Type: TUPLE [png, html, ncx, txt: STRING]
		once
			create Result
			Tuple.fill (Result, "image/png, application/xhtml+xml, application/x-dtbncx+xml, text/plain")
		end
end