note
	description: "VTD constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-04-21 10:49:22 GMT (Wednesday 21st April 2021)"
	revision: "8"

class
	EL_VTD_CONSTANTS

feature {NONE} -- Constants

	Empty_context_image: EL_VTD_CONTEXT_IMAGE
		once
			create Result.make_empty
		end

	Exception: EL_VTD_EXCEPTION_ENUM
		once
			create Result
		end

	Token: EL_VTD_TOKEN_ENUM
		once
			create Result
		end

end