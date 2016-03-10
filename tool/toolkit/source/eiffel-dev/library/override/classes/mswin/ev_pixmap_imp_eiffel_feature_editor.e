note
	description: "Summary description for {EV_PIXMAP_IMP_EIFFEL_FEATURE_EDITOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EV_PIXMAP_IMP_EIFFEL_FEATURE_EDITOR

inherit
	EIFFEL_OVERRIDE_FEATURE_EDITOR

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
			from class_feature.lines.finish until class_feature.lines.item.ends_with ("%Tend") loop
				class_feature.lines.back
			end
			class_feature.lines.back
			class_feature.lines.insert_line_right ("attached_interface.implementation.set_minimum_size (width, height)", 3)
		end

end
