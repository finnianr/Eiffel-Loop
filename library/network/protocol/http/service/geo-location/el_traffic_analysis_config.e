note
	description: "Traffic analysis configuration"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-11-16 14:14:50 GMT (Monday 16th November 2020)"
	revision: "1"

class
	EL_TRAFFIC_ANALYSIS_CONFIG

inherit
	EL_REFLECTIVE_BUILDABLE_AND_STORABLE_AS_XML
		export
			{NONE} all
		end

create
	make_from_file

feature -- Access

	crawler_substrings: EL_ZSTRING_LIST

	page_list: EL_ZSTRING_LIST

end