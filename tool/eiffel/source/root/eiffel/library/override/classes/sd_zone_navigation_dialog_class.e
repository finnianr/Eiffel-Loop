note
	description: "Create edited version of class ${SD_ZONE_NAVIGATION_DIALOG}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-18 12:50:34 GMT (Friday 18th December 2015)"
	revision: "1"

class
	SD_ZONE_NAVIGATION_DIALOG_CLASS

inherit
	OVERRIDE_FEATURE_EDITOR

create
	make

feature {NONE} -- Implementation

	dir_path: DIR_PATH
		-- original ISE location
		do
			Result := "docking/implementation/controls"
		end

	new_feature_edit_actions: like feature_edit_actions
		do
			create Result
			Result ["set_text_info"] := agent change_argument_type
		end

	change_argument_type (class_feature: CLASS_FEATURE)
		do
			class_feature.search_substring ("check_before_set_text")
			if class_feature.found then
				class_feature.found_line.replace_substring_all ("))", ".as_string_8))")
				class_feature.lines.append_comment ("fix")
			end
		end

feature {NONE} -- Constants

	Checksum: NATURAL = 1526596654

end
