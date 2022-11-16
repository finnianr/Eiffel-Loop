note
	description: "Shared instance of [$source EL_BUTTON_STATE_ENUM]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "3"

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