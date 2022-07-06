note
	description: "Pyxis ECF templates"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-07-06 15:57:17 GMT (Wednesday 6th July 2022)"
	revision: "4"

deferred class
	PYXIS_ECF_TEMPLATES

inherit
	EL_MODULE_TUPLE

feature {NONE} -- Constants

	Name_location_template: EL_TEMPLATE [STRING]
		once
			Result := "[
				name = $NAME; location = $VALUE
			]"
		end

	Name_value_template: EL_TEMPLATE [STRING]
		once
			Result := "[
				name = $NAME; value = $VALUE
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

end