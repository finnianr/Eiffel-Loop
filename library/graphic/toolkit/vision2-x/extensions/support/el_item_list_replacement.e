note
	description: "[
		Routine to replace object conforming to ${EV_ITEM} in it's parent container
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-11-10 15:01:06 GMT (Sunday 10th November 2024)"
	revision: "12"

deferred class
	EL_ITEM_LIST_REPLACEMENT [G -> EV_ITEM]

inherit
	EL_MODULE_WIDGET

feature {NONE} -- Implementation

	replaced_item (existing_widget, new_widget: G): G
		do
			Widget.replace_item (existing_widget, new_widget)
			Result := new_widget
		end

end