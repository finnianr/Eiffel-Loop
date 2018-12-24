note
	description: "[
		Abstractions for mapping a data object conforming to `FINITE [G]' to a selectable widget,
		a combo box for example. The default sort-order defined by `less_than' is alphabetical `display_value'.
	]"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-12-21 9:01:51 GMT (Friday 21st December 2018)"
	revision: "6"

deferred class
	EL_INPUT_WIDGET [G]

inherit
	PART_COMPARATOR [EL_WIDGET_VALUE [G]]

feature {NONE} -- Initialization

	make (initial_value: G; values: FINITE [G]; a_value_change_action: like value_change_action)
		do
			value_change_action := a_value_change_action
			make_widget (new_value_list (initial_value, values))
		end

	make_sorted (initial_value: G; values: FINITE [G]; a_value_change_action: like value_change_action; in_ascending_order: BOOLEAN)
		local
			quick: QUICK_SORTER [EL_WIDGET_VALUE [G]]
			list: like new_value_list
		do
			value_change_action := a_value_change_action
			list := new_value_list (initial_value, values)
			create quick.make (Current)
			if in_ascending_order then
				quick.sort (list)
			else
				quick.reverse_sort (list)
			end
			make_widget (list)
		end

	make_widget (a_value_list: like new_value_list)
		deferred
		end

feature {NONE} -- Implementation

	displayed_value (value: G): ZSTRING
		deferred
		end

	do_change_action (value: G)
		do
			value_change_action.call ([value])
		end

	less_than (a, b: EL_WIDGET_VALUE [G]): BOOLEAN
		-- sort entries alphabetically by `displayed_value'
		do
			Result := a.as_string < b.as_string
		end

	new_value_list (initial_value: G; values: FINITE [G]): ARRAYED_LIST [EL_WIDGET_VALUE [G]]
		local
			l_values: LINEAR [G]; index: INTEGER
		do
			create Result.make (values.count)
			l_values := values.linear_representation
			-- Save cursor position
			if not l_values.off then
				index := l_values.index
			end
			from l_values.start until l_values.after loop
				Result.extend (create {EL_WIDGET_VALUE [G]}.make (initial_value, l_values.item, displayed_value (l_values.item)))
				l_values.forth
			end
			-- Restore cursor position
			if index > 0 and then attached {CHAIN [G]} values as values_chain then
				values_chain.go_i_th (index)
			end
		end

feature {NONE} -- Internal attributes

	value_change_action: PROCEDURE [G];

note
	descendants: "[
			EL_INPUT_WIDGET*
				[$source EL_RADIO_BUTTON_GROUP]*
					[$source EL_THUMBNAIL_RADIO_BUTTON_GROUP]
					[$source EL_INTEGER_ITEM_RADIO_BUTTON_GROUP]
					[$source EL_BOOLEAN_ITEM_RADIO_BUTTON_GROUP]
					[$source EL_LOCALE_ZSTRING_ITEM_RADIO_BUTTON_GROUP]
				[$source EL_DROP_DOWN_BOX]
					[$source EL_ZSTRING_DROP_DOWN_BOX]
						[$source EL_LOCALE_ZSTRING_DROP_DOWN_BOX]
					[$source EL_MONTH_DROP_DOWN_BOX]
	]"
end
