note
	description: "Hosted button ID"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "2"

class
	PP_HOSTED_BUTTON

inherit
	PP_CONVERTABLE_TO_PARAMETER_LIST

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