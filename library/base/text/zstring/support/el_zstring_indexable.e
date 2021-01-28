note
	description: "[
		Object providing fast lookup of sequential characters not encodeable by `{[$source EL_ZSTRING]}.codec'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-28 10:01:04 GMT (Thursday 28th January 2021)"
	revision: "1"

class
	EL_ZSTRING_INDEXABLE

inherit
	EL_INDEXABLE_SUBSTRING_32_ARRAY

	EL_ZCODE_CONVERSION undefine default_create end

create
	default_create, make

feature -- Access

	z_code (i: INTEGER): NATURAL
		do
			Result := unicode_to_z_code (code (i))
		end

end