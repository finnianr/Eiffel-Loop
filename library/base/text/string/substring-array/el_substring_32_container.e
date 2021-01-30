note
	description: "Abstraction to obtain count of `STRING_32' substrings"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-29 15:35:37 GMT (Friday 29th January 2021)"
	revision: "2"

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

	is_empty: BOOLEAN
		do
			Result := count = 0
		end

end