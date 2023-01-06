note
	description: "Traffic analysis configuration"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-06 12:08:14 GMT (Friday 6th January 2023)"
	revision: "7"

class
	EL_TRAFFIC_ANALYSIS_CONFIG

inherit
	EL_REFLECTIVELY_BUILDABLE_FROM_PYXIS
		rename
			field_included as is_any_field,
			make_from_file as make
		end

create
	make

feature -- Access

	archived_web_logs: FILE_PATH

	crawler_substrings: EL_ZSTRING_LIST

	page_list: EL_ZSTRING_LIST

feature {NONE} -- Constants

	Element_node_fields: STRING = "crawler_substrings, page_list"

end