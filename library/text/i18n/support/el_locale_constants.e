note
	description: "Localization constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-08-17 8:53:07 GMT (Thursday 17th August 2017)"
	revision: "1"

class
	EL_LOCALE_CONSTANTS

feature {NONE} -- Constants

	Variable_quantity: STRING = "QUANTITY"

	Dot_suffixes: SPECIAL [ZSTRING]
		once
			create Result.make_empty (3)
			Result.extend (".zero")
			Result.extend (".singular")
			Result.extend (".plural")
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
