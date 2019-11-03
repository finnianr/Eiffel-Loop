note
	description: "Obtains location of Java runtime dll from Windows registry"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-26 18:59:31 GMT (Saturday 26th October 2019)"
	revision: "4"

class
	JAVA_RUNTIME_ENVIRONMENT_INFO

inherit
	EL_MEMORY

	EL_MODULE_WIN_REGISTRY

create
	make

feature {NONE} -- Initialization

	make
		local
			steps: EL_PATH_STEPS; client_pos: INTEGER
		do
			jvm_dll_path := Win_registry.string (Current_version_reg_path, "RuntimeLib")
			if not jvm_dll_path.exists then
				steps := jvm_dll_path
				client_pos := steps.index_of ("client", 1)
				if client_pos > 0 then
					steps.put ("server", client_pos)
				end
				jvm_dll_path := steps
			end
			java_home := Win_registry.string (Current_version_reg_path, "JavaHome")
		ensure
			jvm_dll_path_exists: jvm_dll_path.exists
		end

feature -- Access

	java_home: EL_DIR_PATH

	jvm_dll_path: EL_FILE_PATH

feature {NONE} -- Constants

	Current_version_reg_path: EL_DIR_PATH
		once
			Result := JRE_reg_path.joined_dir_path (Win_registry.string (JRE_reg_path, "CurrentVersion"))
		end

	JRE_reg_path: EL_DIR_PATH
		once
			Result := "HKEY_LOCAL_MACHINE\SOFTWARE\JavaSoft\Java Runtime Environment"
		end

end
