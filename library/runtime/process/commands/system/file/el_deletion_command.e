note
	description: "Deletion command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:50 GMT (Saturday 19th May 2018)"
	revision: "5"

deferred class
	EL_DELETION_COMMAND

feature {NONE} -- Constants

	Var_name_path: ZSTRING
		once
			Result := "target_path"
		end
end
