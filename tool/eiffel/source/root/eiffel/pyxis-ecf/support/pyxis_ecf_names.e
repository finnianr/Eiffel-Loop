note
	description: "Pyxis ECF name constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "4"

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
			externals_set := << unix_externals, windows_externals >>
			related_tags := <<
				assertions, debugging, class_option, condition, custom, debug_, debugging, option, renaming, renaming_map
			>>
			C_attributes := << value, location >>
		end

feature -- Access

	C_attributes: ARRAY [STRING]

	externals_set: EL_HASH_SET [STRING]

	related_tags: EL_HASH_SET [STRING]
		-- library group related tags

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

	renaming_map: STRING

	settings: STRING

	sub_clusters: STRING

	unix_externals: STRING

	warnings: STRING

	windows_externals: STRING

	writeable_libraries: STRING
end