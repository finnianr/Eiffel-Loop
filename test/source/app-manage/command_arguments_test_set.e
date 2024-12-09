note
	description: "[
		Test set for ${EL_COMMAND_ARGUMENT}, ${EL_COMMAND_LINE_ARGUMENTS}, and descendants
		of ${EL_MAKE_OPERAND_SETTER}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-11-19 16:42:46 GMT (Tuesday 19th November 2024)"
	revision: "6"

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

	EL_ZSTRING_CONSTANTS; EL_CHARACTER_8_CONSTANTS

create
	make


feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["boolean_operand_setter",					 agent test_boolean_operand_setter],
				["buildable_operand_setter",				 agent test_buildable_operand_setter],
				["integer_operand_setter",					 agent test_integer_operand_setter],
				["makeable_from_string_operand_setter", agent test_makeable_from_string_operand_setter],
				["path_operand_setter",						 agent test_path_operand_setter],
				["string_list_operand_setter",			 agent test_string_list_operand_setter],
				["table_operand_setter",					 agent test_table_operand_setter]
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
			variation_list: like command_array_list
		do
			create l_flag
			variation_list := command_array_list ("flag", "True")
			variation_list.put_front (<< "-flag" >>)

			across variation_list as list loop
				l_flag.set_item (False)
				if attached list.item as argument_array then
					make_routine := agent make_boolean (False, l_flag)

					if attached new_argument (make_routine, "flag", argument_array) as argument then
						argument.try_put_argument
						make_routine.apply
						assert ("is true", l_flag.item)
					end
				end
			end
		end

	test_buildable_operand_setter
		note
			testing: "[
				covers/{EL_COMMAND_ARGUMENT}.try_put_argument,
				covers/{EL_BUILDABLE_FROM_FILE_OPERAND_SETTER}.build_object,
				covers/{EL_COMMAND_LINE_ARGUMENTS}.make
			]"
		local
			make_routine: PROCEDURE; bioinfo: BIOINFORMATIC_COMMANDS
		do
			across command_array_list ("xml_path", "data/vtd-xml/bioinfo.xml") as list loop
				if attached list.item as argument_array then
					create bioinfo.make
					make_routine := agent make_buildable (bioinfo)
					if attached new_argument (make_routine, "xml_path", argument_array) as argument then
						argument.try_put_argument
					end
					assert ("6 commands", bioinfo.commands.count = 6)
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

			across command_array_list ("integer", "10") as list loop
				l_integer.set_item (0)
				if attached list.item as argument_array then
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

			across command_array_list ("encoding", "ISO-8859-1") as list loop
				encoding.set_utf (8)
				if attached list.item as argument_array then
					make_routine := agent make_encoding (encoding)

					if attached new_argument (make_routine, "encoding", argument_array) as argument then
						argument.try_put_argument
						assert ("is Latin-1", encoding.code = {EL_ENCODING_TYPE}.Latin_1 )
					end
				end
			end
		end

	test_path_operand_setter
		note
			testing: "[
				covers/{EL_COMMAND_ARGUMENT}.try_put_argument,
				covers/{EL_MAKE_OPERAND_SETTER}.try_put_operand,
				covers/{EL_PATH_OPERAND_SETTER}.value,
				covers/{EL_COMMAND_LINE_ARGUMENTS}.make
			]"
		local
			make_routine: PROCEDURE; file_path_out: FILE_PATH
		do
			create file_path_out
			across command_array_list ("file", "$EIFFEL_LOOP/test/data/txt/file.txt") as list loop
				if attached list.item as argument_array then
					make_routine := agent make_path (create {FILE_PATH}, file_path_out)

					if attached new_argument (make_routine, "file", argument_array) as argument then
						argument.try_put_argument
						make_routine.apply
						assert ("exists", file_path_out.exists)
						assert ("same base name", file_path_out.same_base ("file.txt"))
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
			variation_list: like command_array_list
		do
			euro_usd := "EUR, USD"
			currency_list := euro_usd
			create make_operand.make_empty

			variation_list := command_array_list ("currencies", euro_usd)
			variation_list.finish
			variation_list.replace (<< variation_list.last [1], currency_list [1], currency_list [2] >>)

			across variation_list as list loop
				if attached list.item as argument_array then
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
			variation_list: like command_array_list
		do
			create table.make (3)
			create variation_list.make_from_array (<<
				 << "-a=1", "-b=2" >>,
				 << "-a", "1", "-b" , "2" >>
			>>)
			across variation_list as list loop
				table ["a"] := 0; table ["b"] := 0
				if attached list.item as argument_array then
					make_routine := agent make_string_table (table)
					if attached new_argument (make_routine, "any", argument_array) as argument then
						argument.try_put_argument
					end
					across << "a", "b" >> as key loop
						assert ("same value", table [key.item] = key.cursor_index)
					end
				end
			end
		end

feature {NONE} -- Faux make routines

	make_boolean (flag: BOOLEAN; flag_out: BOOLEAN_REF)
		do
			flag_out.set_item (flag)
		end

	make_buildable (bioinfo: BIOINFORMATIC_COMMANDS)
		do
		end

	make_encoding (encoding: EL_ENCODING)
		do
		end

	make_integer (integer: INTEGER; integer_out: INTEGER_32_REF)
		do
			integer_out.set_item (integer)
		end

	make_path (file_path, file_path_out: FILE_PATH)
		do
			file_path_out.copy (file_path)
		end

	make_string_list (list: EL_STRING_8_LIST)
		do
		end

	make_string_table (table: EL_HASH_TABLE [INTEGER, STRING])
		do
		end

feature {NONE} -- Implementation

	command_array_list (name, value: STRING): EL_ARRAYED_LIST [ARRAY [STRING]]
		-- Two variations of command line array with `name' and `value' pair
		-- For example:

		--		1. << "-encoding=ISO-8859-1" >>
		--		2. << "-encoding", "ISO-8859-1" >>
		local
			option: STRING
		do
			create Result.make (2)
			option := hyphen + name
			Result.extend (<< char ('=').joined (option, value) >>)
			Result.extend (<< option, value >>)
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