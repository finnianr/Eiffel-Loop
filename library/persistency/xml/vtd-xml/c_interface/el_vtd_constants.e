note
	description: "VTD constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-25 9:44:24 GMT (Friday 25th February 2022)"
	revision: "9"

deferred class
	EL_VTD_CONSTANTS

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Boolean_values: ARRAY [STRING]
		once
			Result := << "true", "false" >>
			Result.compare_objects
		end

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

	Shared_attribute: EL_ELEMENT_ATTRIBUTE
		once
			create Result.make
		end

end