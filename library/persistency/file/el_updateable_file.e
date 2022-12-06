note
	description: "Updateable file"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-06 16:47:14 GMT (Tuesday 6th December 2022)"
	revision: "10"

deferred class
	EL_UPDATEABLE_FILE

inherit
	EL_UPDATEABLE

feature {NONE} -- Initialization

	make (a_path: like path)
		do
			path := a_path
			update
		end

feature -- Access

	modification_time: INTEGER
		do
			if path.exists then
				Result := path.modification_time
			else
				Result := last_modification_time - 100
			end
		end

feature -- Access

	path: FILE_PATH

end