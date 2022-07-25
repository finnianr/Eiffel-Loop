note
	description: "Pyxis ECF constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-07-25 6:03:58 GMT (Monday 25th July 2022)"
	revision: "8"

deferred class
	PYXIS_ECF_CONSTANTS

inherit
	EL_ANY_SHARED

	EL_MODULE_TUPLE

feature {NONE} -- Constants

	C_attributes: ARRAY [STRING]
		once
			Result := << "value", "location" >>
		end

	Custom_template: EL_TEMPLATE [STRING]
		once
			Result := "[
				custom:
					name = $NAME; ${EXCLUDED_PREFIX}value = $VALUE
			]"
		end

	Element_template: EL_TEMPLATE [STRING]
		once
			Result := "[
				$ELEMENT:
					${EXCLUDED_PREFIX}value = $VALUE
			]"
		end

	Externals_set: EL_HASH_SET [STRING]
		once
			create Result.make_from_array (<< Name.unix_externals, Name.windows_externals >>)
		end

	File_rule_template: EL_TEMPLATE [STRING]
		once
			Result := "[
				file_rule:
					exclude:
						"/$DIRECTORY%$"
					condition:
						platform:
							value = $VALUE
			]"
		end

	Name: PYXIS_ECF_NAMES
		once
			create Result
		end

	Var: TUPLE [directory, element, excluded_prefix, name, url, value: STRING]
		once
			create Result
			Tuple.fill (Result, "DIRECTORY, ELEMENT, EXCLUDED_PREFIX, NAME, URL, VALUE")
		end

end