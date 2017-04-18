note
	description: "Summary description for {EL_GET_GSETTING_COMMAND}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-02-09 17:10:06 GMT (Thursday 9th February 2017)"
	revision: "1"

class
	EL_GET_GNOME_SETTING_COMMAND

inherit
	EL_CAPTURED_OS_COMMAND
		rename
			make as make_command
		end

	EL_GNOME_SETTING_COMMAND_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make (schema_name: STRING)
			--
		do
			make_with_name (Gsettings + schema_name, Gsettings + " get $schema $key")
			put_string (Var_schema, schema_name)
		end

feature -- Element change

	file_path_setting (key_name: STRING): EL_FILE_PATH
		local
			path: ZSTRING
		do
			put_string (Var_key, key_name)
			execute
			path := lines.first
			path.remove_quotes
			path.remove_head (File_protocol.count)
			Result := path
		end

end
