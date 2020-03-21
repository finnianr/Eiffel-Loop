note
	description: "Tl default unique file identifier"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-21 14:27:05 GMT (Saturday 21st March 2020)"
	revision: "1"

class
	TL_DEFAULT_UNIQUE_FILE_IDENTIFIER

inherit
	TL_UNIQUE_FILE_IDENTIFIER

feature -- Element change

	set_identifier (a_identifier: STRING)
		do
		end

	set_owner (a_owner: READABLE_STRING_GENERAL)
		do
		end

feature -- Access

	Identifier: STRING = ""

	Owner: ZSTRING
		once
			create Result.make_empty
		end

feature -- Status query

	is_default: BOOLEAN = True

end
