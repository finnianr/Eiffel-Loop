note
	description: "Pyxis ECF constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-07-09 9:39:36 GMT (Saturday 9th July 2022)"
	revision: "3"

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
		assertions, cluster, cluster_tree, condition, configuration_ns, custom, debug_, debugging, disabled,
		file_rule, library, library_target, libraries, mapping, name, option,
		platform, platform_list, precompile, renaming, setting, settings, sub_clusters, system,
		uuid, variable, warning, warnings, writeable_libraries: STRING
	]
		once
			create Result
			Tuple.fill (Result,
				"assertions, cluster, cluster_tree, condition, configuration_ns, custom, debug, debugging, disabled, %
				%file_rule, library, library_target, libraries, mapping, name, option, %
				%platform, platform_list, precompile, renaming, setting, settings, sub_clusters, system, %
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