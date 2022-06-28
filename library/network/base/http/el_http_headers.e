note
	description: "Http headers"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-25 10:59:16 GMT (Saturday 25th June 2022)"
	revision: "18"

class
	EL_HTTP_HEADERS

inherit
	EL_REFLECTIVELY_SETTABLE
		rename
			field_included as is_any_field,
			foreign_naming as Http_header_naming
		redefine
			make_default
		end

	EL_SETTABLE_FROM_STRING_8
		redefine
			set_table_field
		end

	EL_STRING_8_CONSTANTS

create
	make, make_default

feature {NONE} -- Initialization

	make (string: STRING)
		local
			lines, parts: EL_SPLIT_ON_CHARACTER [STRING_8]
			part_count: INTEGER
		do
			make_default
			create lines.make (string, '%N')
			across lines as line loop
				if line.item_starts_with (Http) then
					create parts.make (line.item, ' ')
					part_count := 0
					across parts as p loop
						part_count := part_count + 1
						if part_count = 2 then
							response_code := p.item.to_integer
						end
					end
				elseif line.item_has (':') then
					set_field_from_nvp (line.item, ':')
				end
			end
		end

	make_default
		do
			Precursor
			create non_standard_table.make_equal (0)
			create name_value.make_empty
		end

feature -- Header fields

	access_control_allow_origin: STRING

	accept_ranges: STRING

	age: INTEGER

	alt_svc: STRING

	cache_control: STRING

	connection: STRING

	content_length: INTEGER

	content_type: STRING

	date: STRING

	etag: STRING

	host_header: STRING

	keep_alive: STRING

	last_modified: STRING

	link: STRING

	location: STRING

	memento_datetime: STRING

	permissions_policy: STRING

	referrer_policy: STRING

	server: STRING

	set_cookie: STRING

	strict_transport_security: STRING

	upgrade: STRING

	vary: STRING

feature -- Access

	date_stamp: DATE_TIME
		do
			if date.count > 0 and then Date_time_format.is_date_time (date) then
				-- "Sat, 14 Aug 2021 14:57:04 GMT"
				Result := Date_time_format.new_date_time (date)
			end
		end

	encoding_name: STRING
		local
			part: STRING; s: EL_STRING_8_ROUTINES
		do
			if content_type.has (';') then
				part := s.substring_to_reversed (content_type, ';', Default_pointer)
				if part.has ('=') then
					name_value.set_from_string (part, '=')
					Result := name_value.value
				else
					create Result.make_empty
				end
			else
				create Result.make_empty
			end
		end

	mime_type: STRING
		local
			s: EL_STRING_8_ROUTINES
		do
			Result := s.substring_to (content_type, ';', Default_pointer)
		end

	response_code: INTEGER

	x_field (name: STRING): STRING
		do
			if non_standard_table.has (name) then
				Result := non_standard_table.found_item
			else
				create Result.make_empty
			end
		end

feature {NONE} -- Implementation

	set_table_field (table: like field_table; name: STRING; value: STRING)
		-- set field with name
		do
			Precursor (table, name, value)
			if not table.found and then attached Http_header_naming.imported (name) as l_name then
				if l_name.starts_with (once "x_") then
					non_standard_table.put (value, l_name.substring (3, name.count))
				else
					non_standard_table.put (value, l_name)
				end
			end
		end

feature {NONE} -- Internal attributes

	name_value: EL_NAME_VALUE_PAIR [STRING]

	non_standard_table: HASH_TABLE [STRING, STRING]
		-- fields starting with "x-"

feature {NONE} -- Constants

	Date_time_format: EL_ZONED_DATE_TIME_CODE_STRING
		-- -- "Sat, 14 Aug 2021 14:57:04 GMT"
		once
			create Result.make ("Ddd, dd mmm yyyy hh:[0]mi:[0]ss tzd", 1)
		end

	Http_header_naming: EL_HTTP_HEADER_NAME_TRANSLATER
		once
			create Result.make
		end

	HTTP: STRING = "HTTP"

end