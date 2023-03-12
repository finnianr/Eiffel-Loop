note
	description: "Class to find archive URL in the Wayback Machine"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-12 9:53:20 GMT (Sunday 12th March 2023)"
	revision: "9"

class
	EL_WEB_ARCHIVE_HTTP_CONNECTION

inherit
	EL_HTTP_CONNECTION
		export
			{NONE} all
		end

create
	make

feature -- Access

	wayback (a_url: STRING): EL_WAYBACK_CLOSEST
		local
			json_list: JSON_NAME_VALUE_LIST
		do
			Parameter_table [once "url"] := a_url
			open_with_parameters (Wayback_available_url, Parameter_table)
			read_string_get
			if has_error then
				create Result.make_default
			else
				create json_list.make (last_string)
				json_list.find_field (Param_url)
				if json_list.after then
					create Result.make_default
				else
					json_list.remove -- the first url field because the 2nd is the wayback one
					create Result.make (json_list)
				end
			end
			close
		end

feature -- Status query

	is_wayback_available (a_url: like url): BOOLEAN
			-- `True' is wayback is availabe for `a_url'
		do
			Result := wayback (a_url).available
		end

feature {NONE} -- Implementation

	wayback_json_field (a_url: like url; field_name: ZSTRING): ZSTRING
			-- archived URL of `a_url'. Returns empty string if not found.
		local
			json: ZSTRING
		do
			Parameter_table [Param_url] := a_url
			open_with_parameters (Wayback_available_url, Parameter_table)
			read_string_get
			if has_error then
				create Result.make_empty
			else
				json := last_string
				Result := json.substring_between (Delimiter_template #$ [field_name], Json_comma_delimiter, 1)
			end
			close
		end

feature {NONE} -- Constants

	Delimiter_template: ZSTRING
		once
			Result := "%"%S%":%""
		end

	Json_comma_delimiter: ZSTRING
		once
			Result := ","
			Result.quote (2)
		end

	Parameter_table: HASH_TABLE [STRING, STRING]
		once
			create Result.make (1)
		end

	Param_url: STRING = "url"

	Wayback_available_url: STRING = "http://archive.org/wayback/available"

end