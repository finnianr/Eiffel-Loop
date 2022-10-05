note
	description: "[
		Convert [$source READABLE_STRING_GENERAL] string to type conforming to [$source EL_PATH]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-05 11:33:44 GMT (Wednesday 5th October 2022)"
	revision: "1"

deferred class
	EL_READABLE_STRING_GENERAL_TO_PATH_TYPE [G -> EL_PATH create make end]

inherit
	EL_READABLE_STRING_GENERAL_TO_TYPE [G]
		redefine
			is_path, new_type_description, type
		end

feature -- Access

	type: TYPE [EL_PATH]

feature -- Status query

	Is_path: BOOLEAN = True

feature -- Conversion

	as_type (str: READABLE_STRING_GENERAL): G
		do
			create Result.make (str)
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