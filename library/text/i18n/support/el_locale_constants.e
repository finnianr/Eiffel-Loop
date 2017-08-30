note
	description: "Localization constants"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_LOCALE_CONSTANTS

feature {NONE} -- Constants

	Variable_quantity: STRING = "QUANTITY"

	Dot_singular: ZSTRING
		once
			Result := ".singular"
		end

	Dot_plural: ZSTRING
		once
			Result := ".plural"
		end

	Dot_zero: ZSTRING
		once
			Result := ".zero"
		end

	Dot_suffixes: EL_ZSTRING_LIST
		once
			Result := << Dot_zero, Dot_singular, Dot_plural >>
		end

	Unknown_key_template: ZSTRING
		once
			Result := "+%S+"
		end

	Unknown_quantity_key_template: ZSTRING
		once
			Result := "+%S: %S+"
		end

end
