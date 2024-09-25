note
	description: "Routines to buffer path strings of type ${ZSTRING}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-25 9:44:36 GMT (Wednesday 25th September 2024)"
	revision: "5"

deferred class
	EL_PATH_BUFFER_ROUTINES

inherit
	ANY undefine is_equal end

feature {NONE} -- Implementation

	empty_temp_path: ZSTRING
		-- temporary shared path
		do
			Result := Temp_path
			Result.wipe_out
		end

	temporary_copy (path: READABLE_STRING_GENERAL; start_index: INTEGER): ZSTRING
		do
			Result := Temp_path
			if Result = path then
				if start_index > 1 then
				-- remove C:
					Result.remove_head (start_index - 1)
				end
			else
				Result.wipe_out
				inspect start_index
					when 1 then
						Result.append_string_general (path)
				else
					Result.append_substring_general (path, start_index, path.count)
				end
			end
		end

	temporary_path: ZSTRING
		-- temporary shared copy of current path
		do
			Result := empty_temp_path
			append_to (Result)
		end

feature {NONE} -- Deferred

	append_to (str: EL_APPENDABLE_ZSTRING)
		deferred
		end

feature {NONE} -- Constants

	Drive: ZSTRING
		once
			Result := "X:"
		end

	Temp_path: ZSTRING
		once
			create Result.make_empty
		end

end