note
	description: "Unix implementation of [$source JAVA_ENVIRONMENT_I] interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-10 9:32:41 GMT (Wednesday 10th March 2021)"
	revision: "4"

class
	JAVA_ENVIRONMENT_IMP

inherit
	JAVA_ENVIRONMENT_I
		export
			{NONE} all
		end

	EL_OS_IMPLEMENTATION

	EL_MODULE_DIRECTORY

	EL_MODULE_COMMAND

create
	make

feature {NONE} -- Constants

	Class_path_separator: CHARACTER = ':'

	Default_java_jar_dir: EL_DIR_PATH
		once
			Result := "/usr/share/java"
		end

	Deployment_properties_path: STRING = ".java/deployment"

	JVM_home_dir: EL_DIR_PATH
		once
			Result := "/usr/lib/jvm"
		end

	JVM_library_name: STRING = "libjvm.so"

	JVM_library_path: EL_FILE_PATH
		local
			find_command: like Command.new_find_files
			java_dir: EL_DIR_PATH; found: BOOLEAN
			libjvm_path_list: ARRAYED_LIST [EL_FILE_PATH]
		once
			create Result
			across Java_links as link until found loop
				java_dir := JVM_home_dir.joined_dir_path (link.item)
				found := java_dir.exists
			end
			if found then
				find_command := Command.new_find_files (java_dir, JVM_library_name)
				find_command.set_follow_symbolic_links (True)
				find_command.execute
				libjvm_path_list := find_command.path_list
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

	User_application_data_dir, Default_user_application_data_dir: EL_DIR_PATH
			--
		once
			Result := Directory.home
		end

end