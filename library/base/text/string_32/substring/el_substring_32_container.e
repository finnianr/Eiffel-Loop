note
	description: "Abstraction to obtain count of ${STRING_32} substrings"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:25 GMT (Saturday 20th January 2024)"
	revision: "5"

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