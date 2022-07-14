note
	description: "Pyxis ECF constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-07-13 12:33:33 GMT (Wednesday 13th July 2022)"
	revision: "5"

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

	Name: TUPLE [
		assertions, cluster, cluster_tree, condition, configuration_ns, custom, debug_, debugging, disabled,
		file_rule, library, library_target, libraries, mapping, name, option,
		platform, platform_list, precompile, renaming, setting, settings, sub_clusters, system,
		unix_externals, uuid, variable, warning, warnings, windows_externals, writeable_libraries: STRING
	]
		once
			create Result
			Tuple.fill (Result,
				"assertions, cluster, cluster_tree, condition, configuration_ns, custom, debug, debugging, disabled, %
				%file_rule, library, library_target, libraries, mapping, name, option, %
				%platform, platform_list, precompile, renaming, setting, settings, sub_clusters, system, %
				%unix_externals, uuid, variable, warning, warnings, windows_externals, writeable_libraries"
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