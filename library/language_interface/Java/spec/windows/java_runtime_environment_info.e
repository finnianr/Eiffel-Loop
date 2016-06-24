note
	description: "Obtains location of Java runtime dll from Windows registry"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-22 15:42:35 GMT (Wednesday 22nd June 2016)"
	revision: "5"

class
	JAVA_RUNTIME_ENVIRONMENT_INFO

inherit
	EL_MODULE_PATH

	EL_MEMORY
create
	make

feature {NONE} -- Initialization

	make
		local
			registry: WEL_REGISTRY; key: POINTER
			current_version: STRING
			jvm_path_steps: EL_PATH_STEPS
		do
			create registry
			key := registry.open_key_with_access (JRE_reg_path, {WEL_REGISTRY_ACCESS_MODE}.Key_read)
			if is_attached (key) then
				current_version := registry.key_value (key, "CurrentVersion").string_value
				key := registry.open_key_with_access (
					Directory.joined_path (JRE_reg_path, current_version), {WEL_REGISTRY_ACCESS_MODE}.Key_read
				)
				if is_attached (key) then
					create jvm_path_steps.make_from_string (registry.key_value (key, "RuntimeLib").string_value)
					if not File.exists (jvm_path_steps) then
						jvm_path_steps.start
						jvm_path_steps.search ("client")
						if not jvm_path_steps.exhausted then
							jvm_path_steps.replace ("server")
						end
					end
					jvm_dll_path := jvm_path_steps
					create java_home.make_from_string (registry.key_value (key, "JavaHome").string_value)
				end
			end
		end

feature -- Access

	java_home: EL_DIR_PATH

	jvm_dll_path: EL_FILE_PATH

feature {NONE} -- Constants

	JRE_reg_path: EL_DIR_PATH
		once
			create Result.make_from_string ("HKEY_LOCAL_MACHINE\SOFTWARE\JavaSoft\Java Runtime Environment")
		end

end
