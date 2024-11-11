note
	description: "[
		Routine to replace object conforming to ${EV_WIDGET} in it's parent container.
		Auxilary to class ${EL_WIDGET_REPLACEMENT [EV_WIDGET]}.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-11-11 9:46:10 GMT (Monday 11th November 2024)"
	revision: "14"

deferred class
	EL_WIDGET_3_REPLACEMENT [G -> EV_WIDGET]

inherit
	EL_MODULE_WIDGET

feature {NONE} -- Implementation

	replaced_3 (existing_widget, new_widget: G): G
		do
			Widget.replace (existing_widget, new_widget)
			Result := new_widget
		end

	replace_list_3 (widget_list, new_widgets_list: INDEXABLE [G, INTEGER])
		do
			Widget.replace_list (widget_list, new_widgets_list)
		end

end