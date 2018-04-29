note
	description: "Hosted button ID"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-28 18:13:03 GMT (Saturday 28th April 2018)"
	revision: "1"

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
