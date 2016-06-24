note
	description: "Summary description for {EL_DOUBLE_OPERAND_FILE_SYSTEM_OS_COMMAND}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "3"

class
	EL_DOUBLE_OPERAND_FILE_SYSTEM_COMMAND [T -> EL_COMMAND_IMPL create default_create end]

inherit
	EL_SINGLE_OPERAND_FILE_SYSTEM_COMMAND [T]
		rename
			path as source_path,
			set_path as set_source_path,
			make as make_source
		redefine
			make_default
		end

	EL_MODULE_PATH

feature {NONE} -- Initialization

	make_default
			--
		do
			make_command
		end

	make (a_source_path, a_destination_path: like source_path)
			--
		do
			make_source (a_source_path)
			set_destination_path (a_destination_path)
		end

feature -- Access

	destination_path: PATH_NAME

feature -- Status query

	is_destination_a_normal_file: BOOLEAN
		-- Default is directory

feature -- Element change

	set_destination_path (a_destination_path: like destination_path)
			--
		do
			destination_path := a_destination_path
			is_destination_a_normal_file := attached {EL_FILE_PATH} destination_path as file_path
		end

	set_file_destination
			--
		do
			is_destination_a_normal_file := true
		end

	set_directory_destination
			--
		do
			is_destination_a_normal_file := false
		end

end
