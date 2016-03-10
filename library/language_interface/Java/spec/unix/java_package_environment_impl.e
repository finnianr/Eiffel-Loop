note
	description: "Summary description for {JAVA_ENVIRONMENT_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-24 12:16:10 GMT (Monday 24th June 2013)"
	revision: "2"

class
	JAVA_PACKAGE_ENVIRONMENT_IMPL

inherit
	EL_PLATFORM_IMPL

	EL_MODULE_DIRECTORY

create
	default_create

feature -- Constants

	JVM_library_path: EL_FILE_PATH
		local
			find_command: EL_FIND_FILES_COMMAND
			java_dir: EL_DIR_PATH
			found: BOOLEAN
			libjvm_path_list: ARRAYED_LIST [EL_FILE_PATH]
		once
			create Result
			across Java_links as link until found loop
				java_dir := JVM_home_dir.joined_dir_path (link.item)
				found := java_dir.exists
			end
			if found then
				create find_command.make (java_dir, JVM_library_name)
				find_command.set_follow_symbolic_links (True)
				find_command.execute
				libjvm_path_list := find_command.path_list
				found := False
				from libjvm_path_list.start until found or libjvm_path_list.after loop
					if libjvm_path_list.item.base.same_string ("server") then
						Result := libjvm_path_list.item
						found := True
					end
					libjvm_path_list.forth
				end
			end
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
