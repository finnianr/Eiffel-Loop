note
	description: "Markup templates"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:07 GMT (Tuesday 15th November 2022)"
	revision: "2"

class
	EL_MARKUP_TEMPLATES

feature {NONE} -- Constants

	Tag_close: ZSTRING
		once
			Result := "</%S>"
		end

	Tag_open: ZSTRING
		once
			Result := "<%S>"
		end

	Tag_empty: ZSTRING
		once
			Result := "<%S/>"
		end

end