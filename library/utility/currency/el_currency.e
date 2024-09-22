note
	description: "Currency"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-22 13:39:38 GMT (Sunday 22nd September 2024)"
	revision: "25"

class
	EL_CURRENCY

inherit
	EVOLICITY_SERIALIZEABLE

	EL_INTEGER_MATH
		export
			{NONE} all
		end

	EL_MODULE_DEFERRED_LOCALE

	EL_SHARED_CURRENCY_ENUM

create
	make

feature {EL_CURRENCY_LOCALE} -- Initialization

	make (language: STRING; a_code: like code)
		do
			code := a_code
			text := Texts_table.item_text (language)
			separator := [',', '.']
			set_format_and_symbol (text.format (a_code))
			make_default
		end

feature -- Access

	code: NATURAL_8

	code_name: STRING
		-- EUR, USD etc
		do
			Result := Currency_enum.name (code)
		end

	formatted (amount_x100: INTEGER): ZSTRING
		local
			i, count, separator_count: INTEGER
		do
			count := digit_count (amount_x100)
			separator_count := (count - 2) // 3
			if has_decimal then
				separator_count := separator_count + 1
			else
				count := count - 2
			end
			create Result.make (count + separator_count + symbol.count + 1)
			Result.append_integer (amount_x100)
			if has_decimal then
				from until Result.count >= 3 loop
					Result.prepend_character ('0')
				end
				i := Result.count - 1
				Result.insert_character (separator.decimal, i)
			else
				Result.remove_tail (2)
				i := Result.count + 1
			end
			from until i <= 1 loop
				i := i - 3
				if i > 1 then
					Result.insert_character (separator.threes, i)
				end
			end
			if is_symbol_first then
				Result.prepend_character (' ')
				Result.prepend (symbol)
			else
				Result.append_character (' ')
				Result.append (symbol)
			end
		end

	name: ZSTRING
		do
			Result := text.name (code)
		end

	separator: TUPLE [threes, decimal: CHARACTER]

	symbol: ZSTRING

feature -- Element change

	set_format_and_symbol (format: ZSTRING)
		require
			valid_decimal_format: has_decimal implies (6 |..| 8).has (format.occurrences ('#'))
			valid_nondecimal_format: not has_decimal implies format.occurrences ('#') = 4
		local
			pos_hash: INTEGER
		do
			pos_hash := format.index_of ('#', 1)
			is_symbol_first := pos_hash /= 1
			if is_symbol_first then
				symbol := format.substring (1, pos_hash - 2)
			else
				symbol := format.substring_end (format.last_index_of ('#', format.count) + 2)
			end
			separator.threes := format.item (pos_hash + 1).to_character_8
			if has_decimal then
				separator.decimal := format.item (pos_hash + 5).to_character_8
			end
		end

feature -- Status query

	has_decimal: BOOLEAN
		do
			Result := Currency_enum.has_decimal (code)
		end

	is_symbol_first: BOOLEAN

feature {NONE} -- Evolicity

	Template: STRING = ""

	getter_function_table: like getter_functions
			--
		do
			create Result.make_assignments (<<
				["code", agent: STRING do Result := code_name end],
				["name", agent: ZSTRING do Result := name end],
				["symbol", agent: ZSTRING do Result := symbol end]
			>>)
		end

feature {NONE} -- Internal attributes

	text: EL_CURRENCY_TEXTS

feature {NONE} -- Constants

	Texts_table: EL_LOCALE_TEXTS_TABLE [EL_CURRENCY_TEXTS]
		once
			create Result.make
		end
end