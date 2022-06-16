note
	description: "Traffic analysis configuration"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-16 10:10:34 GMT (Thursday 16th June 2022)"
	revision: "3"

class
	EL_TRAFFIC_ANALYSIS_CONFIG

inherit
	EL_REFLECTIVE_BUILDABLE_AND_STORABLE_AS_XML
		rename
			xml_naming as eiffel_naming
		export
			{NONE} all
		end

create
	make_from_file

feature -- Access

	crawler_substrings: EL_ZSTRING_LIST

	page_list: EL_ZSTRING_LIST

end