note
	description: "Eiffel source editor"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "6"

deferred class
	EL_EIFFEL_SOURCE_EDITOR

inherit
	EL_TEXT_FILE_EDITOR
		rename
			file_path as source_path
		redefine
			is_bom_enabled
		end

feature -- Status query

	is_bom_enabled: BOOLEAN
		do
			Result := True
		end
end