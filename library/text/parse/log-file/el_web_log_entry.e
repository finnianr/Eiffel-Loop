note
	description: "Parse Apache or Cherokee web-server log entry"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-10-19 14:05:03 GMT (Thursday 19th October 2023)"
	revision: "11"

class
	EL_WEB_LOG_ENTRY

inherit
	ANY

create
	make

feature {NONE} -- Initialization

	make (line: ZSTRING)
		require
			valid_line: line.occurrences (Quote) = 6
		local
			index: INTEGER; part: ZSTRING
		do
			across line.split (Quote) as list loop
				part := list.item
				inspect list.cursor_index
					when 1 then
						ip_address := part.substring_to (' ', default_pointer)
						index := part.index_of ('[', ip_address.count + 3) + 1
						date := Date_factory.new_date (part.substring (index, index + 10))
						index := index + 12
						time := Time_factory.new_time (part.substring (index, index + 7))
					when 2 then
						http_command := part.substring_to (' ', default_pointer)
						index := part.substring_index (Http_protocol, http_command.count + 1)
						if index.to_boolean then
							request_uri := part.substring (http_command.count + 1, index - 2)
						else
							create request_uri.make_empty
						end
					when 3 then
						part.adjust
						index := part.index_of (' ', 1)
						status_code := part.substring (1, index - 1).to_natural
						byte_count := part.substring_end (index + 1).to_natural
					when 4 then
						referer := part.twin
						if referer.is_character ('-') then
							referer.wipe_out
						end
					when 6 then
						user_agent := part.twin

				else end
			end
		end

feature -- Access

	byte_count: NATURAL

	date: DATE

	time: TIME

	http_command: STRING

	ip_address: STRING

	referer: ZSTRING

	request_uri: ZSTRING

	status_code: NATURAL

	user_agent: ZSTRING

	versionless_user_agent: ZSTRING
	 -- user agent with only alphabetical characters
		do
			Result := alphabetical (user_agent)
		end

feature {NONE} -- Implementation

	alphabetical (name: ZSTRING): ZSTRING
		local
			i: INTEGER
		do
			create Result.make_filled (' ', name.count)
			from i := 1 until i > name.count loop
				if name.is_alpha_item (i) then
					Result.put_z_code (name.z_code (i), i)
				end
				i := i + 1
			end
			Result.adjust
			Result.to_canonically_spaced
		end

feature {NONE} -- Constants

	Http_protocol: ZSTRING
		once
			Result := "HTTP/1."
		end

	Quote: CHARACTER_32 = '%"'

	Date_factory: EL_DATE_TIME_CODE_STRING
		once
			create Result.make ("[0]dd/mmm/yyyy")
		end

	Time_factory: EL_DATE_TIME_CODE_STRING
		once
			create Result.make ("[0]hh:[0]mm:[0]ss")
		end

end