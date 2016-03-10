note
	description: "Reads private key from X509 .key file"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-19 18:44:18 GMT (Friday 19th September 2014)"
	revision: "4"

class
	EL_X509_KEY_READER_COMMAND

inherit
	EL_SINGLE_OPERAND_FILE_SYSTEM_COMMAND [EL_X509_KEY_READER_COMMAND_IMPL]
		rename
			path as key_file_path,
			set_path as set_key_file_path,
			make as make_file_command
		export
			{NONE} all
			{ANY} execute
		redefine
			make_default, do_command, do_with_lines,
			getter_function_table, Line_processing_enabled, key_file_path
		end

	EL_MODULE_EXECUTION_ENVIRONMENT
		undefine
			default_create
		end
create
	make

feature {NONE} -- Initialization

	make_default
			--
		do
			Precursor
			create lines.make (100)
		end

	make (a_key_file_path: like key_file_path; a_pass_phrase: like pass_phrase)
		do
			make_file_command (a_key_file_path)
			pass_phrase := a_pass_phrase
		end

feature -- Access

	key_file_path: EL_FILE_PATH

	lines: ARRAYED_LIST [ASTRING]

feature {NONE} -- Implementation

	do_command (a_system_command: like system_command)
		do
			Execution.put (pass_phrase.to_unicode, Var_pass_phrase)
			Precursor (a_system_command)
			Execution.put ("none", Var_pass_phrase)
		end

	do_with_lines (a_lines: EL_FILE_LINE_SOURCE)
			--
		do
			a_lines.do_all (agent lines.extend)
		end

	Line_processing_enabled: BOOLEAN = true

	pass_phrase: ASTRING

feature {NONE} -- Evolicity reflection

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["key_file_path", agent: EL_PATH do Result := key_file_path end]
			>>)
		end

feature {NONE} -- Constants

	Var_pass_phrase: STRING = "OPENSSL_PP"

end
