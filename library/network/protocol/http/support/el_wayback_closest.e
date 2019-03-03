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
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-03-02 16:13:58 GMT (Saturday 2nd March 2019)"
	revision: "1"

class
	EL_WAYBACK_CLOSEST

inherit
	EL_REFLECTIVELY_SETTABLE
		rename
			field_included as is_any_field,
			export_name as to_camel_case,
			import_name as import_default
		export
			{NONE} all
		end

	EL_SETTABLE_FROM_JSON_STRING
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

end
