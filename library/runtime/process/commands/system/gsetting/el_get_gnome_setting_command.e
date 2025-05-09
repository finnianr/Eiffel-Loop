note
	description: "Get gnome setting command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-09 10:01:32 GMT (Friday 9th May 2025)"
	revision: "15"

class
	EL_GET_GNOME_SETTING_COMMAND

inherit
	EL_PARSED_CAPTURED_OS_COMMAND [TUPLE [schema, key: STRING]]
		rename
			make as make_parsed
		redefine
			default_template
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

feature -- Setting values

	dir_path (key_name: STRING): DIR_PATH
		local
			uri_path: EL_DIR_URI_PATH
		do
			create uri_path.make (string_value (key_name))
			Result := uri_path.to_dir_path
		end

	dir_uri_path (key_name: STRING): EL_DIR_URI_PATH
		do
			create Result.make (string_value (key_name))
		end

	file_path (key_name: STRING): FILE_PATH
		local
			uri_path: EL_FILE_URI_PATH
		do
			create uri_path.make (string_value (key_name))
			Result := uri_path.to_file_path
		end

	file_uri_path (key_name: STRING): EL_FILE_URI_PATH
		do
			create Result.make (string_value (key_name))
		end

	string_value (key_name: STRING): ZSTRING
		do
			put_string (Var.key, key_name)
			execute
			if lines.count > 0 and then attached lines.first as line then
				if line.occurrences (Single_qmark) = 2 then
					Result := line.substring_between_characters (Single_qmark, Single_qmark, 1)
				else
					Result := line
				end
			else
				create Result.make_empty
			end
		end

feature {NONE} -- Constants

	Default_template: STRING
		once
			Result := Gsettings + " get $schema $key"
		end

	Single_qmark: CHARACTER_32 = '%''

end