note
	description: "Summary description for {EV_PIXMAP_IMP_DRAWABLE_EIFFEL_FEATURE_EDITOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EV_PIXMAP_IMP_DRAWABLE_EIFFEL_FEATURE_EDITOR

inherit
	EV_PIXMAP_IMP_EIFFEL_FEATURE_EDITOR
		redefine
			new_feature_edit_actions
		end

create
	make

feature {NONE} -- Implementation

	new_feature_edit_actions: like feature_edit_actions
		do
			create Result.make (<<
				["on_parented", agent set_implementation_minimum_size]
			>>)
		end

end
