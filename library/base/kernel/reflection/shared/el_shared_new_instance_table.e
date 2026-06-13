note
	description: "[
		Shared access to table of object creation functions to initialize reference attributes
		reflectively. See class ${EL_REFLECTED_REFERENCE}.
		
		You can indirectly add to this table by overriding `new_instance_functions' from class
		${EL_REFLECTIVE}.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "20"

deferred class
	EL_SHARED_NEW_INSTANCE_TABLE

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	New_instance_table_broken: EL_FUNCTIONS_BY_RESULT_TYPE
		-- causes segmentation fault: https://support.eiffel.com/report_detail/20009
		once
			create Result.make (<<
				-- Path types
				agent: EL_PATH do create {DIR_PATH} Result end,
				-- Other
				agent: MANAGED_POINTER do create Result.make (0) end,
				agent: EL_QUANTITY_TEMPLATE do create Result.make end
			>>)
		end

	New_instance_table: EL_FUNCTIONS_BY_RESULT_TYPE
		-- workaround for segmentation fault
		local
			creator_array: ARRAY [FUNCTION [ANY]]
		once
			creator_array := <<
				-- Path types
				agent: EL_PATH do create {DIR_PATH} Result end,
				-- Other
				agent: MANAGED_POINTER do create Result.make (0) end,
				agent: EL_QUANTITY_TEMPLATE do create Result.make end
			>>
			create Result.make (creator_array)
		end

end
