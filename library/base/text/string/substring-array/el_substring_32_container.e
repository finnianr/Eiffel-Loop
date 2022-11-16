note
	description: "Abstraction to obtain count of [$source STRING_32] substrings"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "4"

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