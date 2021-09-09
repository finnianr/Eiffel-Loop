note
	description: "Gnome setting command constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-09-09 16:10:01 GMT (Thursday 9th September 2021)"
	revision: "6"

deferred class
	EL_GNOME_SETTING_COMMAND_CONSTANTS

inherit
	EL_ANY_SHARED

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