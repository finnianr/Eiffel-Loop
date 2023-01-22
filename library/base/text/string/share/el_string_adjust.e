note
	description: "String adjustment status that can be combined with ''bit_or'' operator"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-22 16:45:50 GMT (Sunday 22nd January 2023)"
	revision: "4"

expanded class
	EL_STRING_ADJUST

feature -- Constants

	Both: INTEGER = 3

	Left: INTEGER = 1

	None: INTEGER = 0

	Right: INTEGER = 2

feature -- Contract Support

	frozen valid (bitmap: INTEGER): BOOLEAN
		do
			Result := None <= bitmap and then bitmap <= 7
		end

invariant
	left_is_one: Left = 1 -- Allows `left_adjusted.to_integer'
end