note
	description: "Class to find archive URL in the Wayback Machine"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-05-10 10:23:22 GMT (Wednesday 10th May 2017)"
	revision: "1"

class
	EL_WEB_ARCHIVE_HTTP_CONNECTION

inherit
	EL_HTTP_CONNECTION

create
	make

feature -- Access

	wayback_url (a_url: like url): like url
			-- archived URL of `a_url'. Returns empty string if not found.
		do
			Result := wayback_json_field (a_url, Json_url_delimiter)
		end

	wayback_timestamp (a_url: like url): NATURAL_64
			-- archived URL of `a_url'. Returns empty string if not found.
		do
			Result := wayback_json_field (a_url, Json_timestamp_delimiter).to_natural_64
		end

feature {NONE} -- Implementation

	wayback_json_field (a_url: like url; delimiter: ZSTRING): ZSTRING
			-- archived URL of `a_url'. Returns empty string if not found.
		local
			json: ZSTRING
		do
			open (Web_archive_available_query + a_url)
			read_string_get
			if has_error then
				create Result.make_empty
			else
				json := last_string
				Result := json.substring_between (delimiter, Json_comma_delimiter, 1)
			end
			close
		end

feature {NONE} -- Constants

	Json_comma_delimiter: ZSTRING
		once
			Result := "[
				","
			]"
		end

	Json_timestamp_delimiter: ZSTRING
		once
			Result := "[
				"timestamp":"
			]"
		end

	Json_url_delimiter: ZSTRING
		once
			Result := "[
				"url":"
			]"
		end

	Web_archive_available_query: ZSTRING
		once
			Result := "http://archive.org/wayback/available?url="
		end

end
