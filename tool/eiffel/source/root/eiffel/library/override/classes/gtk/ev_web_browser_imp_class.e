note
	description: "Create edited version of class ${EV_WEB_BROWSER_IMP}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-18 10:54:25 GMT (Friday 18th December 2015)"
	revision: "1"

class
	EV_WEB_BROWSER_IMP_CLASS

inherit
	OVERRIDE_FEATURE_EDITOR

create
	make

feature {NONE} -- Implementation

	change_type_of_webkit_object (class_feature: CLASS_FEATURE)
		do
			class_feature.search_substring (Statement_create_webkit)
			if class_feature.found then
				class_feature.found_line.replace_substring_all (Statement_create_webkit, Statement_create_el_webkit)
				class_feature.lines.append_comment ("changed type")
			end
		end

	dir_path: DIR_PATH
		-- original ISE location
		do
			Result := "web_browser/implementation/gtk"
		end

	new_feature_edit_actions: like feature_edit_actions
		do
			create Result
			Result ["make"] := agent change_type_of_webkit_object
		end

feature {NONE} -- Constants

	Checksum: NATURAL = 3043504719

	Statement_create_webkit: ZSTRING
		once
			Result := "create webkit"
		end

	Statement_create_el_webkit: ZSTRING
		once
			Result := "create {EL_WEBKIT_WEB_VIEW} webkit"
		end
end
