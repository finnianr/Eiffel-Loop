note
	description: "[
		A read-only ${ZSTRING} that has the concept of text that is floating in the middle of
		some arbitrary whitespace to the left and right. The function groups ''starts_with*'' 
		and ''ends_with*'' relate only to this embedded "floating text".
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-25 7:44:38 GMT (Sunday 25th August 2024)"
	revision: "3"

class
	EL_FLOATING_ZSTRING

inherit
	ZSTRING
		rename
			count as full_count,
			ends_with as full_ends_with,
			ends_with_character as full_ends_with_character,
			same_string as full_same_string,
			starts_with_character as full_starts_with_character,
			starts_with as full_starts_with,
			share as share_zstring
		export
			{NONE} all
		end

	EL_SIDE_ROUTINES

create
	make_empty

feature -- Element change

	share (other: ZSTRING)
		do
			internal_share (other)
			unencoded_area := other.unencoded_area
			if full_count > 0 then
				start_index := leading_white_space + 1
				end_index := full_count - trailing_white_space
			else
				start_index := 1
				end_index := 0
			end
			count := end_index - start_index + 1
		end

feature -- Measurement

	count: INTEGER
		-- count of text stripped of leading and trailing white space

	end_index: INTEGER
		-- index of first character before trailing white space

	start_index: INTEGER
		-- index of first character after leading white space

feature -- Status query

	ends_with (other: READABLE_STRING_32): BOOLEAN
		do
			Result := same_characters_at (other, Right_side)
		end

	ends_with_character (uc: CHARACTER_32): BOOLEAN
		do
			Result := count > 0 and then item (end_index) = uc
		end

	same_string (other: READABLE_STRING_32): BOOLEAN
		do
			Result := same_characters_at (other, Both_sides)
		end

	starts_with (other: READABLE_STRING_32): BOOLEAN
		do
			Result := same_characters_at (other, Left_side)
		end

	starts_with_character (uc: CHARACTER_32): BOOLEAN
		do
			Result := count > 0 and then item (start_index) = uc
		end

feature {NONE} -- Implementation

	same_characters_at (other: READABLE_STRING_32; side: INTEGER): BOOLEAN
		require
			valid_side: valid_sides (side)
		local
			index: INTEGER
		do
			inspect side
				when Left_side then
					if other.count <= count then
						index := start_index
					end
				when Right_side then
					if other.count <= count then
						index := start_index + count - other.count
					end
				when Both_sides then
					if other.count = count then
						index := start_index
					end
			else
			end
			if index > 0 then
				inspect string_storage_type (other)
					when 'X' then
						if attached {ZSTRING} other as z_str then
							Result := same_characters_zstring (z_str, 1, other.count, index)
						end
				else
					Result := same_characters_32 (other, 1, other.count, index, False)
				end
			end
		end

end