note
	description: "Unix implementation of [$source JAVA_ENVIRONMENT_I] interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-14 12:54:50 GMT (Monday 14th February 2022)"
	revision: "7"

class
	JAVA_ENVIRONMENT_IMP

inherit
	JAVA_ENVIRONMENT_I
		export
			{NONE} all
		end

	EL_OS_IMPLEMENTATION

	EL_MODULE_DIRECTORY

	EL_MODULE_OS

create
	make

feature {NONE} -- Constants

	Class_path_separator: CHARACTER = ':'

	Default_java_jar_dir: DIR_PATH
		once
			Result := "/usr/share/java"
		end

	Deployment_properties_path: STRING = ".java/deployment"

	JVM_home_dir: DIR_PATH
		once
			Result := "/usr/lib/jvm"
		end

	JVM_library_name: STRING = "libjvm.so"

	JVM_library_path: FILE_PATH
		local
			java_dir: DIR_PATH; found: BOOLEAN
			libjvm_path_list: EL_FILE_PATH_LIST
		once
			create Result
			across Java_links as link until found loop
				java_dir := JVM_home_dir #+ link.item
				found := java_dir.exists
			end
			if found and then attached OS.find_files_command (java_dir, JVM_library_name) as cmd then
				cmd.set_follow_symbolic_links (True)
				cmd.execute
				libjvm_path_list := cmd.path_list
				found := False
				across libjvm_path_list as path until found loop
					if path.item.has_step (Server) then
						Result := path.item
						found := True
					end
				end
			end
		end

	Java_links: ARRAYED_LIST [STRING]
		once
			create Result.make_from_array (<< "java", "default-java" >>)
		end

	Server: ZSTRING
		once
			Result := "server"
		end

	User_application_data_dir, Default_user_application_data_dir: DIR_PATH
			--
		once
			Result := Directory.home
		end

end