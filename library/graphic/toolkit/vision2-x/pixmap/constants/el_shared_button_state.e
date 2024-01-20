note
	description: "Shared instance of ${EL_BUTTON_STATE_ENUM}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:25 GMT (Saturday 20th January 2024)"
	revision: "4"

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