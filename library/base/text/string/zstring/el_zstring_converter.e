note
	description: "[
		Convenience class for converting any string of type `READABLE_STRING_GENERAL' to type [$source EL_ZSTRING]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-02-03 8:57:28 GMT (Sunday 3rd February 2019)"
	revision: "2"

class
	EL_ZSTRING_CONVERTER

create
	make

feature {NONE} -- Initialization

	make
		do
			create item.make_empty
		end

feature -- Access

	to_zstring (str: READABLE_STRING_GENERAL): ZSTRING
		do
			if attached {ZSTRING} str as zstr then
				Result := zstr
			else
				Result := item
				Result.wipe_out
				Result.append_string_general (str)
			end
		end

	joined (str_1, str_2: READABLE_STRING_GENERAL): ZSTRING
		do
			Result := item
			Result.wipe_out
			Result.append_string_general (str_1)
			Result.append_string_general (str_2)
		end

feature {NONE} -- Internal attributes

	item: ZSTRING
end
