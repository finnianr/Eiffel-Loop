note
	description: "Abstraction to obtain count of `STRING_32' substrings"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-27 12:08:17 GMT (Wednesday 27th January 2021)"
	revision: "1"

deferred class
	EL_SUBSTRING_32_CONTAINER

feature -- Access

	count: INTEGER
		deferred
		end

feature -- Status query

	not_empty: BOOLEAN
		do
			Result := count.to_boolean
		end

end