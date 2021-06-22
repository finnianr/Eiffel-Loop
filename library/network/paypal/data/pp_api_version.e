note
	description: "Paypal API version"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-06-22 10:59:15 GMT (Tuesday 22nd June 2021)"
	revision: "2"

class
	PP_API_VERSION

inherit
	PP_CONVERTABLE_TO_PARAMETER_LIST

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