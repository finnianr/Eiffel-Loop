note
	description: "Pyxis ECF name constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-07-25 9:33:41 GMT (Monday 25th July 2022)"
	revision: "2"

class
	PYXIS_ECF_NAMES

inherit
	EL_REFLECTIVE_STRING_CONSTANTS
		rename
			foreign_naming as eiffel_naming
		redefine
			default_create
		end

feature {NONE} -- Initialization

	default_create
		do
			Precursor
			excluded_.append_character ('_')
		end

feature -- Access

	library_related: ARRAY [STRING]
		do
			Result := << assertions, class_option, condition, custom, option, renaming >>
		end

	excluded_: STRING
		-- excluded value prefix

feature -- ECF names

	assertions: STRING

	class_option: STRING

	cluster: STRING

	condition: STRING

	custom: STRING

	debug_: STRING

	excluded_value: STRING

	file_rule: STRING

	library: STRING

	location: STRING

	mapping: STRING

	name: STRING

	option: STRING

	platform: STRING

	precompile: STRING

	readonly: STRING

	recursive: STRING

	renaming: STRING

	setting: STRING

	system: STRING

	uuid: STRING

	value: STRING

	variable: STRING

	warning: STRING

feature -- Pyxis ECF names

	cluster_tree: STRING

	configuration_ns: STRING

	debugging: STRING

	disabled: STRING

	library_target: STRING

	libraries: STRING

	platform_list: STRING

	settings: STRING

	sub_clusters: STRING

	unix_externals: STRING

	warnings: STRING

	windows_externals: STRING

	writeable_libraries: STRING
end