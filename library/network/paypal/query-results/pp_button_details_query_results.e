note
	description: "Summary description for {PP_BUTTON_DETAILS_QUERY_RESULTS}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-13 13:08:10 GMT (Friday 13th April 2018)"
	revision: "3"

class
	PP_BUTTON_DETAILS_QUERY_RESULTS

inherit
	PP_BUTTON_QUERY_RESULTS
		redefine
			make_default, make, set_name_value, Hidden_fields, print_values
		end

create
	make_default, make

feature {NONE} -- Initialization

	make (query: STRING)
		do
			Precursor (query)
			options_list.do_all (agent {PP_BUTTON_OPTION}.set_currency (detail.currency_code.value))
		end

	make_default
		do
			Precursor
			create options_list.make (5)
			create detail.make
		end

feature -- Basic operations

	print_values
		do
			if is_ok then
				print_fields (lio)
				lio.put_new_line
				across options_list as option loop
					lio.put_string (option.cursor_index.out + ". ")
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

	set_name_value (var_key: PP_VARIABLE; a_value: ZSTRING)
		do
			if a_value.has_quotes (2) then
				a_value.remove_quotes
			end
			if Parameter.L_options.has (var_key.code) then
				options_list.set_i_th (var_key, a_value)

			elseif var_key.code = Parameter.l_button_var and then a_value.has (Assignment) then
				detail.set_field_from_nvp (a_value, Assignment)
			else
				set_field (var_key.name, a_value)
			end
		end

feature {NONE} -- Constants

	Hidden_fields: STRING
			-- Fields that will not be output by `print_fields'
			-- Must be comma-separated names
		once
			Result := Precursor + ", options_list, detail"
		end

end
