note
	description: "Tl default comments"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-21 15:03:03 GMT (Saturday 21st March 2020)"
	revision: "1"

class
	TL_DEFAULT_COMMENTS

inherit
	TL_COMMENTS

feature -- Access

	Description: ZSTRING
		once
			create Result.make_empty
		end

	Language: STRING = ""

	Text: ZSTRING
		once
			create Result.make_empty
		end

feature -- Status query

	is_default: BOOLEAN = True
end
