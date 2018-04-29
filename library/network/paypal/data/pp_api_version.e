note
	description: "Paypal API version"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-28 16:31:21 GMT (Saturday 28th April 2018)"
	revision: "1"

class
	PP_API_VERSION

inherit
	PP_CONVERTABLE_TO_PARAMETER_LIST

create
	make, make_default

feature {NONE} -- Initialization

	make (a_version: REAL)
		do
			make_default
			version := a_version.out
			if not version.has ('.') then
				version.append_string_general (".0")
			end
		end

feature -- Access

	version: STRING

end
