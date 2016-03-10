note
	description: "Adds registry entry to prevent browser emulation mode of early IE version"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:27 GMT (Thursday 11th December 2014)"
	revision: "5"

class
	EL_WEB_BROWSER_INSTALLER

inherit
	EL_MODULE_WIN_REGISTRY

	EL_MODULE_EXECUTION_ENVIRONMENT

feature -- Basic operations

	install
		do
			Win_registry.set_integer (
				HKLM_IE_feature_browser_emulation, Execution.executable_name, Internet_explorer_major_version * 1000 + 1
			)
		end

	uninstall
		do
			Win_registry.remove_key_value (HKLM_IE_feature_browser_emulation, Execution.executable_name)
		end

feature {NONE} -- Constants

	Internet_explorer_major_version: INTEGER
		local
			version: EL_ASTRING
		once
			across << "svcVersion", "Version" >> as key_name until Result > 0 loop
				version := Win_registry.string (HKLM_Internet_explorer, key_name.item)
				if not version.is_empty then
					Result := version.split ('.').first.to_integer
				end
			end
		end

	HKLM_Internet_explorer: EL_DIR_PATH
		once
			Result := "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Internet Explorer"
		end

	HKLM_IE_feature_browser_emulation: EL_DIR_PATH
		once
			Result := HKLM_Internet_explorer.joined_dir_path ("MAIN\FeatureControl\FEATURE_BROWSER_EMULATION")
		end

end
