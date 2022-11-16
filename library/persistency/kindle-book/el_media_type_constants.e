note
	description: "Media type constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "3"

class
	EL_MEDIA_TYPE_CONSTANTS

inherit
	ANY
	
	EL_MODULE_TUPLE

feature {NONE} -- Constants

	Media_type_table: EL_HASH_TABLE [STRING, STRING]
		once
			create Result.make (<<
				["png",	Type.png],
				["html",	Type.html],
				["ncx",	Type.ncx],
				["txt",	Type.txt]
			>>)
		end

	Type: TUPLE [png, html, ncx, txt: STRING]
		once
			create Result
			Tuple.fill (Result, "image/png, application/xhtml+xml, application/x-dtbncx+xml, text/plain")
		end
end