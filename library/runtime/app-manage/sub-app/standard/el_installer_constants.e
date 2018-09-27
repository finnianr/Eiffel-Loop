note
	description: "Installer constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:15 GMT (Thursday 20th September 2018)"
	revision: "6"

class
	EL_INSTALLER_CONSTANTS

inherit
	EL_MODULE_EXECUTION_ENVIRONMENT

feature {NONE} -- Constants

	Package_dir: EL_DIR_PATH
		once
			if Execution_environment.is_work_bench_mode then
				Result := "build/$ISE_PLATFORM/package"; Result.expand
					-- Eg. "build/win64/package"
			else
				-- This is assumed to be the directory 'package/bin' unpacked by installer to a temporary directory
				Result := Execution_environment.executable_path.parent.parent
			end
		end

end
