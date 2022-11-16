note
	description: "Localization constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "7"

deferred class
	EL_LOCALE_CONSTANTS

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

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