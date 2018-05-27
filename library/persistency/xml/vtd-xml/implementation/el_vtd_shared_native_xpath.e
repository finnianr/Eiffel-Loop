note
	description: "Vtd shared native xpath"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:49 GMT (Saturday 19th May 2018)"
	revision: "4"

class
	EL_VTD_SHARED_NATIVE_XPATH

feature {NONE} -- Implementation

	native_xpath (xpath: READABLE_STRING_GENERAL): EL_VTD_NATIVE_XPATH_I
		do
			Result := Internal_native_xpath
			Result.share_area (xpath.to_string_32)
		end

feature {NONE} -- Constants

	Internal_native_xpath: EL_VTD_NATIVE_XPATH_I
		once
			create {EL_VTD_NATIVE_XPATH_IMP} Result.make ("")
		end

end
