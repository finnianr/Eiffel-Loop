note
	description: "Exchange rate table for a `base_currency' based on Euro exchange rates table"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-09 9:59:45 GMT (Monday 9th January 2023)"
	revision: "15"

deferred class
	EL_EXCHANGE_RATE_TABLE

inherit
	HASH_TABLE [REAL, NATURAL_8]
		rename
			make as make_table,
			fill as fill_from
		end

	EL_INTEGER_MATH
		undefine
			copy, is_equal
		end

	EL_MODULE_LIO

	EL_MODULE_DIRECTORY

	EL_SHARED_CURRENCY_ENUM

feature {NONE} -- Initialization

	make (a_date: like date; a_significant_digits: like significant_digits)
		do
			date := a_date; significant_digits := a_significant_digits
			make_equal (23)
			fill
		end

feature -- Access

	cached_dates: EL_SORTABLE_ARRAYED_LIST [DATE]
		-- dates of disk cached rates sorted in reverse chronological order
		local
			dir: EL_DIRECTORY
		do
			create Result.make (5)
			create dir.make (Rates_dir)
			across dir.files_with_extension (XML_extension) as file_path loop
				Result.extend (Date_factory.create_date (file_path.item.base_name))
			end
			Result.reverse_sort
			Result.compare_objects
		end

	base_currency: NATURAL_8
		deferred
		end

	conversion_price_x100 (base_price_x100: INTEGER; a_currency_code: NATURAL_8): INTEGER
		do
			if a_currency_code ~ base_currency then
				Result := base_price_x100
			else
				search (a_currency_code)
				if found then
					Result := (base_price_x100 * found_item).rounded
					if significant_digits > 0 then
						Result := rounded (Result, significant_digits)
					end
				end
			end
		end

	date: DATE

	significant_digits: INTEGER

feature {NONE} -- Implementation

	fill
		local
			euro_table: like new_euro_table
			base_euro_value: REAL
		do
			euro_table := new_euro_table
			if euro_table.has (base_currency) then
				base_euro_value := euro_table.euro_unit_value (base_currency)
				extend (base_euro_value, Currency_enum.EUR)
				from euro_table.start until euro_table.after loop
					if euro_table.key_for_iteration /~ base_currency then
						extend (euro_table.item_for_iteration * base_euro_value, euro_table.key_for_iteration)
					end
					euro_table.forth
				end
			end
		end

	new_euro_table: EL_EURO_EXCHANGE_RATE_TABLE
		do
			create Result.make (date, significant_digits)
		end

feature {NONE} -- Constants

	Date_factory: DATE_TIME_CODE_STRING
		once
			create Result.make (Date_format)
		end

	Date_format: STRING = "yyyy-[0]mm-[0]dd"

	Rates_dir: DIR_PATH
		once
			Result := Directory.App_cache #+ "ECB-euro-exchange-rates"
		end

	XML_extension: ZSTRING
		once
			Result := "xml"
		end

end