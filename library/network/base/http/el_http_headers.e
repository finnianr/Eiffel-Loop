note
	description: "Http headers"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-08-14 15:10:27 GMT (Saturday 14th August 2021)"
	revision: "10"

class
	EL_HTTP_HEADERS

inherit
	HASH_TABLE [STRING, STRING]
		rename
			make as make_table
		export
			{NONE} all
			{ANY} item
		end

	EL_STATE_MACHINE [STRING]
		rename
			make as make_machine,
			traverse as do_with_lines,
			item_number as line_number
		undefine
			is_equal, copy
		end

	EL_STRING_8_CONSTANTS

create
	make, make_default

feature {NONE} -- Initialization

	make_default
		do
			make_machine
			make_table (0)
			create nvp.make_empty
			setter_table := new_setter_table
			server := Empty_string_8
			encoding_name := Empty_string_8
			content_type := Empty_string_8
			create date_stamp.make_from_epoch (0)
		end

	make (string: STRING)
		local
			lines: LIST [STRING]
		do
			lines := string.split ('%N')
			make_default
			make_equal (lines.count)
			do_with_lines (agent find_response, lines)
		end

feature -- Access

	content_type: STRING

	content_length: INTEGER

	date_stamp: DATE_TIME

	encoding_name: STRING

	response_code: INTEGER

	server: STRING

feature -- Element change

	set_content_type (value: STRING)
		local
			parts: EL_STRING_LIST [STRING]
		do
			if value.has (';') then
				create parts.make_with_separator (value, ';', True)
				if parts.count = 2 then
					content_type := parts [1]
					nvp.set_from_string (parts [2], '=')
					encoding_name := nvp.value
				end
			else
				content_type := value
			end
		end

	set_content_length (value: STRING)
		do
			if value.is_integer then
				content_length := value.to_integer
			end
		end

	set_date_stamp (value: STRING)
		do
			if Date_time_format.is_date_time (value) then
				-- "Sat, 14 Aug 2021 14:57:04 GMT"
				date_stamp := Date_time_format.new_date_time (value)
			end
		end

	set_server (value: STRING)
		do
			server := value
		end

feature {NONE} -- Line states

	find_response (line: STRING)
		local
			parts: LIST [STRING]
		do
			if line.starts_with (HTTP) then
				parts := line.split (' ')
				if parts.count = 3 and then parts.i_th (2).is_integer then
					response_code := parts.i_th (2).to_integer
				end
				state := agent read_name_value_pair
			end
		end

	read_name_value_pair (line: STRING)
		do
			nvp.set_from_string (line, ':')
			if setter_table.has_key (nvp.name) then
				setter_table.found_item (nvp.value)
			else
				put (nvp.value, nvp.name)
				if not inserted then
					item (nvp.name).append_string ("; " + nvp.value)
				end
			end
		end

feature {NONE} -- Implementation

	new_setter_table: EL_HASH_TABLE [PROCEDURE [STRING], STRING]
		do
			create Result.make (<<
				["Server",			agent set_server],
				["Date",				agent set_date_stamp],
				["Content-Type",	agent set_content_type],
				["Content-Length", agent set_content_length]
			>>)
		end

feature {NONE} -- Internal attributes

	nvp: EL_NAME_VALUE_PAIR [STRING]

	setter_table: like new_setter_table

feature {NONE} -- Constants

	Date_time_format: EL_DATE_TIME_CODE_STRING
		-- -- "Sat, 14 Aug 2021 14:57:04 GMT"
		once
			create Result.make ("Ddd, dd mmm yyyy hh:[0]mi:[0]ss tzd")
		end

	HTTP: STRING = "HTTP"

end