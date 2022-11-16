note
	description: "[
		List of drop down element choices mapped to a type specified by generic paramater `G' and initialized with the following:
		
		**1. ** an initial value of type `G'
		
		**2. ** a container conforming to [$source FINITE [G]]
		
		**3. ** a change agent of type [$source PROCEDURE [G]]

		Optional initialization settings:
		
		**1. ** alphabetical ordering
		
		**2. ** Width adjustment for longest display string
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "11"

class
	EL_DROP_DOWN_BOX [G]

inherit
	EL_COMBO_BOX
		export
			{NONE} set_text
		redefine
			initialize
		end

	EL_FINITE_DATA_SET_WIDGET [G]
		rename
			make as make_unadjusted,
			make_sorted as make_unadjusted_sorted
		undefine
			is_equal, default_create, copy
		end

create
	default_create, make, make_unadjusted, make_sorted, make_unadjusted_sorted

feature {NONE} -- Initialization

	initialize
		do
			Precursor
			create value_list.make (0)
		end

	make (a_initial_value: G; a_value_list: ITERABLE [G]; change_action: PROCEDURE [G])
		do
			is_width_adjusted := True
			make_unadjusted (a_initial_value, a_value_list, change_action)
		end

	make_sorted (
		a_initial_value: G; a_value_list: ITERABLE [G]; change_action: PROCEDURE [G]; in_ascending_order: BOOLEAN
	)
			-- sorted alphabetially
		do
			is_width_adjusted := True
			make_unadjusted_sorted (a_initial_value, a_value_list, change_action, in_ascending_order)
		end

	make_widget (a_value_list: like new_value_list)
			-- make a box with actual values mapped to display values
		local
			selected_string: STRING_32
		do
			default_create
			value_list := a_value_list

			create selected_string.make_empty
			across a_value_list as value loop
				extend (create {EV_LIST_ITEM}.make_with_text (value.item.as_string_32))
				if value.item.is_current then
					selected_string := value.item.as_string_32
				end
			end
			if is_width_adjusted and then not is_empty then
				adjust_width
			end
			if not selected_string.is_empty then
				set_text (selected_string)
			end
			select_actions.extend (agent on_select_value)
		end

feature -- Access

	selected_value: G
		do
			Result := value_list.i_th (selected_index).value
		end

feature -- Element change

	set_value (a_value: G)
		do
			-- more efficient search loop if set to `STRING_32'
			set_text (displayed_value (a_value).to_string_32)
		end

	select_initial_item (a_index: INTEGER)
		-- select item without triggering `select_actions'
		do
			select_actions.block
			select_item (a_index)
			select_actions.resume
		end

feature {NONE} -- Event handling

	on_select_value
		do
			value_change_action.call ([selected_value])
		end

feature {NONE} -- Implementation

	displayed_value (value: G): ZSTRING
		do
			Result := value.out
		end

	value_list: like new_value_list

end