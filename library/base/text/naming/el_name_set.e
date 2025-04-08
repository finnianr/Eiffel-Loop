note
	description: "Set of names conforming to ${READABLE_STRING_8}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-08 11:17:21 GMT (Tuesday 8th April 2025)"
	revision: "1"

class
	EL_NAME_SET

inherit
	EL_HASH_SET [READABLE_STRING_8]
		redefine
			new_key_tester
		end

	EQUALITY_TESTER [READABLE_STRING_8]
		rename
			test as same_strings
		export
			{NONE} all
		undefine
			copy, is_equal
		redefine
			same_strings
		end

create
	make, make_equal

feature {NONE} -- Implementation

	new_key_tester: like key_tester
		do
			Result := Current -- same_strings (a, b: READABLE_STRING_8)
		end

	same_strings (a, b: READABLE_STRING_8): BOOLEAN
		do
			if a = b then
				Result := True
			else
				Result := a.same_string (b)
			end
		end

end