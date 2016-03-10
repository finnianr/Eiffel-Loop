note
	description: "Summary description for {EL_MONTH_LIST}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-03-01 14:19:03 GMT (Friday 1st March 2013)"
	revision: "3"

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

	DATE_CONSTANTS
		undefine
			default_create, is_equal, copy
		end

	EL_MODULE_STRING
		undefine
			default_create, is_equal, copy
		end

create
	make, make_long

feature {NONE} -- Initialization

	make (a_selection_action: PROCEDURE [ANY, TUPLE [INTEGER]])
			--
		do
			make_drop_down (1, 1 |..| 12, a_selection_action)
			disable_edit
		end

	make_long (a_selection_action: PROCEDURE [ANY, TUPLE [INTEGER]])
			--
		do
			is_long_format := True
			make_drop_down (1, 1 |..| 12, a_selection_action)
			disable_edit
		end

feature -- Status query

	is_long_format: BOOLEAN

feature {NONE} -- Implementation

	displayed_month (a_month: INTEGER): EL_ASTRING
		do
			if is_long_format then
				Result := to_long_month (a_month)
			else
				Result := to_month (a_month)
			end
		end

	to_month (a_month: INTEGER): EL_ASTRING
			--
		do
			Result := Months_text [a_month]
			Result.to_proper_case
		end

	to_long_month (a_month: INTEGER): EL_ASTRING
			--
		do
			Result := Long_months_text [a_month]
			Result.to_proper_case
		end
end
