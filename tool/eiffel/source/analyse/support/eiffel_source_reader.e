note
	description: "[
		Abstraction to read Eiffel source file and detect keywords, identifiers, quoted text,
		numbers and comments
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-09-16 8:12:23 GMT (Saturday 16th September 2023)"
	revision: "6"

deferred class
	EIFFEL_SOURCE_READER

inherit
	ANY

	EL_MODULE_FILE

	EL_SHARED_STRING_8_CURSOR; EL_SHARED_IMMUTABLE_8_MANAGER

	EL_EIFFEL_IMMUTABLE_KEYWORDS

feature {NONE} -- Initialization

	initialize
		do
		end

	make (source_path: FILE_PATH)
		do
			initialize
			if attached File.plain_text_bomless (source_path) as source
				and then attached cursor_8 (source) as c8
			then
				byte_count := source.count
				analyze (c8.area, c8.area_first_index, c8.area_last_index)
			end
		end

feature -- Measurement

	byte_count: INTEGER
		-- source byte count excluding any BOM

feature {NONE} -- Events

	on_comment (area: SPECIAL [CHARACTER]; i, count: INTEGER)
		deferred
		end

	on_identifier (area: SPECIAL [CHARACTER]; i, count: INTEGER)
		deferred
		end

	on_keyword (area: SPECIAL [CHARACTER]; i, count: INTEGER; type: INTEGER_64)
		deferred
		end

	on_manifest_string (area: SPECIAL [CHARACTER]; i, count: INTEGER)
		deferred
		end

	on_numeric_constant (area: SPECIAL [CHARACTER]; i, count: INTEGER)
		deferred
		end

	on_quoted_character (area: SPECIAL [CHARACTER]; i, count: INTEGER)
		deferred
		end

	on_quoted_string (area: SPECIAL [CHARACTER]; i, count: INTEGER)
		deferred
		end

feature {NONE} -- Section query

	is_comment (area: SPECIAL [CHARACTER]; i, last_index: INTEGER): BOOLEAN
		do
			Result := i + 1 <= last_index and then area [i + 1] = '-'
		end

	is_hexadecimal_or_binary (area: SPECIAL [CHARACTER]; i, last_index: INTEGER): BOOLEAN
		do
			if i + 2 <= last_index then
				inspect area [i + 1]
					when 'b', 'B', 'x', 'X' then
						Result := True
				else
				end
				if Result then
					inspect area [i + 2]
						when '0' .. '9', 'A' .. 'F', 'a' .. 'f' then
							Result := True
					else
					end
				end
			end
		end

	is_open_string_manifest (area: SPECIAL [CHARACTER]; i, last_index: INTEGER): BOOLEAN
		local
			c: CHARACTER; j: INTEGER
		do
			if i + 2 <= last_index and then area [i + 1] = '[' then
				Result := True
				from j := i + 2 until not Result or j = last_index loop
					c := area [j]
					if c = '%N' then
						j := last_index - 1 -- Exit loop

					else
						Result := c.is_space
					end
					j := j + 1
				end
			end
		end

