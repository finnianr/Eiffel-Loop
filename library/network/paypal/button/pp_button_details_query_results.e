note
	description: "Paypal button details query results"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-03-01 11:49:16 GMT (Friday 1st March 2024)"
	revision: "16"

class
	PP_BUTTON_DETAILS_QUERY_RESULTS

inherit
	PP_BUTTON_QUERY_RESULTS
		redefine
			make_default, make, set_indexed_value, set_name_value, new_field_printer, print_values
		end

create
	make_default, make

feature {NONE} -- Initialization

	make (query: STRING)
		do
			Precursor (query)
			across options_list as list loop
				list.item.set_currency_code (detail.currency_code)
			end
			http_read_ok := True
		end

	make_default
		do
			create options_list.make (5)
			create detail.make
			Precursor
		end

feature -- Basic operations

	print_values
		do
			if is_ok then
				print_fields (lio)
				lio.put_new_line
				across options_list as option loop
					lio.put_index_labeled_string (option, Void, Empty_string_8)
					option.item.print_fields (lio)
				end
			else
				print_error
			end
		end

feature -- Access

	button_code: STRING

	button_country: STRING

	button_image: STRING

	button_language: STRING

	button_sub_type: STRING

	button_type: STRING

	buy_now_text: STRING

	detail: PP_BUTTON_DETAIL

	option_0_name: STRING

	options_list: PP_REFLECTIVELY_SETTABLE_LIST [PP_BUTTON_OPTION]

feature {NONE} -- Implementation

	new_field_printer: EL_REFLECTIVE_CONSOLE_PRINTER
		-- Fields that will not be output by `print_fields'
		-- Must be comma-separated names
		do
			Result := Precursor
			Result.hidden_fields.append (", options_list, detail")
		end

	set_name_value (key, value: EL_ZSTRING)
		do
			if value.has_quotes (2) then
				value.remove_quotes
			end
			Precursor (key, value)
		end

	set_indexed_value (var_key: PP_L_VARIABLE; a_value: ZSTRING)
		do
			if var_key.is_option then
				options_list.set_i_th (var_key, a_value)

			elseif var_key.is_button_variable and then a_value.has (Assignment) then
				detail.set_field_from_nvp (a_value, Assignment)
			end
		end

end