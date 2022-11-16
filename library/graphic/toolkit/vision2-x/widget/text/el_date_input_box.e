note
	description: "Combined date input components: day, month and year fields in a horizontal box"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "3"

class
	EL_DATE_INPUT_BOX

inherit
	EL_HORIZONTAL_BOX
		rename
			make as make_box
		end

create
	make

feature {NONE} -- Initialization

	make (a_border_cms, a_padding_cms: REAL)
		do
			create date.make (0, 0, 0)
			create day_field.make (agent date.set_day)
			create month_list.make_long (agent date.set_month)
			create year_field.make (agent date.set_year)

			day_field.set_capacity (2); year_field.set_capacity (4)
			across << day_field, year_field >> as field loop
				field.item.disable_undo
			end
			across << day_field.change_actions, month_list.select_actions, year_field.change_actions >> as actions loop
				actions.item.extend (agent on_date_change)
			end

			on_invalid_date := agent on_default_date
			on_valid_date := agent on_default_date

			make_unexpanded (a_border_cms, a_padding_cms, << day_field, month_list, year_field >>)
		end

feature -- Access

	date: DATE

	day_field: EL_INTEGER_INPUT_FIELD

	month_list: EL_MONTH_DROP_DOWN_BOX

	year_field: EL_INTEGER_INPUT_FIELD

	colorizable_widgets: ARRAY [EV_COLORIZABLE]
		do
			Result := << day_field, month_list, year_field >>
		end

feature -- Status query

	is_valid_date: BOOLEAN
		do
			Result := Date_checker.ordered_compact_date_valid (date.ordered_compact_date)
		end

feature -- Element change

	set_initial_date (a_date: like date)
		do
			date.copy (a_date)
			day_field.set_initial_value (a_date.day)
			month_list.select_initial_item (a_date.month)
			year_field.set_initial_value (a_date.year)
		end

	set_invalid_date_action (a_on_invalid_date: like on_invalid_date)
		do
			on_invalid_date := a_on_invalid_date
		end

	set_valid_date_action (a_on_valid_date: like on_valid_date)
		do
			on_valid_date := a_on_valid_date
		end

feature {NONE} -- Internal attributes

	on_invalid_date: PROCEDURE [DATE]

	on_valid_date: PROCEDURE [DATE]

feature {NONE} -- Event handling

	on_date_change
		do
			if is_valid_date then
				on_valid_date (date.twin)
			else
				on_invalid_date (date.twin)
			end
		end

	on_default_date (a_date: DATE)
		do
		end

feature {NONE} -- Constants

	Date_checker: DATE_VALIDITY_CHECKER
		once
			create Result
		end
end