feature {NONE} -- Implementation

	analyze (area: SPECIAL [CHARACTER]; first_index, last_index: INTEGER)
		local
			i, count: INTEGER; type: INTEGER_64
		do
			from i := first_index until i > last_index loop
				inspect area [i]
					when '-' then
						if is_comment (area, i, last_index) then
							count := comment_skip_count (area, i, last_index)
							on_comment (area, i, count)
						end
					when '"' then
						if is_open_string_manifest (area, i, last_index) then
							count := string_manifest_skip_count (area, i, last_index)
							on_manifest_string (area, i, count)
						else
							count := quoted_text_skip_count (area, '"', i, last_index)
							on_quoted_string (area, i, count)
						end
					when '%'' then
						count := quoted_text_skip_count (area, '%'', i, last_index)
						on_quoted_character (area, i, count)

					when 'A' .. 'Z', 'a' .. 'z' then
						count := word_skip_count (area, i, last_index)
						type := keyword_type (area, i, count)
						if type > 0 then
							on_keyword (area, i, count, type)
						else
							on_identifier (area, i, count)
						end

					when '0' .. '9' then
						if is_hexadecimal_or_binary (area, i, last_index) then
							count := hexadecimal_or_binary_skip_count (area, i, last_index)
						else
							count := number_skip_count (area, i, last_index)
						end
						on_numeric_constant (area, i, count)

				else
					count := 1
				end
				i := i + count
			end
		end

	comment_skip_count (area: SPECIAL [CHARACTER]; i, last_index: INTEGER): INTEGER
		local
			done: BOOLEAN; j: INTEGER
		do
			from j := i + 2 until j > last_index or done loop
				inspect area [j]
					when '%R', '%N' then
						done := True
				else
					j := j + 1
				end
			end
			Result := j - i
		end

	hexadecimal_or_binary_skip_count (area: SPECIAL [CHARACTER]; i, last_index: INTEGER): INTEGER
		local
			done: BOOLEAN; j: INTEGER
		do
			from j := i + 1 until j > last_index or done loop
				inspect area [j]
					when '0' .. '9', 'A' .. 'F', 'a' .. 'f', 'x', 'X' then
						j := j + 1
				else
					done := True
				end
			end
			Result := j - i
		end

	keyword_type (area: SPECIAL [CHARACTER]; i, count: INTEGER): INTEGER_64
		local
			first: CHARACTER; changed: BOOLEAN
		do
			first := area [i]
			if first.is_upper then
				area [i] := first.as_lower
				changed := True
			end
			if attached Keyword_type_table as table then
			-- Important to ensure `Keyword_type_table' has been created before call to `set_item'
				Immutable_8.set_item (area, i, count)
				if table.has_immutable_key (Immutable_8.item) then
					Result := table.found_interval
				end
			end
			if changed then
				area [i] := first
			end
		end

	number_skip_count (area: SPECIAL [CHARACTER]; i, last_index: INTEGER): INTEGER
		local
			done: BOOLEAN; j: INTEGER
		do
			from j := i + 1 until j > last_index or done loop
				inspect area [j]
					when '0' .. '9' then
						j := j + 1

				-- floating point or range, which ?
					when '.' then
						if j + 1 <= last_index and then area [j + 1] = '.' then
						-- is range a..b	
							done := True
						else
							j := j + 1
						end
				-- Floating point positive/negative exponent or integer expression, which ?
					when '-', '+' then
						if area [i - 1].is_digit then
							done := True
						else
						-- must be floating point exponent	
							j := j + 1
						end

				-- Floating point exponent
					when 'e', 'E' then
						j := j + 1
				else
					done := True
				end
			end
			Result := j - i
		end

	quoted_text_skip_count (area: SPECIAL [CHARACTER]; quote_character: CHARACTER; i, last_index: INTEGER): INTEGER
		local
			done: BOOLEAN; j: INTEGER
		do
			from j := i + 1 until j > last_index or done loop
				if area [j] = quote_character then
					if area [j - 1] = quote_character then
					-- check for escaped percent sign %%
						if not (j - 2 > i and then area [j - 2] = '%%') then
							done := True
						end
					else
						done := True
					end
				end
				j := j + 1
			end
			Result := j - i
		end

	string_manifest_skip_count (area: SPECIAL [CHARACTER]; i, last_index: INTEGER): INTEGER
		local
			done: BOOLEAN; j: INTEGER; c: CHARACTER
		do
			from j := i + 2 until j > last_index or done loop
				if j + 2 <= last_index then
					c := area [j]
					if (c = '%N' or c = '%T')  and then area [j + 1] = ']' and then area [j + 2] = '"' then
						done := True
					end
				end
				j := j + 1
			end
			Result := j - i + 2
		end

	word_skip_count (area: SPECIAL [CHARACTER]; i, last_index: INTEGER): INTEGER
		local
			done: BOOLEAN; j: INTEGER
		do
			from j := i + 1 until j > last_index or done loop
				inspect area [j]
					when 'A' .. 'Z', 'a' .. 'z', '0' .. '9', '_' then
						j := j + 1
				else
					done := True
				end
			end
			Result := j - i
		end

end