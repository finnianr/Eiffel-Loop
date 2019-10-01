note
	description: "[
		Shared access to table of object creation functions to initialize reference attributes
		reflectively. See class [$source EL_REFLECTED_REFERENCE].
		
		You can indirectly add to this table by overriding `new_instance_functions' from class
		[$source EL_REFLECTIVE].
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-30 6:54:26 GMT (Monday   30th   September   2019)"
	revision: "7"

deferred class
	EL_SHARED_NEW_INSTANCE_TABLE

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	New_instance_table: EL_FUNCTIONS_BY_RESULT_TYPE
		once
			create Result.make (<<
				-- Dates
				agent: DATE_TIME do create Result.make_now end,
				agent: EL_DATE_TIME do create Result.make_now end,
				agent: EL_ISO_8601_DATE_TIME do create Result.make_now end,
				agent: EL_SHORT_ISO_8601_DATE_TIME do create Result.make_now end,

				-- Strings
				agent: ZSTRING do create Result.make_empty end,
				agent: STRING_8 do create Result.make_empty end,
				agent: STRING_32 do create Result.make_empty end,

				-- String lists
				agent: EL_ZSTRING_LIST do create Result.make_empty end,
				agent: EL_STRING_8_LIST do create Result.make_empty end,
				agent: EL_STRING_32_LIST do create Result.make_empty end,

				-- Boolean refs
				agent: BOOLEAN_REF do create Result end,
				agent: EL_REFLECTIVE_BOOLEAN_REF do create Result.make_default end,
				agent: EL_BOOLEAN_OPTION do create Result end,

				-- Path types
				agent: EL_DIR_PATH do create Result end,
				agent: EL_FILE_PATH do create Result end,
				agent: EL_DIR_URI_PATH do create Result end,
				agent: EL_FILE_URI_PATH do create Result end
			>>)
		end

end

