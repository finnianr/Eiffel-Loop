note
	description: "Summary description for {EL_DELETION_COMMAND_I}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-07-01 17:45:16 GMT (Saturday 1st July 2017)"
	revision: "3"

deferred class
	EL_DELETION_COMMAND

feature {NONE} -- Constants

	Var_name_path: ZSTRING
		once
			Result := "target_path"
		end
end
