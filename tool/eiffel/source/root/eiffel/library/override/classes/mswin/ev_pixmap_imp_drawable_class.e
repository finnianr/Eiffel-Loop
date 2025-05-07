note
	description: "Create edited version of class ${EV_ENVIRONMENT_I_CLASS}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-03-15 13:58:41 GMT (Sunday 15th March 2015)"
	revision: "1"

class
	EV_PIXMAP_IMP_DRAWABLE_CLASS

inherit
	EV_PIXMAP_IMP_CLASS
		redefine
			new_feature_edit_actions
		end

create
	make_editor

feature {NONE} -- Implementation

	new_feature_edit_actions: like feature_edit_actions
		do
			create Result
			Result ["on_parented"] := agent set_implementation_minimum_size
		end

end
