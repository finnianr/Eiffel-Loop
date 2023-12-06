note
	description: "Paypal API version"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-06 11:04:41 GMT (Wednesday 6th December 2023)"
	revision: "4"

class
	PP_API_VERSION

inherit
	PP_REFLECTIVELY_CONVERTIBLE_TO_HTTP_PARAMETER

create
	make, make_default

feature {NONE} -- Initialization

	make (a_version: STRING)
		do
			make_default
			version := a_version
			if not version.has ('.') then
				version.append_string_general (".0")
			end
		end

feature -- Access

	version: STRING

end