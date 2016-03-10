note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-03-01 13:38:22 GMT (Friday 1st March 2013)"
	revision: "2"

class
	EL_OPERATING_ENVIRONMENT_IMPL

inherit
	EL_PLATFORM_IMPL

	EL_MODULE_STRING

feature -- Access

	Command_option_prefix: CHARACTER = '/'
		-- Character used to prefix option in command line

	Search_path_separator: CHARACTER = ';'
		-- Character used to separate paths in a directorysearch path on this platform.

	Temp_directory_name: STRING
			--
		local
			environment: EXECUTION_ENVIRONMENT
		once
			create environment
			Result := environment.get ("TEMP")
		end

	CPU_model_name: STRING
			--
		local
			i: INTEGER
		do
			create Result.make (50)
			from i := 2 until i > 4 loop
				Result.append (cpu_info (Extended_function_CPUID_Information + i).string)
				i := i + 1
			end
			Result.left_adjust
		end

	Shell_path_escape_character: CHARACTER = '^'

	Shell_character_set_to_escape: STRING = "&|()^"
			-- Characters that should be escaped for Windows commands
			-- Not needed if argument quoted

	Dynamic_module_extension: STRING = "dll"

	C_library_prefix: STRING = ""

feature -- Measurement

	is_root_path (path: STRING): BOOLEAN
			--
		do
			Result := (path @ 1).is_alpha and path @ 2 = ':'
		end

feature {NONE} -- Implementation

	cpu_info (info_type: INTEGER): C_STRING
		local
			buffer: MANAGED_POINTER
		do
			create buffer.make (16)
			cwin_cpu_id (buffer.item, info_type)
			create Result.make_by_pointer_and_count (buffer.item, buffer.count)
		end

feature {NONE} -- Constants

	Extended_function_CPUID_Information: INTEGER = 0x80000000

feature {NONE} -- C Externals

		cwin_cpu_id (info_array: POINTER; info_type: INTEGER)
			-- void __cpuid(int CPUInfo[4], int InfoType);
		external
			"C [macro <intrin.h>] (int*, int)"
		alias
			"__cpuid"
		end

end
