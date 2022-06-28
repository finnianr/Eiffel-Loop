note
	description: "Web log entry"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-05 15:06:32 GMT (Sunday 5th June 2022)"
	revision: "6"

class
	EL_WEB_LOG_ENTRY

inherit
	ANY

	EL_MODULE_IP_ADDRESS
		rename
			ip_address as Mod_ip_address
		end

create
	make

feature {NONE} -- Initialization

	make (line: ZSTRING)
		require
			valid_line: line.occurrences (Quote) = 6
		local
			list: like Split_list; index: INTEGER; address: STRING
		do
			list := Split_list
			list.wipe_out
			list.append_split (line, Quote, {EL_STRING_ADJUST}.None)
			from list.start until list.after loop
				inspect list.index
					when 1 then
						address := list.item.substring (1, list.item.index_of (' ', 1) - 1)
						ip_address := Mod_ip_address.to_number (address)
						index := list.item.index_of ('[', address.count + 3) + 1
						date := Date_factory.create_date (list.item.substring (index, index + 10))
						index := index + 12
						time := Time_factory.create_time (list.item.substring (index, index + 7))
					when 2 then
						http_command := list.item.substring (1, list.item.index_of (' ', 1))
						index := list.item.substring_index (Http_protocol, http_command.count + 1)
						request_uri := list.item.substring (http_command.count + 1, index - 2)
					when 3 then
						list.item.adjust
						index := list.item.index_of (' ', 1)
						status_code := list.item.substring (1, index - 1).to_natural
						byte_count := list.item.substring_end (index + 1).to_natural
					when 4 then
						referer := list.item
						if referer.count = 1 and referer [1] = '-' then
							referer.wipe_out
						end
					when 6 then
						user_agent := list.item

				else end
				list.forth
			end
		end

feature -- Access

	byte_count: NATURAL

	date: DATE

	time: TIME

	http_command: STRING

	ip_address: NATURAL

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

	Split_list: EL_ZSTRING_LIST
		once
			create Result.make_empty
		end

	Date_factory: DATE_TIME_CODE_STRING
		once
			create Result.make ("[0]dd/mmm/yyyy")
		end

	Time_factory: DATE_TIME_CODE_STRING
		once
			create Result.make ("[0]hh:[0]mm:[0]ss")
		end

end