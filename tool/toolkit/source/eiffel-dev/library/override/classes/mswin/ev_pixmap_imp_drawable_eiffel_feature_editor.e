note
	description: "Summary description for {EV_PIXMAP_IMP_DRAWABLE_EIFFEL_FEATURE_EDITOR}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-03-15 13:58:41 GMT (Sunday 15th March 2015)"
	revision: "6"

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
