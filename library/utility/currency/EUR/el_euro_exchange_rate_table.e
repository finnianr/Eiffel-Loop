note
	description: "Exchange rate table for Euros using European Central Bank rates"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_EURO_EXCHANGE_RATE_TABLE

inherit
	EL_EXCHANGE_RATE_TABLE
		redefine
			fill
		end

	EL_MODULE_FILE_SYSTEM
		undefine
			copy, is_equal
		end

	EL_MODULE_DIRECTORY
		undefine
			copy, is_equal
		end

create
	make

feature -- Access

	euro_unit_value (currency_code: STRING): REAL
		-- value of 1 unit of currency in euros
		do
			search (currency_code)
			if found then
				Result := 1 / found_item
			end
		end

feature -- Basic operations

	clean_up_files
		local
			i: INTEGER;l_date: like date; file_path: EL_FILE_PATH
		do
			l_date := date.twin
			l_date.day_back -- Leaves 3 days
			from i := 1 until i > 3 loop
				l_date.day_back
				file_path := rates_file_path (l_date)
				if file_path.exists then
					File_system.remove_file (file_path)
				end
				i := i + 1
			end
		end

feature {NONE} -- Implementation

	fill
		local
			web: EL_HTTP_CONNECTION; file_path: EL_FILE_PATH; xml: STRING
			l_date: DATE; root_node: EL_XPATH_ROOT_NODE_CONTEXT
			xml_file: PLAIN_TEXT_FILE
		do
			create xml.make_empty

			from l_date := date.twin until xml.has_substring ("</Cube>") loop
				file_path := rates_file_path (l_date)
				if file_path.exists then
					lio.put_path_field ("Reading", file_path)
					xml := File_system.plain_text (file_path)
				else
					lio.put_labeled_string ("Reading", Ecb_daily_rate_url)
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
				lio.put_new_line
				l_date.day_back
			end
			create root_node.make_from_string (xml)
			across root_node.context_list ("//Cube[boolean(@currency)]") as rate loop
				extend (rate.node.attributes.real (Name_rate), rate.node.attributes.string_32 (Name_currency))
			end
		end

	rates_file_path (a_date: DATE): EL_FILE_PATH
		do
			Result := Base_file_path.twin
			Result.add_extension (a_date.formatted_out ("yyyy-[0]mm-[0]dd"))
			Result.add_extension ("xml")
		end

feature {NONE} -- Constants

	Base_currency: STRING = "EUR"

	Base_file_path: EL_FILE_PATH
		once
			Result := Directory.user_configuration + "ECB-euro-exchange-rates"
		end

	ECB_daily_rate_url: ZSTRING
		once
			Result := "http://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml"
		end

	Name_currency: STRING_32 = "currency"

	Name_rate: STRING_32 = "rate"

end
