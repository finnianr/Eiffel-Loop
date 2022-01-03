note
	description: "Set gnome setting command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-03 15:54:05 GMT (Monday 3rd January 2022)"
	revision: "6"

class
	EL_SET_GNOME_SETTING_COMMAND

inherit
	EL_PARSED_OS_COMMAND [TUPLE [schema, key, value: STRING]]
		rename
			make as make_parsed
		end

	EL_GNOME_SETTING_COMMAND

create
	make

feature {NONE} -- Initialization

	make (a_schema_name: STRING)
			--
		do
			make_parsed
			schema_name := a_schema_name
			set_template_name (a_schema_name)
			put_string (Var.schema, a_schema_name)
		end

feature -- Element change

	set_file_path (key_name: STRING; file_path: FILE_PATH)
		do
			put_string (Var.key, key_name)
			put_string (Var.value, file_path.to_uri)
			execute
		end

feature {NONE} -- Constants

	Template: STRING
		once
			Result := Gsettings + " set $schema $key $value"
		end
end