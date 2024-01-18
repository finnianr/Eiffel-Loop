note
	description: "Windows implementation of ${JAVA_PLATFORM_I} interface"
	notes: "[
		`deployment.properties' file location

		**Windows 7**
			C:\Users\%username%\AppData\LocalLow\Sun\Java\Deployment
		**Windows XP**
			C:\Documents and Settings\%username%\Application Data\Sun\Java\Deployment
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-05 17:23:20 GMT (Sunday 5th November 2023)"
	revision: "10"

class
	JAVA_PLATFORM_IMP

inherit
	JAVA_PLATFORM_I
		export
			{NONE} all
		end

	EL_MODULE_TUPLE; EL_MODULE_WIN_REGISTRY

	EL_WINDOWS_IMPLEMENTATION

create
	make

feature {NONE} -- Initialization

	make
			--
		local
			steps: EL_PATH_STEPS; client_pos: INTEGER
		do
			class_path_separator := ';'
			default_jar_dir := java_home_dir #+ "lib"
			JVM_library_path := Win_registry.string (Current_version_reg_path, Reg_key.runtime_lib)
			if not JVM_library_path.exists then
				steps := JVM_library_path.twin
				client_pos := steps.index_of ("client", 1)
				if client_pos > 0 then
					steps [client_pos] := "server"
					JVM_library_path := steps
				end
			end
		end

feature {NONE} -- Implementation

	java_home_dir: DIR_PATH
		do
			Result := Win_registry.string (Current_version_reg_path, Reg_key.java_home)
		end

feature {NONE} -- Constants

	Current_version_reg_path: DIR_PATH
		once
			Result := JRE_reg_path #+ Win_registry.string (JRE_reg_path, Reg_key.current_version)
		end

	Reg_key: TUPLE [current_version, java_home, runtime_lib: ZSTRING]
		once
			create Result
			Tuple.fill (Result, "CurrentVersion, JavaHome, RuntimeLib")
		end

	JRE_reg_path: DIR_PATH
		once
			Result := "HKEY_LOCAL_MACHINE\SOFTWARE\JavaSoft\Java Runtime Environment"
		end

end