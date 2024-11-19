note
	description: "Test set for ${EL_COMMAND_ARGUMENT} and ${EL_COMMAND_LINE_ARGUMENTS}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-11-19 11:00:54 GMT (Tuesday 19th November 2024)"
	revision: "2"

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
				["boolean_operand_setter",					 agent test_boolean_operand_setter],
				["integer_operand_setter",					 agent test_integer_operand_setter],
				["makeable_from_string_operand_setter", agent test_makeable_from_string_operand_setter],
				["table_operand_setter",					 agent test_table_operand_setter],
				["string_list_operand_setter",			 agent test_string_list_operand_setter]
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
			make_routine: PROCEDURE; l_flag: BOOLEAN_REF
		do
			create l_flag

			across <<
				<< "-flag" >>, << "-flag=True" >>, << "-flag", "True" >>
			>> as array loop
				l_flag.set_item (False)
				if attached array.item as argument_array then
					make_routine := agent make_boolean (False, l_flag)

					if attached new_argument (make_routine, "flag", argument_array) as argument then
						argument.try_put_argument
						make_routine.apply
						assert ("is true", l_flag.item)
					end
				end
			end
		end

	test_integer_operand_setter
		note
			testing: "[
				covers/{EL_COMMAND_ARGUMENT}.try_put_argument,
				covers/{EL_MAKE_OPERAND_SETTER}.try_put_operand,
				covers/{EL_OPERAND_SETTER}.value,
				covers/{EL_COMMAND_LINE_ARGUMENTS}.make
			]"
		local
			make_routine: PROCEDURE; l_integer: INTEGER_32_REF
		do
			create l_integer

			across <<
				 << "-integer=10" >>, << "-integer", "10" >>
			>> as array loop
				l_integer.set_item (0)
				if attached array.item as argument_array then
					make_routine := agent make_integer (0, l_integer)

					if attached new_argument (make_routine, "integer", argument_array) as argument then
						argument.try_put_argument
						make_routine.apply
						assert ("equal", l_integer.item = 10)
					end
				end
			end
		end

	test_makeable_from_string_operand_setter
		note
			testing: "[
				covers/{EL_COMMAND_ARGUMENT}.try_put_argument,
				covers/{EL_MAKE_OPERAND_SETTER}.try_put_operand,
				covers/{EL_MAKEABLE_FROM_ZSTRING_OPERAND_SETTER}.put_reference,
				covers/{EL_COMMAND_LINE_ARGUMENTS}.make
			]"
		local
			make_routine: PROCEDURE; encoding: EL_ENCODING
		do
			create encoding.make_default

			across <<
				 << "-encoding=ISO-8859-1" >>, << "-encoding", "ISO-8859-1" >>
			>> as array loop
				encoding.set_utf (8)
				if attached array.item as argument_array then
					make_routine := agent make_encoding (encoding)

					if attached new_argument (make_routine, "encoding", argument_array) as argument then
						argument.try_put_argument
						make_routine.apply
						assert ("is Latin-1", encoding.code = {EL_ENCODING_TYPE}.Latin_1 )
					end
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
			currency_list, make_operand: EL_STRING_8_LIST
			make_routine: PROCEDURE; euro_usd: STRING
		do
			euro_usd := "EUR, USD"
			currency_list := euro_usd
			create make_operand.make_empty

			across <<
				<< "-currencies", currency_list [1], currency_list [2] >>,
				<< "-currencies=" + euro_usd >>
			>> as array loop
				if attached array.item as argument_array then
					make_operand.wipe_out
					make_routine := agent make_string_list (make_operand)
					if attached new_argument (make_routine, "currencies", argument_array) as argument then
						argument.try_put_argument
						assert ("same list", currency_list ~ make_operand)
					end
				end
			end
		end

	test_table_operand_setter
		note
			testing: "[
				covers/{EL_COMMAND_ARGUMENT}.try_put_argument,
				covers/{EL_STRING_TABLE_OPERAND_SETTER}.try_put_operand,
				covers/{EL_COMMAND_LINE_ARGUMENTS}.make
			]"
		local
			make_routine: PROCEDURE; table: EL_HASH_TABLE [INTEGER, STRING]
		do
			create table.make (3)
			across <<
				 << "-a=1", "-b=2" >>, << "-a", "1", "-b" , "2" >>
			>> as array loop
				table ["a"] := 0; table ["b"] := 0
				if attached array.item as argument_array then
					make_routine := agent make_string_table (table)
					if attached new_argument (make_routine, "any", argument_array) as argument then
						argument.try_put_argument
						make_routine.apply
					end
					across << "a", "b" >> as key loop
						assert ("same value", table [key.item] = key.cursor_index)
					end
				end
			end
		end

feature {NONE} -- Implementation

	make_boolean (flag: BOOLEAN; flag_out: BOOLEAN_REF)
		do
			flag_out.set_item (flag)
		end

	make_encoding (encoding: EL_ENCODING)
		do
		end

	make_integer (integer: INTEGER; integer_out: INTEGER_32_REF)
		do
			integer_out.set_item (integer)
		end

	make_string_list (list: EL_STRING_8_LIST)
		do
		end

	make_string_table (table: EL_HASH_TABLE [INTEGER, STRING])
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