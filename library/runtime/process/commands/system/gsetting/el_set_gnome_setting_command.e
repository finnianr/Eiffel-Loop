note
	description: "Summary description for {EL_SET_GSETTING_COMMAND}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-02-09 17:10:26 GMT (Thursday 9th February 2017)"
	revision: "1"

class
	EL_SET_GNOME_SETTING_COMMAND

inherit
	EL_OS_COMMAND
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
			make_with_name (Gsettings + schema_name, Gsettings + " set $schema $key $value")
			put_string (Var_schema, schema_name)
		end

feature -- Element change

	set_file_path (key_name: STRING; file_path: EL_FILE_PATH)
		do
			put_string (Var_key, key_name)
			put_string (Var_value, File_protocol + file_path.to_string)
			execute
		end

end
