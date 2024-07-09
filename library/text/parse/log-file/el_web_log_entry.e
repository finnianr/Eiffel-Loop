note
	description: "Parse Apache or Cherokee web-server log entry"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-09 19:46:22 GMT (Tuesday 9th July 2024)"
	revision: "13"

class
	EL_WEB_LOG_ENTRY

inherit
	ANY

	EL_CHARACTER_32_CONSTANTS

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
						ip_address := part.substring_to (' ')
						index := part.index_of ('[', ip_address.count + 3) + 1
						date := Date_factory.new_date (part.substring (index, index + 10))
						index := index + 12
						time := Time_factory.new_time (part.substring (index, index + 7))
					when 2 then
						http_command := part.substring_to (' ')
						index := part.substring_index (Http_protocol, http_command.count + 1)
						if index.to_boolean then
							request_uri := part.substring (http_command.count + 2, index - 2)
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

	http_command: STRING

	ip_address: STRING

	referer: ZSTRING

	request_uri: ZSTRING

	status_code: NATURAL

	stripped_user_agent: ZSTRING
	 -- lower case `user_agent' stripped of punctuation and version numbers
		do
			Result := stripped_lower (user_agent)
		end

	time: TIME

	user_agent: ZSTRING

feature {NONE} -- Implementation

	stripped_lower (a_name: ZSTRING): ZSTRING
		-- if `a_name' ~ "Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101 Firefox/78.0"
		-- result is "mozilla x11 linux x86_64 rv gecko firefox"
		local
			i: INTEGER; name, part: ZSTRING
		do
			name := a_name.translated (Agent_separators, space * Agent_separators.count)

			create Result.make (name.count - name.occurrences (' ') // 2)
			across name.split (' ') as split loop
				if split.item_count > 0 then
					part := split.item
					if not part.is_natural_64 then
						if Result.count > 0 then
							Result.append_character (' ')
						end
						Result.append (part)
					end
				end
			end
			Result.to_lower
		end

feature {NONE} -- Constants

	Agent_separators: ZSTRING
		once
			Result := ".,;:+()/"
		end

	Date_factory: EL_DATE_TIME_CODE_STRING
		once
			create Result.make ("[0]dd/mmm/yyyy")
		end

	Http_protocol: ZSTRING
		once
			Result := "HTTP/1."
		end

	Quote: CHARACTER_32 = '%"'

	Time_factory: EL_DATE_TIME_CODE_STRING
		once
			create Result.make ("[0]hh:[0]mi:[0]ss")
		end

end