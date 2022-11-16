note
	description: "[
		Parse "closest" fields from wayback query
		
			http://archive.org/wayback/available?url=<url>
		
			{
			  "url": "http:\/\/www.at-dot-com.com\/iching\/hex06.html",
			  "archived_snapshots": {
			    "closest": {
			      "status": "200",
			      "available": true,
			      "url": "http:\/\/web.archive.org\/web\/20100921094356\/http:\/\/www.at-dot-com.com:80\/iching\/hex06.html",
			      "timestamp": "20100921094356"
			    }
			  }
			}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "7"

class
	EL_WAYBACK_CLOSEST

inherit
	EL_REFLECTIVELY_SETTABLE
		rename
			field_included as is_any_field,
			foreign_naming as Camel_case_lower
		export
			{NONE} all
		end

	JSON_SETTABLE_FROM_STRING
		rename
			make_from_json as make
		export
			{NONE} all
			{ANY} as_json
		end

create
	make, make_default

feature -- Access

	available: BOOLEAN

	status: NATURAL

	timestamp: NATURAL_64

	url: STRING

feature {NONE} -- Constants

	Camel_case_lower: EL_CAMEL_CASE_TRANSLATER
		once
			create Result.make
		end
end