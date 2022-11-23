note
	description: "Compile CSV spreadsheet of historical currency exchange rates for multiple currencies"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-23 18:25:37 GMT (Wednesday 23rd November 2022)"
	revision: "12"

class
	CURRENCY_EXCHANGE_HISTORY_COMMAND

inherit
	EL_APPLICATION_COMMAND

	EL_MODULE_FILE; EL_MODULE_LOG

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make (a_output_path: FILE_PATH; a_year: INTEGER; a_currency_list: EL_STRING_8_LIST)
		do
			output_path := a_output_path; year := a_year; currency_list  := a_currency_list
		end

feature -- Constants

	Description: STRING = "Compile CSV spreadsheet of historical currency exchange rates"

feature -- Basic operations

	execute
		local
			url: ZSTRING; page_file: EL_CACHED_HTTP_FILE
			split_list: EL_SPLIT_ON_STRING [STRING]; currency_equals: STRING
			index: INTEGER
		do
			across currency_list as currency loop
				currency_equals := currency.item + " ="
				url := Url_template #$ [currency.item, year]
				create page_file.make (url, 10_000)
				across page_file.string_8_lines as line loop
					if line.item.has_substring (Delimiter) then
						create split_list.make_adjusted (line.item, Delimiter, 0)
						across split_list as list loop
							if attached list.item as str then
								index := str.substring_index (currency_equals, 1)
								if index > 0 then
									str.remove_head (index - 1)
									lio.put_line (str)
								end
							end
						end
					end
				end
			end
		end

feature {NONE} -- Internal attributes

	currency_list: EL_STRING_8_LIST

	output_path: FILE_PATH

	year: INTEGER

feature {NONE} -- Constants

	Delimiter: STRING = "</a></td></tr>"

	Url_template: ZSTRING
		once
			Result := "https://www.exchangerates.org.uk/%S-EUR-spot-exchange-rates-history-%S.html"
		end

end