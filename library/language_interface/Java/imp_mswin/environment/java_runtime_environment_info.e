note
	description: "Obtains location of Java runtime dll from Windows registry"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-15 18:39:54 GMT (Tuesday 15th February 2022)"
	revision: "6"

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
			steps: FILE_PATH; client_pos: INTEGER
		do
			jvm_dll_path := Win_registry.string (Current_version_reg_path, "RuntimeLib")
			if not jvm_dll_path.exists then
				steps := jvm_dll_path.twin
				client_pos := steps.index_of ("client", 1)
				if client_pos > 0 then
					steps.put_i_th_step ("server", client_pos)
					jvm_dll_path := steps
				end
			end
			java_home := Win_registry.string (Current_version_reg_path, "JavaHome")
		ensure
			jvm_dll_path_exists: jvm_dll_path.exists
		end

feature -- Access

	java_home: DIR_PATH

	jvm_dll_path: FILE_PATH

feature {NONE} -- Constants

	Current_version_reg_path: DIR_PATH
		once
			Result := JRE_reg_path #+ Win_registry.string (JRE_reg_path, "CurrentVersion")
		end

	JRE_reg_path: DIR_PATH
		once
			Result := "HKEY_LOCAL_MACHINE\SOFTWARE\JavaSoft\Java Runtime Environment"
		end

end
