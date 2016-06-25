note
	description: "[
		Windows implementation of `JAVA_PACKAGE_ENVIRONMENT_I' interface
		deployment.properties file location
			Windows 7 : C:\Users\%username%\AppData\LocalLow\Sun\Java\Deployment
			Windows XP : C:\Documents and Settings\%username%\Application Data\Sun\Java\Deployment
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-24 11:27:29 GMT (Friday 24th June 2016)"
	revision: "5"

class
	JAVA_PACKAGE_ENVIRONMENT_IMP

inherit
	JAVA_PACKAGE_ENVIRONMENT_I
		export
			{NONE} all
		end

	EL_OS_IMPLEMENTATION

create
	make

feature -- Constants

	JVM_library_path: EL_FILE_PATH
		once
			Result := Runtime_environment_info.jvm_dll_path
		end

	Default_java_jar_dir: EL_DIR_PATH
		once
			Result := Java_home_dir.joined_dir_path ("lib")
		end

	Java_home_dir: EL_DIR_PATH
		once
			Result := Runtime_environment_info.java_home
		end

	Class_path_separator: CHARACTER = ';'

feature {NONE} -- Implementation

	Runtime_environment_info: JAVA_RUNTIME_ENVIRONMENT_INFO
		once
			create Result.make
		end

end
