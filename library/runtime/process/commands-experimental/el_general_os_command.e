note
	description: "Summary description for {EL_GENERAL_OS_COMMAND}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:30 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_GENERAL_OS_COMMAND

inherit
	EL_OS_COMMAND [EL_GENERAL_COMMAND_IMPL]
		rename
			make as make_command
		end

create
	make

feature {NONE} -- Initialization

	make (name, a_template: STRING)
			--
		do
--			template_name := generating_type + "." + name
--			template := a_template
			make_command
		end

feature -- Element change

	set_variables_from_array (variable_name_and_value_array: ARRAY [TUPLE])
			--
		require
			valid_tuples: variable_name_and_value_array.for_all (
				agent (tuple: TUPLE): BOOLEAN
						--
					do
						Result := tuple.count = 2 and then tuple.reference_item (1).conforms_to (template)
					end

			)
		do
			variable_name_and_value_array.do_all (
				agent (variable_name_and_value: TUPLE)
					do
						if attached {STRING} variable_name_and_value.reference_item (1) as variable_name then
							if variable_name_and_value.is_double_item (2) then
								set_double (variable_name, variable_name_and_value.real_64_item (2))

							elseif variable_name_and_value.is_real_item (2) then
								set_real (variable_name, variable_name_and_value.real_32_item (2))

							elseif variable_name_and_value.is_integer_item (2) then
								set_integer (variable_name, variable_name_and_value.integer_32_item (2))

							elseif attached {STRING} variable_name_and_value.reference_item (2) as value then
								set_string (variable_name, value)

							end
						end
					end
			)
		end

	set_variable_quoted_value (variable_name, value: STRING)
		do
--			set_string (variable_name, String.quoted (value) )
		end

	set_string (variable_name, value: STRING)
			--
		do
--			put_variable (value, variable_name)
		end

	set_double (variable_name: STRING; value: DOUBLE)
			--
		do
--			put_double_variable (value, variable_name)
		end

	set_real (variable_name: STRING; value: REAL)
			--
		do
--			put_real_variable (value, variable_name)
		end

	set_integer (variable_name: STRING; value: INTEGER)
			--
		do
--			put_integer_variable (value, variable_name)
		end

feature {NONE} -- Implementation

	template_name: STRING

	template: STRING


end
