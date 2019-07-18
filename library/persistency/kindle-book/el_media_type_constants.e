note
	description: "Media type constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 9:10:53 GMT (Monday 1st July 2019)"
	revision: "2"

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
