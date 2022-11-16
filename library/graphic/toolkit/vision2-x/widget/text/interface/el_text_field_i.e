note
	description: "Text field i"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "7"

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