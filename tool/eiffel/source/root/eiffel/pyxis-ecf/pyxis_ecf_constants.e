note
	description: "Pyxis ECF constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-07-06 17:06:29 GMT (Wednesday 6th July 2022)"
	revision: "2"

deferred class
	PYXIS_ECF_CONSTANTS

inherit
	EL_ANY_SHARED

	EL_MODULE_TUPLE

feature {NONE} -- Constants

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

	Name: TUPLE [
		cluster, cluster_tree, condition, configuration_ns, debug_, debugging, disabled,
		file_rule, library, libraries, name,
		platform, platform_list, precompile, setting, settings, sub_clusters, system,
		uuid, variable, warning, warnings, writeable_libraries: STRING
	]
		once
			create Result
			Tuple.fill (Result,
				"cluster, cluster_tree, condition, configuration_ns, debug, debugging, disabled, %
				%file_rule, library, libraries, name, %
				%platform, platform_list, precompile, setting, settings, sub_clusters, system, %
				%uuid, variable, warning, warnings, writeable_libraries"
			)
		ensure
			aligned_correctly: Result.writeable_libraries ~ "writeable_libraries"
		end

	Var: TUPLE [directory, element, name, url, value: STRING]
		once
			create Result
			Tuple.fill (Result, "DIRECTORY, ELEMENT, NAME, URL, VALUE")
		end

end