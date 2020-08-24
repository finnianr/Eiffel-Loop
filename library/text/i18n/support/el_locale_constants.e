note
	description: "Localization constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-08-24 11:38:18 GMT (Monday 24th August 2020)"
	revision: "3"

class
	EL_LOCALE_CONSTANTS

feature {NONE} -- Constants

	Variable_quantity: STRING = "QUANTITY"

	Number_suffix: SPECIAL [ZSTRING]
		once
			create Result.make_empty (3)
			Result.extend (":0") -- zero
			Result.extend (":1") -- singular
			Result.extend (":>1") -- plural
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
