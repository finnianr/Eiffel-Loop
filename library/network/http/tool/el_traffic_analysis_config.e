note
	description: "Traffic analysis configuration"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "5"

class
	EL_TRAFFIC_ANALYSIS_CONFIG

inherit
	EL_REFLECTIVELY_BUILDABLE_FROM_PYXIS
		rename
			make_from_file as make
		redefine
			Prune_root_words_count
		end

create
	make

feature -- Access

	archived_web_logs: FILE_PATH

	crawler_substrings: EL_ZSTRING_LIST

	page_list: EL_ZSTRING_LIST

feature {NONE} -- Constants

	Element_node_fields: STRING = "crawler_substrings, page_list"

	Prune_root_words_count: INTEGER = 1
end