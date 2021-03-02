note
	description: "Abstraction to obtain count of [$source STRING_32] substrings"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-02 17:54:05 GMT (Tuesday 2nd March 2021)"
	revision: "3"

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