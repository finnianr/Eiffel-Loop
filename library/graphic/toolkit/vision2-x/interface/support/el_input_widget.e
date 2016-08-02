note
	description: "Summary description for {EL_USER_INPUT_LIST}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-29 10:27:02 GMT (Friday 29th July 2016)"
	revision: "1"

deferred class
	EL_INPUT_WIDGET [G]

inherit
	EL_MODULE_GUI

	EL_MODULE_SCREEN

feature {NONE} -- Initialization

	make (initial_value: G; values: FINITE [G]; a_value_change_action: like value_change_action)
		do
			value_change_action := a_value_change_action
			make_widget (initialization_tuples (initial_value, values))
		end

	make_sorted (initial_value: G; values: FINITE [G]; a_value_change_action: like value_change_action)
		do
			is_sorted := True
			value_change_action := a_value_change_action
			make_widget (initialization_tuples (initial_value, values))
		end

	make_widget (a_initialization_tuples: like initialization_tuples)
		deferred
		end

feature -- Status query

	is_sorted: BOOLEAN

feature {NONE} -- Implementation

	alphabetical_sort_order: KL_AGENT_COMPARATOR [like Type_widget_initialization_tuple]
		do
			create Result.make (
				agent (a, b: like Type_widget_initialization_tuple): BOOLEAN
					do
						Result := a.displayed_value < b.displayed_value
					end
			)
		end

	default_sort_order: KL_COMPARATOR [like Type_widget_initialization_tuple]
		deferred
		end

	displayed_value (value: G): ZSTRING
		deferred
		end

	do_change_action (value: G)
		do
			value_change_action.call ([value])
		end

	initialization_tuples (initial_value: G; values: FINITE [G]): ARRAYED_LIST [like Type_widget_initialization_tuple]
		local
			linear_values: LINEAR [G]
			tuple: like Type_widget_initialization_tuple
			tuples: ARRAY [like Type_widget_initialization_tuple]
		do
			create tuple
			create tuples.make_filled (tuple, 1, values.count)
			linear_values := values.linear_representation
			from linear_values.start until linear_values.after loop
				create tuple
				tuple.value := linear_values.item
				tuple.displayed_value := displayed_value (tuple.value).to_unicode
				tuple.is_current_value := tuple.value ~ initial_value
				tuples [linear_values.index] := tuple
				linear_values.forth
			end
			if is_sorted then
				sort_tuples (tuples)
			end
			create Result.make_from_array (tuples)
		end

	sort_tuples (tuples: ARRAY [like Type_widget_initialization_tuple])
		local
			sorter: DS_ARRAY_QUICK_SORTER [like Type_widget_initialization_tuple]
		do
			create sorter.make (default_sort_order)
			sorter.sort (tuples)
		end

	value_change_action: PROCEDURE [ANY, TUPLE [G]]

feature {NONE} -- Type definitions

	Type_widget_initialization_tuple: TUPLE [value: G; displayed_value: STRING_32; is_current_value: BOOLEAN]
		require
			never_called: false
		do
		end
end
