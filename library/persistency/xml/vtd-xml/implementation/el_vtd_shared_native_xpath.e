note
	description: "Summary description for {EL_VTD_SHARED_NATIVE_XPATH}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-04-18 10:24:01 GMT (Tuesday 18th April 2017)"
	revision: "2"

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
