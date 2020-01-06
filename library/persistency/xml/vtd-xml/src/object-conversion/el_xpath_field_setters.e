note
	description: "agent field setter instances"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-11 18:42:24 GMT (Wednesday 11th September 2019)"
	revision: "2"

class
	EL_XPATH_FIELD_SETTERS

feature {NONE} -- Field setters

	Setter_boolean: EL_XPATH_BOOLEAN_SETTER
		once
			create Result
		end

	Setter_double: EL_XPATH_DOUBLE_SETTER
		once
			create Result
		end

	Setter_integer: EL_XPATH_INTEGER_SETTER
		once
			create Result
		end

	Setter_integer_64: EL_XPATH_INTEGER_64_SETTER
		once
			create Result
		end

	Setter_natural: EL_XPATH_NATURAL_SETTER
		once
			create Result
		end

	Setter_natural_64: EL_XPATH_NATURAL_64_SETTER
		once
			create Result
		end

	Setter_real: EL_XPATH_REAL_SETTER
		once
			create Result
		end

	Setter_string: EL_XPATH_ZSTRING_SETTER
		once
			create Result
		end

	Setter_string_8: EL_XPATH_STRING_8_SETTER
		once
			create Result
		end

	Setter_string_32: EL_XPATH_STRING_32_SETTER
		once
			create Result
		end

	Setter_string_general: EL_XPATH_STRING_GENERAL_SETTER
		once
			create Result
		end

end
