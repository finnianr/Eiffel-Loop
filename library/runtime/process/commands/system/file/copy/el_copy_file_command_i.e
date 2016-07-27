note
	description: "Summary description for {EL_COPY_FILE_COMMAND_I}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-17 16:01:59 GMT (Friday 17th June 2016)"
	revision: "4"

deferred class
	EL_COPY_FILE_COMMAND_I

inherit
	EL_FILE_RELOCATION_COMMAND_I
		redefine
			source_path
		end

feature -- Access

	source_path: EL_FILE_PATH

feature -- Status query

	is_recursive: BOOLEAN
		-- True if recursive copy
		do
			Result := False
		end
end