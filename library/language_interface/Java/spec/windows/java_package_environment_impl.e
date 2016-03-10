note
	description: "[
		deployment.properties file location
			Windows 7 : C:\Users\%username%\AppData\LocalLow\Sun\Java\Deployment
			Windows XP : C:\Documents and Settings\%username%\Application Data\Sun\Java\Deployment
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "4"

class
	JAVA_PACKAGE_ENVIRONMENT_IMPL

inherit
	EL_PLATFORM_IMPL

	EL_MODULE_PATH

create
	default_create

feature -- Constants

	JVM_library_path: EL_FILE_PATH
		once
			Result := Runtime_environment_info.jvm_dll_path
		end

	Default_java_jar_dir: EL_DIR_PATH
		once
			Result := Directory.joined_path_from_steps (Path.directory_name (Java_home_dir), << "lib" >>)
		end

	Java_home_dir: STRING
		once
			Result := Runtime_environment_info.java_home.string
		end

	Class_path_separator: CHARACTER = ';'

feature {NONE} -- Implementation

	Runtime_environment_info: JAVA_RUNTIME_ENVIRONMENT_INFO
		once
			create Result.make
		end

end
