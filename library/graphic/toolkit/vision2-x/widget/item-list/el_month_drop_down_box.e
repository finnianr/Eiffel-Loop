note
	description: "Month drop down box"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "7"

class
	EL_MONTH_DROP_DOWN_BOX

inherit
	EL_DROP_DOWN_BOX [INTEGER]
		rename
			displayed_value as displayed_month,
			selected_index as month,
			make as make_drop_down
		redefine
			displayed_month
		end

	EL_MODULE_DEFERRED_LOCALE

create
	make, make_long

feature {NONE} -- Initialization

	make (a_selection_action: PROCEDURE [INTEGER])
			--
		do
			make_drop_down (1, 1 |..| 12, a_selection_action)
			disable_edit
		end

	make_long (a_selection_action: PROCEDURE [INTEGER])
			--
		do
			is_long_format := True
			make_drop_down (1, 1 |..| 12, a_selection_action)
			disable_edit
		end

feature -- Status query

	is_long_format: BOOLEAN

feature {NONE} -- Implementation

	displayed_month (a_month: INTEGER): ZSTRING
		do
			if is_long_format then
				Result := Long_months [a_month]
			else
				Result := Short_months [a_month]
			end
		end

feature {NONE} -- Constants

	Short_months: EL_ZSTRING_LIST
			-- Short text representation of months
		once
			Result := Locale.date_text.short_month_names_list
		end

	Long_months: EL_ZSTRING_LIST
			-- Long text representation of months
		once
			Result := Locale.date_text.long_month_names_list
		end

end