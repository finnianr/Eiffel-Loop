note
	description: "Summary description for {EL_GNOME_SETTING_COMMAND_CONSTANTS}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-02-09 17:09:45 GMT (Thursday 9th February 2017)"
	revision: "1"

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
