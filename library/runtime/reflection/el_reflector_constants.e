note
	description: "Summary description for {EL_REFLECTOR_CONSTANTS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_REFLECTOR_CONSTANTS

inherit
	REFLECTOR_CONSTANTS
		export
			{NONE} all
		end

feature {NONE} -- Constants

	Astring_type: INTEGER
		once
			Result := ({ASTRING}).type_id
		end

	String_8_type: INTEGER
		once
			Result := ({STRING}).type_id
		end

	String_32_type: INTEGER
		once
			Result := ({STRING_32}).type_id
		end

	Once_current_object: REFLECTED_REFERENCE_OBJECT
		once
			create Result.make (Current)
		end
end
