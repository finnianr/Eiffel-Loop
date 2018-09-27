note
	description: "Eiffel source editor"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:13 GMT (Thursday 20th September 2018)"
	revision: "4"

deferred class
	EL_EIFFEL_SOURCE_EDITOR

inherit
	EL_TEXT_FILE_EDITOR
		redefine
			is_bom_enabled
		end

feature -- Status query

	is_bom_enabled: BOOLEAN
		do
			Result := True
		end
end
