note
	description: "Summary description for {EL_TEXT_FIELD}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:31 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_TEXT_FIELD

inherit
	EV_TEXT_FIELD
		redefine
			initialize
		end

	EL_UNDOABLE_TEXT
		rename
			make as make_undoable
		undefine
			default_create, copy
		end

create
	default_create

feature {NONE} -- Initialization

	initialize
		do
			Precursor
			make_undoable
		end

end
