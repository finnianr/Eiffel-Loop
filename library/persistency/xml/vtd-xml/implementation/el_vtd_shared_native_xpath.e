note
	description: "Summary description for {EL_VTD_SHARED_NATIVE_XPATH}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_VTD_SHARED_NATIVE_XPATH

feature {NONE} -- Implementation

	native_xpath (a_xpath: STRING_32): EL_VTD_NATIVE_XPATH
		do
			Result := Internal_native_xpath
			Result.share_area (a_xpath)
		end

feature {NONE} -- Constants

	Internal_native_xpath: EL_VTD_NATIVE_XPATH
		once
			create Result.make
		end

end
