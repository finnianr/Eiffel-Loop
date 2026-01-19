note
	description: "Create edited version of class ${EV_INTERNALLY_PROCESSED_TEXTABLE_IMP}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-18 12:50:06 GMT (Friday 18th December 2015)"
	revision: "1"

class
	EV_INTERNALLY_PROCESSED_TEXTABLE_IMP_CLASS

inherit
	OVERRIDE_FEATURE_EDITOR

create
	make

feature {NONE} -- Implementation

	dir_path: DIR_PATH
		-- original ISE location
		do
			Result := "vision2/implementation/mswin/properties"
		end

	new_feature_edit_actions: like feature_edit_actions
		do
			create Result.make_one ("escaped_text", agent fix_contract_expression)
		end

	fix_contract_expression (class_feature: CLASS_FEATURE)
		do
			class_feature.search_substring ("ampersand_occurrences_doubled")
			if class_feature.found then
				class_feature.found_line.replace_substring_all (": s.as_string_32", ": Result.as_string_32")
				class_feature.lines.append_comment ("fix")
			end
		end

feature {NONE} -- Constants

	Checksum: NATURAL = 2341369100
end
