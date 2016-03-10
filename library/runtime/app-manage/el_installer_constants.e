note
	description: "Summary description for {EL_INSTALLER_CONSTANTS}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-07-04 9:27:30 GMT (Saturday 4th July 2015)"
	revision: "6"

class
	EL_INSTALLER_CONSTANTS

inherit
	EL_MODULE_EXECUTION_ENVIRONMENT

feature {NONE} -- Constants

	Package_dir_steps: EL_PATH_STEPS
		once
			if Execution_environment.is_work_bench_mode then
				Result := << "package", Execution_environment.item ("ISE_PLATFORM").to_string_8 >>
					-- Eg. "package/win64"
			else
				-- This is assumed to be the directory 'package/bin' unpacked by installer to a temporary directory
				Result := Command_dir_steps.twin
				Result.remove_tail (1)
			end
		end

	Command_dir_steps: EL_PATH_STEPS
		-- location of executable
		once
			Result := Execution_environment.executable_path.parent
		end

end
