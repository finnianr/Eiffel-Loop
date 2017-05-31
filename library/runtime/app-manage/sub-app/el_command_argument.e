note
	description: "Summary description for {EL_COMMAND_ARGUMENT}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-05-30 4:59:20 GMT (Tuesday 30th May 2017)"
	revision: "1"

class
	EL_COMMAND_ARGUMENT

inherit
	EL_MODULE_ARGS

create
	make

feature {NONE} -- Initialization

	make (a_app: like app; a_word_option, a_help_description: ZSTRING)
		do
			app := a_app; word_option := a_word_option; help_description := a_help_description
			build_from_file := agent build
			create validation.make_equal (0)
		end

feature -- Access

	help_description: ZSTRING

	word_option: ZSTRING

	validation: HASH_TABLE [PREDICATE, STRING]

feature -- Status query

	is_required: BOOLEAN
		do
		end

	path_exists: BOOLEAN
		do
		end

feature -- Element change

	set_build_from_file (a_build_from_file: PROCEDURE [EL_FILE_PATH])
		do
			build_from_file := a_build_from_file
		end

feature -- Basic operations

	build (path: EL_FILE_PATH)
		do
		end

	build_operand (i: INTEGER)
		local
			file_path: EL_FILE_PATH
		do
			if Args.has_value (word_option) then
				file_path := Args.value (word_option)
			else
				create file_path
			end
			if is_required and file_path.is_empty then
				app.set_required_argument_error (word_option)

			elseif path_exists then
				if file_path.exists then
					build_from_file (file_path)
				else
					app.set_path_argument_error (word_option, app.English_file, file_path)
				end
			end
		end

	set_boolean_operand (i: INTEGER)
		do
			app.operands.put_boolean (Args.word_option_exists (word_option), i)
		end

	set_file_list_operand (i: INTEGER; arg_file_list: ARRAYED_LIST [EL_FILE_PATH])
		local
			index_first_arg: INTEGER
		do
			index_first_arg := Args.index_of_word_option (word_option) + 1
			if (2 |..| Args.argument_count).has (index_first_arg) then
				Args.remaining_file_paths (index_first_arg).do_all (agent arg_file_list.extend)
				if arg_file_list.is_empty then
					app.set_missing_argument_error (word_option)
				else
					across arg_file_list as l_file_path loop
						if not l_file_path.item.exists then
							app.set_path_argument_error (word_option, app.English_file, l_file_path.item)
						end
					end
				end

			elseif is_required then
				app.set_required_argument_error (word_option)
			end
			app.operands.put_reference (arg_file_list, i)
		end

	set_integer_operand (i: INTEGER)
		do
			if Args.has_integer (word_option) then
				app.operands.put_integer (Args.integer (word_option), i)

			elseif Args.has_value (word_option) then
				app.set_argument_type_error (word_option, app.English_integer)

			elseif is_required then
				app.set_missing_argument_error (word_option)
			end
		end

	set_path_operand (i: INTEGER; a_path: EL_PATH; a_path_type: STRING)
		do
			if Args.has_value (word_option) then
				a_path.set_path (Args.value (word_option))
			end
			if is_required and a_path.is_empty then
				app.set_required_argument_error (word_option)

			elseif path_exists then
				if a_path.exists then
					app.operands.put_reference (a_path, i)
				else
					app.set_path_argument_error (word_option, a_path_type, a_path)
				end
			else
				app.operands.put_reference (a_path, i)
			end
		end

	set_reference_operand (i: INTEGER)
		local
			argument_ref: ANY
		do
			argument_ref := app.operands.reference_item (i)
			if argument_ref.generating_type ~ build_from_file.target.generating_type then
				build_operand (i)

			elseif attached {READABLE_STRING_GENERAL} argument_ref as string_ref then
				set_string_operand (i, string_ref)

			elseif attached {EL_ZSTRING_LIST} argument_ref as string_list then
				set_string_list_operand (i, string_list)

			elseif attached {EL_FILE_PATH} argument_ref as file_path then
				set_path_operand (i, file_path, app.English_file)

			elseif attached {EL_DIR_PATH} argument_ref as directory_path then
				set_path_operand (i, directory_path, app.English_directory)

			elseif attached {ARRAYED_LIST [EL_FILE_PATH]} argument_ref as file_path_list then
				set_file_list_operand (i, file_path_list)

			elseif attached {EL_ZSTRING_HASH_TABLE [ZSTRING]} argument_ref as table then
				set_table_operands (i, table)
			end
		end

	set_string_list_operand (i: INTEGER; arg_string_list: EL_ZSTRING_LIST)
		do
			if Args.has_value (word_option) then
				across Args.value (word_option).split (',') as l_string loop
					l_string.item.left_adjust
					arg_string_list.extend (l_string.item)
				end
				app.operands.put_reference (arg_string_list, i)
			elseif is_required then
				app.set_missing_argument_error (word_option)
			end
		end

	set_string_operand (i: INTEGER; default_arg: READABLE_STRING_GENERAL)
		local
			string: READABLE_STRING_GENERAL; arg: ZSTRING
			found: BOOLEAN
		do
			if Args.has_value (word_option) then
				arg := Args.value (word_option)
				if attached {ZSTRING} default_arg then
					string := arg
				elseif attached {STRING_8} default_arg then
					string := arg.to_string_8
				elseif attached {STRING_32} default_arg then
					string := arg.to_string_32
				end
				across validation as is_valid until app.has_invalid_argument loop
					if is_valid.item.valid_operands ([string]) and then not is_valid.item (string) then
						app.set_invalid_argument_error (word_option, is_valid.key)
					end
				end
				app.operands.put_reference (string, i)
			elseif is_required then
				app.set_missing_argument_error (word_option)
			end
		end

	set_table_operands (i: INTEGER; args_table: EL_ZSTRING_HASH_TABLE [ZSTRING])
		do
			across args_table as table loop
				if Args.has_value (table.key) then
					args_table [table.key] := Args.value (table.key)
				end
			end
			app.operands.put_reference (args_table, i)
		end

feature {NONE} -- Internal attributes

	app: EL_COMMAND_LINE_SUB_APPLICATION [EL_COMMAND]

	build_from_file: PROCEDURE [EL_FILE_PATH]

end
