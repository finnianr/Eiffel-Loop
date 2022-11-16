note
	description: "Pyxis ECF constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "10"

deferred class
	PYXIS_ECF_CONSTANTS

inherit
	EL_ANY_SHARED

	EL_MODULE_TUPLE

feature {NONE} -- Constants

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