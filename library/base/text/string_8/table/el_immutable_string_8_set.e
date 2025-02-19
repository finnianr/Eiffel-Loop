note
	description: "${EL_IMMUTABLE_STRING_SET} implementation for ${IMMUTABLE_STRING_8}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-02-19 15:54:31 GMT (Wednesday 19th February 2025)"
	revision: "1"

class
	EL_IMMUTABLE_STRING_8_SET

inherit
	EL_IMMUTABLE_STRING_SET [STRING_8, IMMUTABLE_STRING_8]

	EL_IMMUTABLE_KEY_8_LOOKUP

create
	make, make_equal

feature {NONE} -- Implementation

	new_shared (a_manifest: STRING_8): IMMUTABLE_STRING_8
		do
			Result := Immutable_8.new_substring (a_manifest.area, 0, a_manifest.count)
		end

	new_split_list: EL_SPLIT_IMMUTABLE_STRING_8_LIST
		do
			create Result.make_empty
		end

end