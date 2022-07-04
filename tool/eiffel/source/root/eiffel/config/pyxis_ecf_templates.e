note
	description: "Pyxis ECF templates"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-07-04 14:49:38 GMT (Monday 4th July 2022)"
	revision: "2"

deferred class
	PYXIS_ECF_TEMPLATES

inherit
	EL_MODULE_TUPLE

feature {NONE} -- Constants

	Cluster_tree_template: EL_TEMPLATE [STRING]
		once
			Result := "[
				cluster:
					name = $NAME; location = $VALUE; recursive = true
			]"
		end

	Library_template: EL_TEMPLATE [STRING]
		once
			Result := "[
				library:
					name = $NAME; location = $VALUE
			]"
		end

	Platform_template: EL_TEMPLATE [STRING]
		once
			Result := "[
				platform:
					value = $VALUE
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

	Setting_template: EL_TEMPLATE [STRING]
		once
			Result := "[
				setting:
					name = $NAME; value = $VALUE
			]"
		end

	Sub_clusters_template: EL_TEMPLATE [STRING]
		once
			Result := "[
				cluster:
					name = $NAME; location = "%$|$VALUE"
			]"
		end

	Option_setting_template: EL_TEMPLATE [STRING]
		once
			Result := "[
				$ELEMENT:
					name = $NAME; enabled = $VALUE
			]"
		end

	Var: TUPLE [directory, element, name, value: STRING]
		once
			create Result
			Tuple.fill (Result, "DIRECTORY, ELEMENT, NAME, VALUE")
		end

	Writeable_library_template: EL_TEMPLATE [STRING]
		once
			Result := "[
				library:
					name = $NAME; location = $VALUE; readonly = false
			]"
		end

	XMS_NS_template: ZSTRING
		once
			Result := "[
				xmlns = "#"; xmlns.xsi = "http://www.w3.org/2001/XMLSchema-instance"; xsi.schemaLocation = "# #.xsd"
			]"
		end
end