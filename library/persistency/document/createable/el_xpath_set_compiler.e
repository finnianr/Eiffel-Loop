note
	description: "[
		Compiles a set of all unique xpaths during document scan
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-13 19:08:12 GMT (Friday 13th September 2024)"
	revision: "2"

deferred class
	EL_XPATH_SET_COMPILER

inherit
	EL_CREATEABLE_FROM_NODE_SCAN
		export
			{NONE} all
			{ANY} build_from_stream, build_from_string, build_from_lines, build_from_file,
					set_parser_type, generator
		end

feature {NONE} -- Initialization

	make_default
			--
		do
			create xpath_set.make_equal (72)
		end

feature -- Access

	xpath_set: EL_HASH_SET [STRING]

	sorted_xpath_set: EL_SORTABLE_ARRAYED_LIST [STRING]
		do
			create Result.make_from (xpath_set)
			Result.ascending_sort
		end

feature {NONE} -- Factory

	new_node_source: EL_XPATH_SET_SCAN_SOURCE
			--
		do
			create Result.make (parse_event_source_type)
			Result.set_xpath_set (xpath_set)
		end

end