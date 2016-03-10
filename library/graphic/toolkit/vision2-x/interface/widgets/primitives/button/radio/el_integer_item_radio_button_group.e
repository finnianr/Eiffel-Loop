note
	description: "Summary description for {EL_INTEGER_ITEM_RADIO_BUTTON_GROUP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-26 11:22:59 GMT (Saturday 26th December 2015)"
	revision: "6"

class
	EL_INTEGER_ITEM_RADIO_BUTTON_GROUP

inherit
	EL_RADIO_BUTTON_GROUP [INTEGER]
		rename
			default_sort_order as numeric_sort_order,
			make as make_button_group
		end

create
	make

feature {NONE} -- Initialization

	make (
		initial_value: INTEGER; values: INDEXABLE [INTEGER, INTEGER]; a_suffix: like suffix
		a_value_change_action: like value_change_action
	)
		do
			suffix := a_suffix
			make_button_group (initial_value, values, a_value_change_action)
		end

feature -- Access

	suffix: ZSTRING
		-- display suffix

feature {NONE} -- Implementation

	displayed_value (value: INTEGER): ZSTRING
		do
			create Result.make (2)
			Result.append_integer (value)
			if not suffix.is_empty then
				Result.append_character (' ')
				Result.append (suffix)
			end
		end

	numeric_sort_order: KL_AGENT_COMPARATOR [like Type_widget_initialization_tuple]
		do
			create Result.make (
				agent (a, b: like Type_widget_initialization_tuple): BOOLEAN
					do
						Result := a.value < b.value
					end
			)
		end

end
