note
	description: "[
		Efficient appending of characters to an array of type [$source SPECIAL [CHARACTER_32]]
		from sources conforming to either [$source READABLE_STRING_32] or [$source READABLE_STRING_8]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-02-24 21:56:55 GMT (Friday 24th February 2023)"
	revision: "2"

deferred class
	EL_CHARACTER_ARRAY

feature -- Basic operations

	append_to (destination: SPECIAL [CHARACTER_32]; source_index, n: INTEGER)
		require
			enough_space: n <= destination.capacity - destination.count
		deferred
		end

end