note
	description: "Shared instance of [$source EL_BUTTON_STATE_ENUM]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-08-19 11:49:53 GMT (Wednesday 19th August 2020)"
	revision: "2"

deferred class
	EL_SHARED_BUTTON_STATE

inherit
	EL_ANY_SHARED

feature -- Constants

	Button_state: EL_BUTTON_STATE_ENUM
		once
			create Result.make
		end

end
