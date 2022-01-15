note
	description: "Vtd shared native xpath"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-15 10:53:14 GMT (Saturday 15th January 2022)"
	revision: "6"

class
	EL_VTD_SHARED_NATIVE_XPATH

feature {NONE} -- Implementation

	native_xpath (xpath: READABLE_STRING_GENERAL): EL_VTD_NATIVE_XPATH_I [ANY]
		do
			Result := Internal_native_xpath
			if attached {STRING_32} xpath as str_32 then
				Result.share_area (str_32)
			else
				Result.share_area (Buffer.copied_general (xpath))
			end
		end

feature {NONE} -- Constants

	Internal_native_xpath: EL_VTD_NATIVE_XPATH_I [ANY]
		once
			create {EL_VTD_NATIVE_XPATH_IMP} Result.make_empty
		end

	Buffer: EL_STRING_32_BUFFER
		once
			create Result
		end

end