note
	description: "Windows package building contants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-08-06 18:03:13 GMT (Friday 6th August 2021)"
	revision: "7"

deferred class
	PACKAGE_BUILD_CONSTANTS

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Project_py: EL_FILE_PATH
		once
			Result := "project.py"
		end

	ISE_platform: EL_HASH_TABLE [STRING, INTEGER]
		do
			create Result.make (<< [32, "windows"], [64, "win64"] >>)
		end

	Yes_or_no: EL_BOOLEAN_INDEXABLE [STRING]
		once
			create Result.make ("no", "yes")
		end

end