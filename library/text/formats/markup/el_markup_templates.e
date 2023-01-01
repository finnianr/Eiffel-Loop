note
	description: "Markup templates"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-01 17:21:30 GMT (Sunday 1st January 2023)"
	revision: "3"

deferred class
	EL_MARKUP_TEMPLATES

inherit
	EL_ANY_SHARED

	EL_MODULE_TUPLE

feature {NONE} -- Constants

	Tag: TUPLE [close, empty, open: ZSTRING]
		once
			create Result
			Tuple.fill (Result, "</%S>,<%S/>,<%S>")
		end

end