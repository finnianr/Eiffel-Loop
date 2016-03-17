note
	description: "Summary description for {EL_DROP_DOWN_BOX_2}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-26 11:19:24 GMT (Saturday 26th December 2015)"
	revision: "7"

class
	EL_DROP_DOWN_BOX [G]

inherit
	EL_COMBO_BOX
		export
			{NONE} set_text
		redefine
			initialize
		end

	EL_INPUT_WIDGET [G]
		rename
			default_sort_order as alphabetical_sort_order,
			initialization_tuples as create_initialization_tuples
		undefine
			is_equal, default_create, copy
		redefine
			make
		end

create
	make, make_unadjusted, make_alphabetical, make_alphabetical_unadjusted

feature {NONE} -- Initialization

	make (
		a_initial_value: G; a_values: INDEXABLE [G, INTEGER]; a_value_change_action: like value_change_action
	)
		do
			is_width_adjusted := True
			Precursor (a_initial_value, a_values, a_value_change_action)
		end

	make_alphabetical (
		a_initial_value: G; a_values: INDEXABLE [G, INTEGER]; a_value_change_action: like value_change_action
	)
			-- sorted alphabetially
		do
			is_width_adjusted := True
			is_sorted := True
			make (a_initial_value, a_values, a_value_change_action)
		end

	make_unadjusted (
		a_initial_value: G; a_values: INDEXABLE [G, INTEGER]; a_value_change_action: like value_change_action
	)
			-- Make drop down box with minimum width unadjusted for longest value
		do
			make (a_initial_value, a_values, a_value_change_action)
		end

	make_alphabetical_unadjusted (
		a_initial_value: G; a_values: INDEXABLE [G, INTEGER]; a_value_change_action: like value_change_action
	)
			-- Make drop down box with minimum width unadjusted for longest value
			-- and sorted alphabetially
		do
			is_sorted := True
			make (a_initial_value, a_values, a_value_change_action)
		end

	make_widget (a_initialization_tuples: like create_initialization_tuples)
			-- make a box with actual values mapped to display values
		local
			selected_string: STRING_32
		do
			default_create
			initialization_tuples := a_initialization_tuples

			create selected_string.make_empty
			across initialization_tuples as tuple loop
				extend (create {EV_LIST_ITEM}.make_with_text (tuple.item.displayed_value))
				if tuple.item.is_current_value then
					selected_string := tuple.item.displayed_value
				end
			end
			if is_width_adjusted and then not is_empty then
				adjust_width
			end
			if not selected_string.is_empty then
				set_text (selected_string)
			end
			select_actions.extend (
				agent
					do
						value_change_action.call ([selected_value])
					end
			)
		end

	initialize
		do
			Precursor
			create initialization_tuples.make (0)
		end

feature -- Access

	selected_value: G
		do
			Result := initialization_tuples.i_th (selected_index).value
		end

feature -- Element change

	set_value (a_value: G)
		do
			set_text (displayed_value (a_value).to_unicode)
		end

feature {NONE} -- Implementation

	displayed_value (value: G): ZSTRING
		do
			Result := value.out
		end

	initialization_tuples: like create_initialization_tuples

end
