note
	description: "Summary description for {EV_PIXMAP_IMP_EIFFEL_FEATURE_EDITOR}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-18 12:55:27 GMT (Friday 18th December 2015)"
	revision: "1"

class
	EV_PIXMAP_IMP_EIFFEL_FEATURE_EDITOR

inherit
	OVERRIDE_FEATURE_EDITOR

create
	make

feature {NONE} -- Implementation

	new_feature_edit_actions: like feature_edit_actions
		do
			create Result.make (<<
				["on_parented", agent set_implementation_minimum_size]
			>>)
		end

	set_implementation_minimum_size (class_feature: CLASS_FEATURE)
		do
			from class_feature.lines.finish until class_feature.lines.item.ends_with (Indented_keyword_end) loop
				class_feature.lines.back
			end
			class_feature.lines.back
			class_feature.lines.insert_line_right ("attached_interface.implementation.set_minimum_size (width, height)", 3)
		end

end
