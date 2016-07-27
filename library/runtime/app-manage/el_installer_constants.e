note
	description: "Summary description for {EL_INSTALLER_CONSTANTS}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-04-10 11:35:50 GMT (Sunday 10th April 2016)"
	revision: "7"

class
	EL_INSTALLER_CONSTANTS

inherit
	EL_MODULE_EXECUTION_ENVIRONMENT

feature {NONE} -- Constants

	Package_dir: EL_DIR_PATH
		once
			if Execution_environment.is_work_bench_mode then
				Result := "package/$ISE_PLATFORM"; Result.expand
					-- Eg. "package/win64"
			else
				-- This is assumed to be the directory 'package/bin' unpacked by installer to a temporary directory
				Result := Execution_environment.executable_path.parent.parent
			end
		end

end