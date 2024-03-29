note
	description: "Exchange rate table for Euros using European Central Bank rates"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-09-07 12:19:07 GMT (Thursday 7th September 2023)"
	revision: "18"

class
	EL_EURO_EXCHANGE_RATE_TABLE

inherit
	EL_EXCHANGE_RATE_TABLE
		redefine
			fill
		end

	EL_MODULE_FILE_SYSTEM; EL_MODULE_FILE

create
	make

feature -- Access

	euro_unit_value (a_currency_code: NATURAL_8): REAL
		-- value of 1 unit of currency in euros
		do
			search (a_currency_code)
			if found then
				Result := 1 / found_item
			end
		end

feature {NONE} -- Implementation

	clean_up_files
		-- delete older files leaving 5 newest
		do
			across cached_dates as l_date loop
				if l_date.cursor_index > 5 then
					File_system.remove_file (rates_file_path (l_date.item))
				end
			end
		end

	fill
		local
			web: EL_HTTP_CONNECTION; file_path: FILE_PATH; xml, code_name: STRING
			xdoc: EL_XML_DOC_CONTEXT; xml_file: PLAIN_TEXT_FILE
			cached: like cached_dates
		do
			File_system.make_directory (Rates_dir)
			file_path := rates_file_path (date)
			create xml.make_empty
			cached := cached_dates
			if cached.has (date) then
				xml := read_xml (file_path)
			end
			if not xml.has_substring (Closing_tag) then
				lio.put_labeled_string ("Reading", Ecb_daily_rate_url)
				lio.put_new_line
				create web.make
				web.open (ECB_daily_rate_url)
				web.set_timeout_seconds (3)
				web.read_string_get
				if not web.has_error then
					xml := web.last_string
					create xml_file.make_open_write (file_path)
					xml_file.put_string (xml)
					xml_file.close
				end
				web.close
			end
			if not xml.has_substring (Closing_tag) then
				xml := read_xml (rates_file_path (cached.first))
			end
			if xml.has_substring (Closing_tag) then
				create xdoc.make_from_string (xml)
				across xdoc.context_list ("//Cube[boolean(@currency)]") as rate loop
					code_name := rate.node [Name_currency]
					if Currency_enum.has_name (code_name) then
						extend (rate.node [Name_rate], Currency_enum.found_value)
					end
				end
			end
			clean_up_files
		end

	read_xml (file_path: FILE_PATH): STRING
		do
			lio.put_path_field ("Reading", file_path.relative_path (Directory.App_cache))
			lio.put_new_line
			Result := File.plain_text (file_path)
		end

	rates_file_path (a_date: DATE): FILE_PATH
		do
			Result := Rates_dir + a_date.formatted_out (Date_format)
			Result.add_extension (XML_extension)
		end

feature {NONE} -- Constants

	Closing_tag: STRING = "</Cube>"

	Base_currency: NATURAL_8
		once
			Result := Currency_enum.EUR
		end

	ECB_daily_rate_url: ZSTRING
		once
			Result := "https://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml"
		end

	Name_currency: STRING_32 = "currency"

	Name_rate: STRING_32 = "rate"

end