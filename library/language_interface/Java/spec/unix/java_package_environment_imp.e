note
	description: "Unix implementation of `JAVA_PACKAGE_ENVIRONMENT_I' interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-30 10:31:04 GMT (Thursday 30th June 2016)"
	revision: "5"

class
	JAVA_PACKAGE_ENVIRONMENT_IMP

inherit
	JAVA_PACKAGE_ENVIRONMENT_I
		export
			{NONE} all
		end

	EL_OS_IMPLEMENTATION

	EL_MODULE_DIRECTORY

	EL_MODULE_COMMAND

create
	make

feature -- Constants

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
					if path.item.steps.has (Server) then
						Result := path.item
						found := True
					end
				end
			end
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

	Default_java_jar_dir: EL_DIR_PATH
		once
			Result := "/usr/share/java"
		end

	JVM_home_dir: EL_DIR_PATH
		once
			Result := "/usr/lib/jvm"
		end

	Class_path_separator: CHARACTER = ':'

	Deployment_properties_path: STRING = ".java/deployment"

	JVM_library_name: STRING = "libjvm.so"

	Java_links: ARRAYED_LIST [STRING]
		once
			create Result.make_from_array (<< "java", "default-java" >>)
		end

end
