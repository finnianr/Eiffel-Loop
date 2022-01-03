note
	description: "[
		Windows implementation of [$source JAVA_ENVIRONMENT_I] interface
	]"
	notes: "[
		`deployment.properties' file location

		**Windows 7**
			C:\Users\%username%\AppData\LocalLow\Sun\Java\Deployment
		**Windows XP**
			C:\Documents and Settings\%username%\Application Data\Sun\Java\Deployment
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-03 15:54:04 GMT (Monday 3rd January 2022)"
	revision: "5"

class
	JAVA_ENVIRONMENT_IMP

inherit
	JAVA_ENVIRONMENT_I
		export
			{NONE} all
		end

	EL_OS_IMPLEMENTATION

create
	make

feature {NONE} -- Constants

	Class_path_separator: CHARACTER = ';'

	Default_java_jar_dir: DIR_PATH
		once
			Result := Java_home_dir.joined_dir_path ("lib")
		end

	Java_home_dir: DIR_PATH
		once
			Result := Runtime_environment_info.java_home
		end

	JVM_library_path: FILE_PATH
		once
			Result := Runtime_environment_info.jvm_dll_path
		end

	Runtime_environment_info: JAVA_RUNTIME_ENVIRONMENT_INFO
		once
			create Result.make
		end

end
