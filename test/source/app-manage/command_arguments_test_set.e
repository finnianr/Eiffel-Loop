note
	description: "Test set for ${EL_COMMAND_ARGUMENT} and ${EL_COMMAND_LINE_ARGUMENTS}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-11-18 13:19:58 GMT (Monday 18th November 2024)"
	revision: "1"

class
	COMMAND_ARGUMENTS_TEST_SET

inherit
	EL_EQA_TEST_SET

	EL_FALLIBLE
		export
			{NONE} all
		undefine
			default_create
		end

	EL_MODULE_ARGS; EL_MODULE_TUPLE

	EL_ZSTRING_CONSTANTS

create
	make


feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["boolean_operand_setter",		 agent test_boolean_operand_setter],
				["string_list_operand_setter", agent test_string_list_operand_setter]
			>>)
		end

feature -- Tests

	test_boolean_operand_setter
		note
			testing: "[
				covers/{EL_COMMAND_ARGUMENT}.try_put_argument,
				covers/{EL_MAKE_OPERAND_SETTER}.try_put_operand,
				covers/{EL_BOOLEAN_OPERAND_SETTER}.value,
				covers/{EL_COMMAND_LINE_ARGUMENTS}.make
			]"
		local
			argument_array: ARRAY [STRING]; make_routine: PROCEDURE; l_flag: BOOLEAN_REF
		do
			create l_flag

			across <<
				<< "-flag" >>, << "-flag=True" >>, << "-flag", "True" >>
			>> as array loop
				l_flag.set_item (False)
				argument_array := array.item
				make_routine := agent make_boolean (False, l_flag)

				if attached new_argument (make_routine, "flag", argument_array) as argument then
					argument.try_put_argument
					make_routine.apply
					assert ("set true", l_flag.item)
				end
			end
		end

	test_string_list_operand_setter
		note
			testing: "[
				covers/{EL_COMMAND_ARGUMENT}.try_put_argument,
				covers/{EL_MAKE_OPERAND_SETTER}.try_put_operand,
				covers/{EL_COMMAND_LINE_ARGUMENTS}.make
			]"
		local
			currency_list, make_operand: EL_STRING_8_LIST; argument_array: ARRAY [STRING]
			make_routine: PROCEDURE; euro_usd: STRING
		do
			euro_usd := "EUR, USD"
			currency_list := euro_usd
			create make_operand.make_empty

			across <<
				<< "-currencies", currency_list [1], currency_list [2] >>,
				<< "-currencies=" + euro_usd >>
			>> as array loop
				argument_array := array.item
				make_operand.wipe_out
				make_routine := agent make_string_list (make_operand)
				if attached new_argument (make_routine, "currencies", argument_array) as argument then
					argument.try_put_argument
					assert ("same list", currency_list ~ make_operand)
				end
			end
		end

feature {NONE} -- Implementation

	make_boolean (flag: BOOLEAN; flag_out: BOOLEAN_REF)
		do
			flag_out.set_item (flag)
		end

	make_string_list (list: EL_STRING_8_LIST)
		do
		end

	new_argument (make_routine: PROCEDURE; option_name: STRING; argument_array: ARRAY [STRING]): EL_COMMAND_ARGUMENT
		local
			command_line: EL_COMMAND_LINE_ARGUMENTS
		do
			create command_line.make_latin_1 (Args.command_path, argument_array)
			create Result.make (Current, option_name, Empty_string)
			Result.set_command_line (command_line)
			Result.set_operands (Tuple.closed_operands (make_routine), 2)
		end

end