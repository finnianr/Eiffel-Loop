note
	description: "[
		Shared access to table of object creation functions to initialize reference attributes
		reflectively. See class [$source EL_REFLECTED_REFERENCE].
		
		You can indirectly add to this table by overriding `new_instance_functions' from class
		[$source EL_REFLECTIVE].
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-08 9:38:53 GMT (Thursday 8th December 2022)"
	revision: "18"

deferred class
	EL_SHARED_NEW_INSTANCE_TABLE

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	New_instance_table: EL_FUNCTIONS_BY_RESULT_TYPE
		once
			create Result.make (<<
				-- Strings
				agent: EL_URI do create Result.make_empty end,
				agent: EL_URL do create Result.make_empty end,

				-- Path types
				agent: EL_PATH do create {DIR_PATH} Result end,

				-- Other
				agent: MANAGED_POINTER do create Result.make (0) end,
				agent: EL_QUANTITY_TEMPLATE do create Result.make end
			>>)
		end

end