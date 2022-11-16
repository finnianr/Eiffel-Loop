note
	description: "Tl default unique file identifier"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "2"

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