note
	description: "Wrapper for Unix ''scp'' command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-09-09 15:49:12 GMT (Thursday 9th September 2021)"
	revision: "4"

class
	EL_SECURE_SHELL_COPY_COMMAND

inherit
	EL_PARSED_OS_COMMAND [TUPLE [source_path, user_domain, destination_dir: STRING]]

	EL_SECURE_SHELL_COMMAND
		redefine
			set_user_domain
		end

create
	make

feature -- Access

	destination_dir: EL_DIR_PATH

feature -- Element change

	set_destination_dir (a_destination_dir: EL_DIR_PATH)
		do
			destination_dir := a_destination_dir
			command_template.set_variable (var.destination_dir, escaped_remote (a_destination_dir))
		end

	set_source_path (source_path: EL_FILE_PATH)
		do
			put_path (var.source_path, source_path)
		end

	set_user_domain (a_user_domain: ZSTRING)
		do
			Precursor (a_user_domain)
			put_string (var.user_domain, a_user_domain)
		end

feature {NONE} -- Constants

	Template: STRING = "scp $source_path $user_domain:$destination_dir"
end