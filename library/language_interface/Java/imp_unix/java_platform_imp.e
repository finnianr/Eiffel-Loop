note
	description: "Unix implementation of ${JAVA_PLATFORM_I} interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-05 14:55:32 GMT (Sunday 5th November 2023)"
	revision: "10"

class
	JAVA_PLATFORM_IMP

inherit
	JAVA_PLATFORM_I
		export
			{NONE} all
		end

	EL_UNIX_IMPLEMENTATION

	EL_MODULE_DIRECTORY

	EL_MODULE_OS

create
	make

feature {NONE} -- Initialization

	make
			--
		local
			java_dir: DIR_PATH; found: BOOLEAN
			libjvm_path_list: EL_FILE_PATH_LIST
		do
			class_path_separator := ':'
			default_jar_dir := "/usr/share/java"
			create JVM_library_path

			across java_links as link until found loop
				java_dir := JVM_home_dir #+ link.item
				found := java_dir.exists
			end
			if found and then attached OS.find_files_command (java_dir, "libjvm.so") as cmd then
				cmd.set_follow_symbolic_links (True)
				cmd.execute
				libjvm_path_list := cmd.path_list
				found := False
				across libjvm_path_list as path until found loop
					if path.item.has_step (Server) then
						JVM_library_path := path.item
						found := True
					end
				end
			end
		end

feature {NONE} -- Implementation

	java_links: EL_STRING_8_LIST
		do
			Result := "java, default-java"
		end

feature {NONE} -- Constants

	JVM_home_dir: DIR_PATH
		once
			Result := "/usr/lib/jvm"
		end

	Server: ZSTRING
		once
			Result := "server"
		end

end