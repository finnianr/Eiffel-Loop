note
	description: "Exchange rate table for a `base_currency' based on Euro exchange rates table"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-24 9:24:29 GMT (Tuesday 24th April 2018)"
	revision: "4"

deferred class
	EL_EXCHANGE_RATE_TABLE

inherit
	HASH_TABLE [REAL, NATURAL_8]
		rename
			make as make_table,
			fill as fill_from
		end

	EL_MODULE_LIO
		undefine
			copy, is_equal
		end

	INTEGER_MATH
		undefine
			copy, is_equal
		end

	EL_MODULE_DIRECTORY
		undefine
			copy, is_equal
		end

	EL_SHARED_CURRENCY_ENUM
		undefine
			copy, is_equal
		end

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
			dir: EL_DIRECTORY; date_string: STRING
		do
			create Result.make (5)
			create dir.make (Rates_dir)
			across dir.files_with_extension (XML_extension) as file_path loop
				date_string := file_path.item.base_sans_extension
				Result.extend (create {DATE}.make_from_string (date_string, Date_format))
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
				extend (base_euro_value, Currency.EUR)
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

	Date_format: STRING = "yyyy-[0]mm-[0]dd"

	Rates_dir: EL_DIR_PATH
		once
			Result := Directory.user_configuration.joined_dir_path ("ECB-euro-exchange-rates")
		end

	XML_extension: ZSTRING
		once
			Result := "xml"
		end

end
