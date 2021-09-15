note
	description: "Http headers"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-09-15 10:55:07 GMT (Wednesday 15th September 2021)"
	revision: "14"

class
	EL_HTTP_HEADERS

inherit
	EL_REFLECTIVELY_SETTABLE
		rename
			field_included as is_any_field,
			export_name as export_default,
			import_name as from_kebab_case_upper
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
			lines, parts: EL_SPLIT_STRING_8_LIST
			other: STRING
		do
			make_default
			create lines.make_with_character (string, '%N')
			from lines.start until lines.after loop
				if lines.item (False).starts_with (Http) then
					create parts.make_with_character (lines.item (False), ' ')
					if parts.valid_index (2) then
						parts.go_i_th (2)
						response_code := parts.integer_item
					end
				elseif lines.item (False).has (':') then
					set_field_from_nvp (lines.item (False), ':')
				else
					other := lines.item (False)
				end
				lines.forth
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
			part: STRING
		do
			if content_type.has (';') then
				part := string_8.substring_to_reversed (content_type, ';', Default_pointer)
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
			if not table.found and then attached from_kebab_case_upper (name, True) as l_name then
				if l_name.starts_with (once "x_") then
					non_standard_table.put (value, l_name.substring (3, name.count))
				else
					non_standard_table.put (value, l_name)
				end
			end
		end

	string_8: EL_STRING_8_ROUTINES
		do
			-- Expanded type
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

	HTTP: STRING = "HTTP"

end