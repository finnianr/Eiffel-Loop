note
	description: "Text field"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-12-21 8:36:17 GMT (Friday 21st December 2018)"
	revision: "6"

class
	EL_TEXT_FIELD

inherit
	EV_TEXT_FIELD
		redefine
			create_implementation, implementation
		end

	EL_UNDOABLE_TEXT
		undefine
			default_create, copy
		redefine
			implementation
		end

create
	default_create

feature {EV_ANY, EV_ANY_I} -- Implementation

	implementation: EL_TEXT_FIELD_I

	create_implementation
			-- See `{EV_ANY}.create_implementation'.
		do
			create {EL_TEXT_FIELD_IMP} implementation.make
		end
end