note
	description: "Text field i"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-02-04 11:43:48 GMT (Monday 4th February 2019)"
	revision: "6"

deferred class
	EL_TEXT_FIELD_I

inherit
	EV_TEXT_FIELD_I
		redefine
			interface
		end

	EL_UNDOABLE_TEXT_COMPONENT_I
		redefine
			interface
		end

feature {EV_ANY, EV_ANY_I} -- Implementation

	interface: EL_TEXT_FIELD

end
