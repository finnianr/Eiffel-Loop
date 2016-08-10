note
	description: "Summary description for {EL_EIFFEL_SOURCE_EDITOR}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-08-04 7:45:38 GMT (Thursday 4th August 2016)"
	revision: "1"

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
