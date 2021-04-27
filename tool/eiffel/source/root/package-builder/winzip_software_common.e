note
	description: "Winzip software common"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-04-27 10:41:46 GMT (Tuesday 27th April 2021)"
	revision: "6"

class
	WINZIP_SOFTWARE_COMMON

feature -- Contract Support

	root_class_exists (a_pecf_path: EL_FILE_PATH): BOOLEAN
		do
			Result := (a_pecf_path.parent + Root_class_path).exists
		end

feature {NONE} -- Constants

	Project_py: EL_FILE_PATH
		once
			Result := "project.py"
		end

	Root_class_path: ZSTRING
		-- path to root class relative to project directory
		once
			Result := "source/application_root.e"
		end

end