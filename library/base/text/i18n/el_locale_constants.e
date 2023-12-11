note
	description: "Localization constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-11 11:05:10 GMT (Monday 11th December 2023)"
	revision: "8"

deferred class
	EL_LOCALE_CONSTANTS

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Decimal_point_key: ZSTRING
		once
			Result := "{decimal_point}"
		end

	Empty_substitutions: ARRAY [TUPLE [name: READABLE_STRING_8; value: READABLE_STRING_GENERAL]]
		once
			create Result.make_empty
		end

	Number_suffix: SPECIAL [STRING]
		once
			create Result.make_empty (3)
			Result.extend (":0") -- zero
			Result.extend (":1") -- singular
			Result.extend (":>1") -- plural
		end

	Quantifier_names: ARRAY [STRING]
		once
			Result := << "zero", "singular", "plural" >>
			Result.compare_objects
		end

	Unknown_key_template: ZSTRING
		once
			Result := "+%S+"
		end

	Unknown_quantity_key_template: ZSTRING
		once
			Result := "+%S: %S+"
		end

	Var_quantity: STRING = "QUANTITY"

end