note
	description: "Gnome setting command constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-10-31 11:45:15 GMT (Wednesday 31st October 2018)"
	revision: "5"

class
	EL_GNOME_SETTING_COMMAND_CONSTANTS

feature {NONE} -- Constants

	Gsettings: STRING = "gsettings"

	Var_schema: STRING = "schema"

	Var_key: STRING = "key"

	Var_value: STRING = "value"

	File_protocol: ZSTRING
		once
			Result := "file://"
		end

end
