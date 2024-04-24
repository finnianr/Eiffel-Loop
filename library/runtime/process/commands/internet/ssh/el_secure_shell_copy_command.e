note
	description: "${EL_SECURE_SHELL_COMMAND} to copy files from a source path to a destination directory"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-24 7:54:00 GMT (Wednesday 24th April 2024)"
	revision: "1"

deferred class
	EL_SECURE_SHELL_COPY_COMMAND

inherit
	EL_SECURE_SHELL_COMMAND

feature -- Access

	destination_dir: DIR_PATH

feature -- Element change

	set_destination_dir (a_destination_dir: DIR_PATH)
		do
			destination_dir := a_destination_dir
			if attached var_destination_dir as name and then name.count > 0 then
				put_remote_path (name, a_destination_dir)
			end
		end

	set_source_path (source_path: EL_PATH)
		do
			if attached var_source_path as name and then name.count > 0 then
				put_path (name, source_path)
			end
		end

feature {NONE} -- Deferred

	put_path (variable_name: READABLE_STRING_8; a_path: EL_PATH)
		deferred
		end

	var_destination_dir: STRING
		deferred
		end

	var_source_path: STRING
		deferred
		end

end