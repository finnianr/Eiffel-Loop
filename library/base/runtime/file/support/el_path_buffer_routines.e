note
	description: "Routines to buffer path strings of type ${ZSTRING}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "2"

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

	temporary_copy (path: READABLE_STRING_GENERAL): ZSTRING
		do
			Result := Temp_path
			if Result /= path then
				Result.wipe_out
				Result.append_string_general (path)
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

	Temp_path: ZSTRING
		once
			create Result.make_empty
		end

end