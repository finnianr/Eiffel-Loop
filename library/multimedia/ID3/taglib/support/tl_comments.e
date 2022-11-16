note
	description: "Tl comments"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "2"

deferred class
	TL_COMMENTS

feature -- Status query

	is_default: BOOLEAN
		deferred
		end

feature -- Access

	description: ZSTRING
		deferred
		end

	language: STRING
		deferred
		end

	text: ZSTRING
		deferred
		end
end