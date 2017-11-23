note
	description: "Exchange rate table for a `base_currency' based on Euro exchange rates table"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EL_EXCHANGE_RATE_TABLE

inherit
	HASH_TABLE [REAL, STRING]
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

feature {NONE} -- Initialization

	make (a_date: like date; a_significant_digits: like significant_digits)
		do
			date := a_date; significant_digits := a_significant_digits
			make_equal (23)
			fill
		end

feature -- Access

	base_currency: STRING
		deferred
		end

	conversion_price_x100 (base_price_x100: INTEGER; currency_code: STRING): INTEGER
		do
			if currency_code ~ base_currency then
				Result := base_price_x100
			else
				search (currency_code)
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
				extend (base_euro_value, "EUR")
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

end
