note
	description: "Results of a NVP button API query"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-02-24 12:03:42 GMT (Saturday 24th February 2024)"
	revision: "7"

class
	PP_BUTTON_QUERY_RESULTS

inherit
	PP_HTTP_RESPONSE

	EL_SHARED_CURRENCY_ENUM

	EL_CHARACTER_32_CONSTANTS

create
	make_default, make

feature -- Access

	alt_button_description: ZSTRING
		do
			Result := website_code
			if not Result.is_empty then
				Result := Result.substring_between (Alt_attribute, char ('"'), 1)
			end
		end

	hosted_button: PP_HOSTED_BUTTON
		do
			create Result.make (hosted_button_id)
		end

	price_list: EL_ARRAYED_MAP_LIST [ZSTRING, INTEGER]
		-- price list derived from `website_code' by parsing lines like:
		--		option value=%"Lifetime">Lifetime &yen;4,960 JPY<
		-- 	option value=%"1 year">1 year $4.40 CAD<

		local
			name, text: ZSTRING; currency_code, price_string: STRING
			start_index, price: INTEGER; currency: NATURAL_8
			part_list: EL_STRING_8_LIST
		do
			create Result.make (5)
			across website_code.split_intervals ("option value=%"") as interval loop
				if interval.cursor_index > 1 then
					start_index := interval.item_lower
					name := website_code.substring_to_from ('"', $start_index)
					start_index := start_index + name.count + 2 -- Skip to currency symbol
					text := website_code.substring_to_from ('<', $start_index) -- "&yen;4,960 JPY"
					remove_symbol (text)

					create part_list.make_split (text, ' ')
					if part_list.count = 2 then
						price_string := part_list.first
						currency_code := part_list.last
						currency := Currency_enum.value (currency_code)
						across Format_separators as separator loop
							price_string.prune_all (separator.item)
						end
						if price_string.is_integer then
							price := price_string.to_integer
							if Currency_enum.has_decimal (currency) then
								price := price * 100
							end
							Result.extend (name, price)
						else
							check
								price_string_is_integer: False
							end
						end
					else
						check
							two_part_string: False
						end
					end
				end
			end
		end

feature -- Paypal fields

	hosted_button_id: STRING

	website_code: ZSTRING

feature {NONE} -- Implementation

	remove_symbol (text: ZSTRING)
		-- Remove currency symbol like "&yen;"
		local
			count: INTEGER
		do
			if text.count > 0 then
				from count := 0 until text.is_numeric_item (count + 1) loop
					count := count + 1
				end
				text.remove_head (count)
			end
		end

feature {NONE} -- Constants

	Alt_attribute: ZSTRING
		once
			Result := "alt=%""
		end

	Assignment: CHARACTER = '='

	Format_separators: STRING = ",."

end