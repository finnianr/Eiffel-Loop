note
	description: "Hosted button ID"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-06 11:04:41 GMT (Wednesday 6th December 2023)"
	revision: "3"

class
	PP_HOSTED_BUTTON

inherit
	PP_REFLECTIVELY_CONVERTIBLE_TO_HTTP_PARAMETER

create
	make, make_default

feature {NONE} -- Initialization

	make (id: STRING)
		do
			make_default
			hosted_button_id := id
		end

feature -- Access

	hosted_button_id: STRING

end