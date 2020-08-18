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
	date: "2020-08-17 10:34:12 GMT (Monday 17th August 2020)"
	revision: "9"

deferred class
	EL_FINITE_DATA_SET_WIDGET [G]

inherit
	PART_COMPARATOR [EL_WIDGET_VALUE [G]]

	EL_MODULE_ITERABLE

feature {NONE} -- Initialization

	make (initial_value: G; value_list: ITERABLE [G]; change_action: PROCEDURE [G])
		do
			value_change_action := change_action
			make_widget (new_value_list (initial_value, value_list))
		end

	make_sorted (
		initial_value: G; value_list: ITERABLE [G]; change_action: PROCEDURE [G]; in_ascending_order: BOOLEAN
	)
		local
			quick: QUICK_SORTER [EL_WIDGET_VALUE [G]]
			list: like new_value_list
		do
			value_change_action := change_action
			list := new_value_list (initial_value, value_list)
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

	new_value_list (initial_value: G; value_list: ITERABLE [G]): ARRAYED_LIST [EL_WIDGET_VALUE [G]]
		local
			l_values: LINEAR [G]; index: INTEGER
		do
			create Result.make (Iterable.count (value_list))
			across value_list as list loop
				Result.extend (create {EL_WIDGET_VALUE [G]}.make (initial_value, list.item, displayed_value (list.item)))
			end
		end

feature {NONE} -- Internal attributes

	value_change_action: PROCEDURE [G];

note
	descendants: "[
			EL_FINITE_DATA_SET_WIDGET*
				[$source EL_RADIO_BUTTON_GROUP]*
					[$source EL_INTEGER_ITEM_RADIO_BUTTON_GROUP]
					[$source EL_THUMBNAIL_RADIO_BUTTON_GROUP]
					[$source EL_BOOLEAN_ITEM_RADIO_BUTTON_GROUP]
				[$source EL_DROP_DOWN_BOX]
					[$source EL_ZSTRING_DROP_DOWN_BOX]
						[$source EL_LOCALE_ZSTRING_DROP_DOWN_BOX]
					[$source EL_MONTH_DROP_DOWN_BOX]
	]"
end
