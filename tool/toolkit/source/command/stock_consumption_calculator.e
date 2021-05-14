note
	description: "[
		Caculate monthly stock consumption based on an import_list import_list of stock orders represented by
		class [$source STOCK_ORDER]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-14 6:32:42 GMT (Friday 14th May 2021)"
	revision: "3"

class
	STOCK_CONSUMPTION_CALCULATOR

inherit
	EL_COMMAND

	TIME_UTILITY

	EL_FILE_OPEN_ROUTINES

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make (a_input_path, a_output_path: EL_FILE_PATH)
		do
			date_time_tools.Date_default_format_string.share (Default_date_format)

			input_path := a_input_path; output_path := a_output_path
			if output_path.is_empty then
				output_path := input_path.without_extension
				output_path.base.append_string_general ("-monthly-use")
				output_path.add_extension ("csv")
			end
		end

feature -- Access

	input_path: EL_FILE_PATH

	output_path: EL_FILE_PATH

feature -- Basic operations

	execute
		local
			import_list: EL_IMPORTABLE_ARRAYED_LIST [STOCK_ORDER]
			monthly_use_list: EL_ARRAYED_MAP_LIST [DATE, REAL]; last_order, order: STOCK_ORDER
			date: DATE; average: REAL; found_first: BOOLEAN; day_count: INTEGER
		do
			create import_list.make (50)

			import_list.import_csv_latin_1 (input_path)

			import_list.order_by (agent {STOCK_ORDER}.date, True)
			create monthly_use_list.make ((import_list.last.date.days - import_list.first.date.days + 1) // 30)
			across import_list as list loop
				order := list.item
				if attached last_order as last then
					average := (last_order.count / (order.date.days - last_order.date.days)).truncated_to_real
					from create date.make_by_days (last.date.days) until date ~ order.date loop
						if date.day = 1 then
							day_count := 1
							monthly_use_list.extend (date.twin, average)
							found_first := True
						end
						if found_first and date.day > 1 then
							monthly_use_list.last.value := monthly_use_list.last.value + average
							day_count := day_count + 1
						end
						date.day_forth
					end
					last_order := order
				else
					last_order := order
				end
			end
			if day_count < 30 then
				monthly_use_list.remove_tail (1)
			end
			if attached open (output_path, Write) as file then
				across monthly_use_list as list loop
					file.put_line (Line_template #$ [list.item.key.year, list.item.key.month, list.item.value])
				end
				file.close
			end
		end

feature {NONE} -- Constants

	Line_template: ZSTRING
		once
			Result := "%S/%S,%S"
		end

	Default_date_format: STRING = "[0]dd/[0]mm/yyyy"
end