note
	description: "Shared access to routines of class ${EL_ZSTRING_ROUTINES_IMP}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-28 5:59:49 GMT (Sunday 28th April 2024)"
	revision: "17"

deferred class
	EL_MODULE_STRING

inherit
	EL_MODULE

feature {NONE} -- Implementation

	shared_floating (str: ZSTRING): EL_FLOATING_ZSTRING
		do
			Result := Floating_string
			Result.share (str)
		end

feature {NONE} -- Constants

	Floating_string: EL_FLOATING_ZSTRING
		once
			create Result.make_empty
		end

	String: EL_ZSTRING_ROUTINES_IMP
		once
			create Result
		end

end