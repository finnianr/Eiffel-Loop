note
	description: "agent field setter instances"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-04-19 9:25:29 GMT (Wednesday 19th April 2017)"
	revision: "1"

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

end
