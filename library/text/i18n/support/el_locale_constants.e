note
	description: "Localization constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-02-02 18:56:03 GMT (Saturday 2nd February 2019)"
	revision: "2"

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
