note
	description: "[
		Convenience class for converting any string of type [$source READABLE_STRING_GENERAL]
		to type [$source ZSTRING]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-12-31 16:58:49 GMT (Friday 31st December 2021)"
	revision: "5"

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