note
	description: "[
		Convert ${READABLE_STRING_GENERAL} string to type conforming to ${EL_PATH}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-11-06 11:28:11 GMT (Wednesday 6th November 2024)"
	revision: "8"

deferred class
	EL_STRING_TO_PATH_TYPE [G -> EL_PATH create make end]

inherit
	EL_READABLE_STRING_GENERAL_TO_TYPE [G]
		redefine
			is_path, is_latin_1, new_type_description, type
		end

	EL_SHARED_ZSTRING_BUFFER_POOL

feature -- Access

	type: TYPE [EL_PATH]

feature -- Status query

	Is_path: BOOLEAN = True

	is_latin_1: BOOLEAN = False
		-- `True' if type can be always be represented by Latin-1 encoded string

feature -- Conversion

	as_type (str: READABLE_STRING_GENERAL): G
		do
			create Result.make (str)
		end

	substring_as_type (str: READABLE_STRING_GENERAL; start_index, end_index: INTEGER): G
		do
			if attached String_pool.borrowed_item as borrowed then
				create Result.make (borrowed.copied_substring_general (str, start_index, end_index))
				borrowed.return
			end
		end

feature -- Basic operations

	put_tuple_item (a_tuple: TUPLE; value: G; index: INTEGER)
		-- put `value' at `index' position in `a_tuple'
		do
			a_tuple.put_reference (value, index)
		end

feature {NONE} -- Implementation

	new_type_description: STRING
		-- terse English language description of type
		do
			if type ~ {DIR_PATH} then
				Result := "directory path"

			elseif type ~ {FILE_PATH} then
				Result := "file path"

			else
				Result := "URL"
			end
		end

end