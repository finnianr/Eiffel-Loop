note
	description: "Summary description for {EV_WEB_BROWSER_IMP_EIFFEL_FEATURE_EDITOR}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-18 10:54:25 GMT (Friday 18th December 2015)"
	revision: "7"

class
	EV_WEB_BROWSER_IMP_EIFFEL_FEATURE_EDITOR

inherit
	EIFFEL_OVERRIDE_FEATURE_EDITOR

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

	new_feature_edit_actions: like feature_edit_actions
		do
			create Result.make (<<
				["make", agent change_type_of_webkit_object]
			>>)
		end

feature {NONE} -- Constants

	Statement_create_webkit: ZSTRING
		once
			Result := "create webkit"
		end

	Statement_create_el_webkit: ZSTRING
		once
			Result := "create {EL_WEBKIT_WEB_VIEW} webkit"
		end
end
