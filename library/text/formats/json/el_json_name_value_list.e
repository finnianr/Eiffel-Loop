note
	description: "[
		Parses a non-recursive JSON list into name value pairs. Iterate using `from start until after loop'.
		Decoded name-value pairs accessible as: `item', `name_item' or  `value_item'.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-24 14:47:41 GMT (Friday 24th January 2020)"
	revision: "6"

class
	EL_JSON_NAME_VALUE_LIST

inherit
	LINEAR [TUPLE [name, value: ZSTRING]]
		redefine
			off
		end

create
	make

feature {NONE} -- Initialization

	make (utf_8: STRING)
		local
			string: ZSTRING; i: INTEGER
		do
			create name_8.make (20)
			create string.make_from_utf_8 (utf_8)
			string.replace_substring_all (Escaped_quotation_mark, Utf_16_quotation_mark)

			create split_list.make (string, Quotation_mark)
			if not all_values_quoted (string) then
				from i := string.count until i = 0 or not (string.is_space_item (i) or string [i] = '}') loop
					i := i - 1
				end
				string.insert_character (',', i + 1)
				string.edit (Quote_colon, Comma, agent insert_value_quotes)
				string.remove (string.last_index_of (',', string.count))
				create split_list.make (string, Quotation_mark)
			end
			count := (split_list.count - 1) // 4
		ensure
			exactly_divisable: (split_list.count - 1) \\ 4 = 0
		end

feature -- Access

	count: INTEGER

	index: INTEGER

feature -- Iteration items

	item: like item_for_iteration
		do
			Result := [name_item, value_item]
		end

	name_item: ZSTRING
		do
			split_list.go_i_th (list_index)
			create Result.make_unescaped (Unescaper, split_list.item (False))
		end

	name_item_8: STRING
		do
			Result := name_8
			name_8.wipe_out
			name_item.append_to_string_8 (name_8)
		end

	value_item: ZSTRING
		do
			split_list.go_i_th (list_index + 2)
			create Result.make_unescaped (Unescaper, split_list.item (False))
		end

feature -- Cursor movement

	finish
		do
			index := count
		end

	forth
		do
			index := index + 1
		end

	start
		do
			index := 1
		end

feature -- Status query

	after: BOOLEAN
		do
			Result := index > count
		end

	is_empty: BOOLEAN
		do
			Result := count = 0
		end

	off: BOOLEAN
			-- Is there no current item?
		do
			Result := (index = 0) or (index = count + 1)
		end

feature {NONE} -- Implementation

	all_values_quoted (string: ZSTRING): BOOLEAN
		local
			i, end_index: INTEGER
		do
			Result := True
			from split_list.start until not Result or split_list.after loop
				i := split_list.item_start_index; end_index := split_list.item_end_index
				if string [i] = ':' then
					from i := i + 1 until not Result or i > end_index loop
						Result := string.is_space_item (i)
						i := i + 1
					end
				end
				split_list.forth
			end
		end

	insert_value_quotes (start_index, end_index: INTEGER; str: ZSTRING)
		local
			i, quote_count: INTEGER; quote_inserted: BOOLEAN
		do
			from i := start_index until i > end_index loop
				if str [i] = '"' then
					quote_count := quote_count + 1
				end
				i := i + 1
			end
			if quote_count /= 2 then
				-- insert quote at start
				from i := start_index until quote_inserted or i > end_index loop
					if not quote_inserted and then not str.is_space_item (i) then
						str.insert_character ('"', i)
						quote_inserted := True
					else
						i := i + 1
					end
				end
				-- insert quote at end
				quote_inserted := False
				from i := end_index + 1 until quote_inserted or i = 0 loop
					if not quote_inserted and then not str.is_space_item (i) then
						str.insert_character ('"', i + 1)
						quote_inserted := True
					else
						i := i - 1
					end
				end
			end
		end

	list_index: INTEGER
		do
			Result := 2 + (index - 1) * 4
		end

feature {NONE} -- Internal attributes

	name_8: STRING

	split_list: EL_SPLIT_ZSTRING_LIST

feature {NONE} -- Constants

	Comma: ZSTRING
		once
			Result := ","
		end

	Escaped_quotation_mark: ZSTRING
		once
			Result := "\%""
		end

	Quotation_mark: ZSTRING
		once
			Result := "%""
		end

	Quote_colon: ZSTRING
		once
			Result := "%":"
		end

	Unescaper: EL_JSON_UNESCAPER
		once
			create Result.make
		end

	Utf_16_quotation_mark: ZSTRING
		once
			Result := "\u0022"
		end

end
