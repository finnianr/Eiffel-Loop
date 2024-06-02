note
	description: "${CLASS_LINK} that represents invalid class name"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-06-01 10:31:40 GMT (Saturday 1st June 2024)"
	revision: "1"

class
	INVALID_CLASS_LINK

inherit
	CLASS_LINK
		rename
			path as Invalid_class_path
		redefine
			is_valid
		end

create
	make

feature -- Status query

	is_valid: BOOLEAN
		do
			Result := False
		end

feature {NONE} -- Constants

	Invalid_class_path: FILE_PATH
		once
			Result := "invalid-class-name"
		end

end