note
	description: "Gnome setting command constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:15 GMT (Thursday 20th September 2018)"
	revision: "4"

class
	EL_GNOME_SETTING_COMMAND_CONSTANTS

feature {NONE} -- Constants

	Gsettings: STRING = "gsettings"

	Var_schema: ZSTRING
		once
			Result := "schema"
		end

	Var_key: ZSTRING
		once
			Result := "key"
		end

	Var_value: ZSTRING
		once
			Result := "value"
		end

	File_protocol: ZSTRING
		once
			Result := "file://"
		end

end
