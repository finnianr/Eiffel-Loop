note
	description: "Tl comments"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-21 15:01:05 GMT (Saturday 21st March 2020)"
	revision: "1"

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
