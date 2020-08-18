note
	description: "Text component"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-08-17 10:49:00 GMT (Monday 17th August 2020)"
	revision: "1"

deferred class
	EL_TEXT_COMPONENT

inherit
	EV_TEXT_COMPONENT
		undefine
			set_text
		redefine
			implementation
		end

	EL_TEXTABLE
		undefine
			is_in_default_state
		redefine
			implementation
		end

feature {EV_ANY, EV_ANY_I} -- Implementation

	implementation: EV_TEXT_COMPONENT_I
			-- Responsible for interaction with native graphics
			-- toolkit.

end
