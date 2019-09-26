note
	description: "Summary description for {EL_DEBIAN_CONSTANTS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_DEBIAN_CONSTANTS

feature {NONE} -- Constants

	Field_package: ZSTRING
		once
			Result := "Package"
		end

	Control: ZSTRING
		once
			Result := "control"
		end
end
