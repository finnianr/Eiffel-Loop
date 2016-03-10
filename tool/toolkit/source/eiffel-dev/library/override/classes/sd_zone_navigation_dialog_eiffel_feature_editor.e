note
	description: "Summary description for {SD_ZONE_NAVIGATION_DIALOG_EIFFEL_FEATURE_EDITOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SD_ZONE_NAVIGATION_DIALOG_EIFFEL_FEATURE_EDITOR

inherit
	EIFFEL_OVERRIDE_FEATURE_EDITOR

create
	make

feature {NONE} -- Implementation

	new_feature_edit_actions: like feature_edit_actions
		do
			create Result.make (<<
				["set_text_info", agent change_argument_type]
			>>)
		end

	change_argument_type (class_feature: CLASS_FEATURE)
		do
			class_feature.search_substring ("check_before_set_text")
			if class_feature.found then
				class_feature.found_line.replace_substring_all ("))", ".as_string_8))")
				class_feature.lines.append_comment ("fix")
			end
		end

end
