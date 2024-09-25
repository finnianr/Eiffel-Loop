note
	description: "Adds registry entry to prevent browser emulation mode of early IE version"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-03-30 17:40:47 GMT (Wednesday 30th March 2016)"
	revision: "1"

class
	EL_WEB_BROWSER_INSTALLER

inherit
	ANY

	EL_MODULE_EXECUTABLE; EL_MODULE_HKEY_LOCAL_MACHINE; EL_MODULE_WIN_REGISTRY

feature -- Basic operations

	install
		do
			Win_registry.set_integer (
				HKLM_IE_feature_browser_emulation, Executable.name, Internet_explorer_major_version * 1000 + 1
			)
		end

	uninstall
		do
			Win_registry.remove_key_value (HKLM_IE_feature_browser_emulation, Executable.name)
		end

feature {NONE} -- Constants

	Internet_explorer_major_version: INTEGER
		local
			version: ZSTRING
		once
			across << "svcVersion", "Version" >> as key_name until Result > 0 loop
				version := Win_registry.string (Key_local.Internet_explorer, key_name.item)
				if not version.is_empty then
					Result := version.substring_to ('.').to_integer
				end
			end
		end

	HKLM_IE_feature_browser_emulation: EL_DIR_PATH
		-- HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Internet Explorer\MAIN\FeatureControl
		once
			Result := Key_local.Internet_explorer #+ "MAIN\FeatureControl\FEATURE_BROWSER_EMULATION"
		end

end
