note
	description: "Traffic analysis configuration"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-10-12 15:54:33 GMT (Tuesday 12th October 2021)"
	revision: "2"

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