note
	description: "Windows package building contants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-08-06 20:12:02 GMT (Friday 6th August 2021)"
	revision: "8"

deferred class
	PACKAGE_BUILD_CONSTANTS

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Exe_path_template: ZSTRING
		once
			Result := "build/%S/package/bin/%S"
		end

	Project_py: EL_FILE_PATH
		once
			Result := "project.py"
		end

	ISE_platform_table: EL_HASH_TABLE [STRING, INTEGER]
		once
			create Result.make (<< [32, "windows"], [64, "win64"] >>)
		end

	Yes_or_no: EL_BOOLEAN_INDEXABLE [STRING]
		once
			create Result.make ("no", "yes")
		end

end