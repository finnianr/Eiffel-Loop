note
	description: "Markup templates"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-11-16 20:17:04 GMT (Friday 16th November 2018)"
	revision: "1"

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
