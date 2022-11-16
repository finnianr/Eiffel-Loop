note
	description: "VTD constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "11"

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

	Token: EL_VTD_TOKEN_ENUM
		once
			create Result
		end

	Shared_attribute: EL_ELEMENT_ATTRIBUTE
		once
			create Result.make
		end

end