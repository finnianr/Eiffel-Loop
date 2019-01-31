note
	description: "[
		Support class for [$source EL_SUB_APPLICATION] to set attributes from command line arguments.
		This class has been superceded by the facilities of [$source EL_COMMAND_LINE_SUB_APPLICATION]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-01-25 17:46:37 GMT (Friday 25th January 2019)"
	revision: "3"

deferred class
	EL_ARGUMENT_TO_ATTRIBUTE_SETTING

obsolete
	"Use EL_COMMAND_LINE_SUB_APPLICATION"

inherit
	EL_MODULE_ZSTRING

	EL_MODULE_ARGS

	EL_COMMAND_ARGUMENT_CONSTANTS

feature -- Element change

	set_attribute_from_command_opt (a_attribute: ANY; a_word_option, a_description: READABLE_STRING_GENERAL)
		do
			set_from_command_opt (a_attribute, a_word_option, a_description, False)
		end

	set_from_command_opt (
		a_attribute: ANY; a_word_option, a_description: READABLE_STRING_GENERAL; is_required: BOOLEAN
	)
			-- set class attribute from command line option
		local
			l_argument_index: INTEGER; l_argument: ZSTRING
			argument_error: like new_argument_error
		do
			argument_error := new_argument_error (a_word_option)
			extend_help (a_word_option, a_description, a_attribute)
			if Args.has_value (a_word_option) then
				l_argument_index := Args.index_of_word_option (a_word_option) + 1
				l_argument := Args.item (l_argument_index)

				if attached {ZSTRING} a_attribute as a_string then
					a_string.share (l_argument)

				elseif attached {EL_DIR_PATH} a_attribute as a_dir_path then
					a_dir_path.set_path (l_argument)
					if not a_dir_path.exists then
						argument_errors.extend (argument_error)
						argument_errors.last.set_path_error (Eng_directory, a_dir_path)
					end

				elseif attached {EL_FILE_PATH} a_attribute as a_file_path then
					a_file_path.set_path (l_argument)
					if not a_file_path.exists then
						argument_errors.extend (argument_error)
						argument_errors.last.set_path_error (Eng_file, a_file_path)
					end

				elseif attached {REAL_REF} a_attribute as a_real_value then
					if l_argument.is_real then
						a_real_value.set_item (l_argument.to_real)
					else
						argument_errors.extend (argument_error)
						argument_errors.last.set_type_error ("real number")
					end

				elseif attached {INTEGER_REF} a_attribute as a_integer_value then
					if l_argument.is_integer then
						a_integer_value.set_item (l_argument.to_integer)
					else
						argument_errors.extend (argument_error)
						argument_errors.last.set_type_error ("integer")
					end
				elseif attached {BOOLEAN_REF} a_attribute as a_boolean_value then
					a_boolean_value.set_item (Args.word_option_exists (a_word_option))

				elseif attached {EL_ZSTRING_HASH_TABLE [STRING]} a_attribute as hash_table then
					hash_table [Zstring.new_zstring (a_word_option)] := l_argument
				end
			else
				if is_required then
					argument_errors.extend (argument_error)
					argument_errors.last.set_required_error
				end
			end
		end

	set_required_attribute_from_command_opt (a_attribute: ANY; a_word_option, a_description: READABLE_STRING_GENERAL)
		do
			set_from_command_opt (a_attribute, a_word_option, a_description, True)
		end

feature {NONE} -- Implementation

	argument_errors: ARRAYED_LIST [EL_COMMAND_ARGUMENT_ERROR]
		deferred
		end

	new_argument_error (option: READABLE_STRING_GENERAL): EL_COMMAND_ARGUMENT_ERROR
		deferred
		end

	extend_help (word_option, a_description: READABLE_STRING_GENERAL; default_value: ANY)
		deferred
		end
end
