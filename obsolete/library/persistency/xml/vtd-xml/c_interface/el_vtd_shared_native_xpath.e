note
	description: "Shared native VTD xpath"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-11 9:49:35 GMT (Sunday 11th May 2025)"
	revision: "8"

deferred class
	EL_VTD_SHARED_NATIVE_XPATH

inherit
	EL_ANY_SHARED

obsolete
	"Use EL_VTD_SHARED_NATIVE_XPATH_TABLE instead"

feature {NONE} -- Implementation

	native_xpath (xpath: READABLE_STRING_GENERAL): EL_VTD_NATIVE_XPATH_I [COMPARABLE]
		do
			Result := Internal_native_xpath
			if attached {STRING_32} xpath as str_32 then
				Result.share_area (str_32)
			else
				Result.share_area (Buffer.copied_general (xpath))
			end
		end

feature {NONE} -- Constants

	Internal_native_xpath: EL_VTD_NATIVE_XPATH_I [COMPARABLE]
		once
			create {EL_VTD_NATIVE_XPATH_IMP} Result.make_empty
		end

	Buffer: EL_STRING_32_BUFFER
		once
			create Result
		end

end