note
	description: "[
		An object that maps command line arguments to an Eiffel make procedure for a target object (command).
		The 'command' object is automically created and the make procedure specified by 'make_action'
		is called to intialize it.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-02-21 12:35:52 GMT (Friday 21st February 2014)"
	revision: "4"

deferred class
	EL_COMMAND_LINE_SUB_APPLICATTION [C -> EL_COMMAND create default_create end]

inherit
	EL_SUB_APPLICATION

	EL_MODULE_TYPING

feature {NONE} -- Initiliazation

	initialize
			--
		local
			i: INTEGER; arg_spec: like Type_argument_specification
			l_argument_specs: like argument_specs
			action: like make_action
		do
			create command
			operands := default_operands; l_argument_specs := argument_specs
			from i := 1 until i > operands.count loop
				arg_spec := l_argument_specs [i]
				if operands.is_reference_item (i) then
					set_reference_operand (i, arg_spec, operands.reference_item (i))

				elseif operands.is_integer_32_item (i) then
					set_integer_operand (i, arg_spec)

				elseif operands.is_boolean_item (i) then
					set_boolean_operand (i, arg_spec)

				end
				i := i + 1
			end
			action := make_action
			action.set_operands (operands)
			action.apply
		end

feature -- Basic operations

	run
			--
		do
			command.execute
		end

feature {NONE} -- Argument setting

	set_reference_operand (a_index: INTEGER; arg_spec: like Type_argument_specification; argument_ref: ANY)
		do
			if attached {EL_ASTRING} argument_ref then
				set_string_operand (a_index, arg_spec)

			elseif attached {EL_FILE_PATH} argument_ref as file_path then
				set_path_operand (a_index, arg_spec, file_path, English_file)

			elseif attached {EL_DIR_PATH} argument_ref as directory_path then
				set_path_operand (a_index, arg_spec, directory_path, English_directory)

			elseif attached {ARRAYED_LIST [EL_FILE_PATH]} argument_ref as file_path_list then
				set_file_list_operand (a_index, arg_spec, file_path_list)

			elseif attached {EL_ASTRING_HASH_TABLE [EL_ASTRING]} argument_ref as table then
				set_table_operands (a_index, table)
			end
		end

	set_path_operand (a_index: INTEGER; arg_spec: like Type_argument_specification; a_path: EL_PATH; a_path_type: STRING)
		do
			if Args.argument_exists (arg_spec.word_option) then
				a_path.set_path (Args.word_option_argument (arg_spec.word_option))
			end
			if arg_spec.is_required and a_path.is_empty then
				set_required_argument_error (arg_spec.word_option)

			elseif arg_spec.path_exists then
				if a_path.exists then
					operands.put_reference (a_path, a_index)
				else
					set_path_argument_error (arg_spec.word_option, a_path_type, a_path)
				end
			else
				operands.put_reference (a_path, a_index)
			end
		end

	set_file_list_operand (
		a_index: INTEGER; arg_spec: like Type_argument_specification; arg_file_list: ARRAYED_LIST [EL_FILE_PATH]
	)
		local
			index_first_arg: INTEGER
		do
			index_first_arg := Args.index_of_word_option (arg_spec.word_option) + 1
			if (2 |..| Args.argument_count).has (index_first_arg) then
				Args.remaining_file_paths (index_first_arg).do_all (agent arg_file_list.extend)
				if arg_file_list.is_empty then
					set_missing_argument_error (arg_spec.word_option)
				else
					across arg_file_list as l_file_path loop
						if not l_file_path.item.exists then
							set_path_argument_error (arg_spec.word_option, English_file, l_file_path.item)
						end
					end
				end

			elseif arg_spec.is_required then
				set_required_argument_error (arg_spec.word_option)
			end
			operands.put_reference (arg_file_list, a_index)
		end

	set_string_operand (a_index: INTEGER; arg_spec: like Type_argument_specification)
		local
			l_string_arg: EL_ASTRING; arg_found: BOOLEAN
		do
			if Args.argument_exists (arg_spec.word_option) then
				l_string_arg := Args.word_option_argument (arg_spec.word_option)
				arg_found := True
			end
			if arg_found then
				operands.put_reference (l_string_arg, a_index)

			elseif arg_spec.is_required then
				set_missing_argument_error (arg_spec.word_option)
			end
		end

	set_integer_operand (a_index: INTEGER; arg_spec: like Type_argument_specification)
		local
			l_integer_arg: STRING; arg_found: BOOLEAN
		do
			create l_integer_arg.make_empty
			if Args.argument_exists (arg_spec.word_option) then
				l_integer_arg := Args.word_option_argument (arg_spec.word_option)
				arg_found := True

			end
			if arg_found then
				if l_integer_arg.is_integer then
					operands.put_integer (l_integer_arg.to_integer, a_index)
				else
					set_argument_type_error (arg_spec.word_option, English_integer)
				end

			elseif arg_spec.is_required then
				set_missing_argument_error (arg_spec.word_option)
			end
		end

	set_boolean_operand (a_index: INTEGER; arg_spec: like Type_argument_specification)
		do
			operands.put_boolean (Args.argument_exists (arg_spec.word_option), a_index)
		end

	set_table_operands (a_index: INTEGER; args_table: EL_ASTRING_HASH_TABLE [EL_ASTRING])
		do
			across args_table as table loop
				if Args.argument_exists (table.key) then
					args_table [table.key] := Args.word_option_argument (table.key)
				end
			end
			operands.put_reference (args_table, a_index)
		end

feature {NONE} -- Conversion

	required_existing_path_argument (a_word_option, help_description: EL_ASTRING): like Type_argument_specification
		do
			Result := [a_word_option, help_description, True, True]
		end

	required_argument (a_word_option, help_description: EL_ASTRING): like Type_argument_specification
		do
			Result := [a_word_option, help_description, True, False]
		end

	optional_argument (a_word_option, help_description: EL_ASTRING): like Type_argument_specification
		do
			Result := [a_word_option, help_description, False, False]
		end

feature {NONE} -- Implementation

	make_action: PROCEDURE [EL_COMMAND, TUPLE]
		deferred
		end

	default_operands: TUPLE
			-- default arguments for make action
		deferred
		end

	argument_specs: ARRAY [like Type_argument_specification]
			-- argument specifications
		deferred
		ensure
			valid_count: Result.count <= default_operands.count
		end

	command: C

	operands: TUPLE
		-- make procedure operands

feature {NONE} -- Type definitions

	Type_argument_specification: TUPLE [
		word_option, help_description: EL_ASTRING; is_required, path_exists: BOOLEAN
	]
		require
			never_called: False
		once
		end

end
