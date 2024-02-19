note
	description: "Hosted button ID"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-02-19 9:07:33 GMT (Monday 19th February 2024)"
	revision: "4"

class
	PP_HOSTED_BUTTON

inherit
	PP_REFLECTIVELY_CONVERTIBLE_TO_HTTP_PARAMETER

create
	make, make_default

feature {NONE} -- Initialization

	make (button_id: STRING)
		do
			make_default
			hosted_button_id := button_id
		end

feature -- Access

	id: STRING
		do
			Result := hosted_button_id
		end

feature {NONE} -- Paypal API name

	hosted_button_id: STRING

end