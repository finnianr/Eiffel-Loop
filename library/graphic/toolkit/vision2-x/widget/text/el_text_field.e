note
	description: "Text field"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-08-17 10:50:35 GMT (Monday 17th August 2020)"
	revision: "8"

class
	EL_TEXT_FIELD

inherit
	EV_TEXT_FIELD
		undefine
			set_text
		redefine
			create_implementation, implementation
		end

	EL_UNDOABLE_TEXT_COMPONENT
		undefine
			copy, is_in_default_state
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
