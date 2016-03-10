note
	description: "Summary description for {EL_USER_INPUT_LIST}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:12 GMT (Tuesday 2nd September 2014)"
	revision: "3"

deferred class
	EL_INPUT_WIDGET [G]

inherit
	EL_MODULE_GUI

	EL_MODULE_SCREEN

feature {NONE} -- Initialization

	make (initial_value: G; values: INDEXABLE [G, INTEGER]; a_value_change_action: like value_change_action)
		do
			value_change_action := a_value_change_action
			make_widget (initialization_tuples (initial_value, values))
		end

	make_sorted (initial_value: G; values: INDEXABLE [G, INTEGER]; a_value_change_action: like value_change_action)
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

	initialization_tuples (initial_value: G; values: INDEXABLE [G, INTEGER]): ARRAYED_LIST [like Type_widget_initialization_tuple]
		local
			i, lower, upper: INTEGER
			tuple: like Type_widget_initialization_tuple
			tuples: ARRAY [like Type_widget_initialization_tuple]
		do
			lower := values.index_set.lower
			upper := values.index_set.upper
			create tuple
			create tuples.make_filled (tuple, 1, values.index_set.count)
			from i := lower until i > upper loop
				create tuple
				tuple.value := values [i]
				tuple.displayed_value := displayed_value (tuple.value).to_unicode
				tuple.is_current_value := tuple.value ~ initial_value
				tuples [i - lower + 1] := tuple
				i := i + 1
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

	default_sort_order: KL_COMPARATOR [like Type_widget_initialization_tuple]
		deferred
		end

	alphabetical_sort_order: KL_AGENT_COMPARATOR [like Type_widget_initialization_tuple]
		do
			create Result.make (
				agent (a, b: like Type_widget_initialization_tuple): BOOLEAN
					do
						Result := a.displayed_value < b.displayed_value
					end
			)
		end

	displayed_value (value: G): ASTRING
		deferred
		end

	do_change_action (value: G)
		do
			value_change_action.call ([value])
		end

	value_change_action: PROCEDURE [ANY, TUPLE [G]]

feature {NONE} -- Type definitions

	Type_widget_initialization_tuple: TUPLE [value: G; displayed_value: STRING_32; is_current_value: BOOLEAN]
		require
			never_called: false
		do
		end
end
