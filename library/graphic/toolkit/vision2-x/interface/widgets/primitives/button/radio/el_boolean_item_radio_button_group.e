note
	description: "[
		Binary options represented as 2 radio buttons. If the the first option is selected, the `value_change_action'
		agent is called with the value `False'.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-04-19 12:20:38 GMT (Wednesday 19th April 2017)"
	revision: "1"

class
	EL_BOOLEAN_ITEM_RADIO_BUTTON_GROUP

inherit
	EL_RADIO_BUTTON_GROUP [BOOLEAN]
		rename
			make as make_button_group
		end

create
	make

feature {NONE} -- Initialization

	make (
		initial_value: BOOLEAN; false_option, true_option: ZSTRING
		a_value_change_action: like value_change_action
	)
		do
			create option_list.make_from_array (<< false_option, true_option >>)
			make_button_group (initial_value, << False, True >>, a_value_change_action)
		end

feature {NONE} -- Implementation

	default_sort_order: KL_AGENT_COMPARATOR [like WIDGET_INITIALIZATION_TUPLE]
		do
			create Result.make (
				agent (a, b: like WIDGET_INITIALIZATION_TUPLE): BOOLEAN
					do
						Result := a.value.to_integer < b.value.to_integer
					end
			)
		end

	displayed_value (value: BOOLEAN): ZSTRING
		do
			Result := option_list [value.to_integer + 1]
		end

feature {NONE} -- Internal attributes

	option_list: EL_ZSTRING_LIST
end
