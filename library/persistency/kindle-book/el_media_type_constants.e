note
	description: "Media type constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-11-06 11:28:11 GMT (Tuesday 6th November 2018)"
	revision: "1"

class
	EL_MEDIA_TYPE_CONSTANTS

inherit
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
