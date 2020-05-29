note
	description: "Reads private key from X509 .key file"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-28 9:28:18 GMT (Thursday 28th May 2020)"
	revision: "4"

deferred class
	EL_X509_KEY_READER_COMMAND_I

inherit
	EL_FILE_PATH_OPERAND_COMMAND_I
		rename
			file_path as key_file_path,
			set_file_path as set_key_file_path,
			make as make_file_command
		export
			{NONE} all
			{ANY} execute
		undefine
			do_command, new_command_parts
		redefine
			make_default, Var_name_path
		end

	EL_CAPTURED_OS_COMMAND_I
		undefine
			make_default
		redefine
			do_command
		end

	EL_MODULE_EXECUTION_ENVIRONMENT

feature {NONE} -- Initialization

	make_default
			--
		do
			create lines.make (100)
			Precursor {EL_FILE_PATH_OPERAND_COMMAND_I}
		end

	make (a_key_file_path: like key_file_path; a_pass_phrase: like pass_phrase)
		do
			make_file_command (a_key_file_path)
			pass_phrase := a_pass_phrase
		end

feature -- Access

	lines: ARRAYED_LIST [ZSTRING]

feature {NONE} -- Implementation

	do_command (a_system_command: like system_command)
		do
			Execution.put (pass_phrase.to_unicode, Var_pass_phrase)
			Precursor {EL_CAPTURED_OS_COMMAND_I} (a_system_command)
			Execution.put ("none", Var_pass_phrase)
		end

	do_with_lines (a_lines: like adjusted_lines)
			--
		do
			a_lines.do_all (agent lines.extend)
		end

	pass_phrase: ZSTRING

feature {NONE} -- Constants

	Var_pass_phrase: STRING = "OPENSSL_PP"

	Var_name_path: STRING = "key_file_path"
end
