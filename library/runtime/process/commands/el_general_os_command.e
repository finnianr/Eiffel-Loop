note
	description: "Summary description for {EL_GENERAL_OS_COMMAND}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-25 14:56:51 GMT (Thursday 25th July 2013)"
	revision: "3"

class
	EL_GENERAL_OS_COMMAND

inherit
	EL_OS_COMMAND [EL_GENERAL_COMMAND_IMPL]
		rename
			make as make_command
		redefine
			template, template_name
		end

create
	make

feature {NONE} -- Initialization

	make (name, a_template: STRING)
			--
		do
			template_name := generating_type + "." + name
			template := a_template
			make_command
		end

feature -- Element change

	set_variables_from_array (variable_name_and_value_array: ARRAY [TUPLE])
			--
		require
			valid_tuples:
				across variable_name_and_value_array as tuple all
					tuple.item.count = 2 and then attached {STRING} tuple.item.reference_item (1)
				end
		local
			value_ref: ANY
		do
			across variable_name_and_value_array as tuple loop
				if attached {STRING} tuple.item.reference_item (1) as variable_name then
					if tuple.item.is_double_item (2) then
						set_double (variable_name, tuple.item.real_64_item (2))

					elseif tuple.item.is_real_item (2) then
						set_real (variable_name, tuple.item.real_32_item (2))

					elseif tuple.item.is_integer_item (2) then
						set_integer (variable_name, tuple.item.integer_32_item (2))

					else
						value_ref := tuple.item.reference_item (2)
						if attached {STRING} value_ref as str_value then
							set_string (variable_name, str_value)
						else
							set_string (variable_name, value_ref.out)
						end
					end
				end
			end
		end

	set_variable_quoted_value (variable_name, value: STRING)
		do
			set_string (variable_name, String.quoted (value) )
		end

	set_string (variable_name, value: STRING)
			--
		do
			put_variable (value, variable_name)
		end

	set_double (variable_name: STRING; value: DOUBLE)
			--
		do
			put_double_variable (value, variable_name)
		end

	set_real (variable_name: STRING; value: REAL)
			--
		do
			put_real_variable (value, variable_name)
		end

	set_integer (variable_name: STRING; value: INTEGER)
			--
		do
			put_integer_variable (value, variable_name)
		end

feature {NONE} -- Implementation

	template_name: EL_FILE_PATH

	template: STRING_32

feature {NONE} -- Evolicity reflection

	getter_function_table: like getter_functions
			--
		do
			create Result
		end

end
