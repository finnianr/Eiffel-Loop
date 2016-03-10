note
	description: "Summary description for {EL_READABLE_STRING_GENERAL_LIST}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-04 16:27:08 GMT (Thursday 4th July 2013)"
	revision: "2"

deferred class
	EL_STRING_GENERAL_CHAIN [S -> STRING_GENERAL create make, make_empty end]

inherit
	EL_CHAIN [S]

feature {NONE} -- Initialization

	make_empty
		deferred
		end

	make_with_separator (a_string: like item; separator: CHARACTER_32; left_adjust: BOOLEAN)
		do
			make_empty
			append_split (a_string, separator, left_adjust)
		end

	make_with_lines (a_string: like item)
		do
			make_with_separator (a_string, '%N', False)
		end

	make_with_words (a_string: like item)
		do
			make_with_separator (a_string, ' ', False)
		end

	make_from_array (a: ARRAY [S])
		do
			make_empty
			grow (a.count)
			a.do_all (agent extend)
		end

feature -- Element change

	append_split (a_string: S; a_separator: CHARACTER_32; left_adjust: BOOLEAN)
		local
			list: LIST [like item]
		do
			list := a_string.split (a_separator)
			grow (count + list.count)
			if left_adjust then
				across list as str loop
					str.item.left_adjust
				end
			end
			list.do_all (agent extend)
		end

feature -- Resizing

	grow (i: INTEGER)
			-- Change the capacity to at least `i'.
		deferred
		end

feature -- Access

	comma_separated: like item
		do
			create Result.make (character_count + (count - 1).max (0) * 2)
			from start until after loop
				if index > 1 then
					Result.append (once ", ")
				end
				Result.append (item)
				forth
			end
		end

	joined_lines: like item
			-- joined with new line characters
		do
			Result := joined_with ('%N', False)
		end

	joined_words: like item
			-- joined with new line characters
		do
			Result := joined_with (' ', False)
		end

	joined_propercase_words: like item
			-- joined with new line characters
		do
			Result := joined_with (' ', True)
		end

	joined_strings: like item
			-- join strings with no separator (null separator)
		do
			Result := joined_with ('%U', False)
		end

	joined_with (a_separator: CHARACTER_32; propercase: BOOLEAN): like item
			-- Null character joins without separation
		do
			if a_separator = '%U' then
				create Result.make (character_count)
			else
				create Result.make (character_count + (count - 1).max (0))
			end
			from start until after loop
				if index > 1 and a_separator /= '%U' then
					Result.append_code (a_separator.natural_32_code)
				end
				Result.append (item)
				if propercase and not item.is_empty then
					Result.put_code (item.item (1).as_upper.natural_32_code, Result.count - item.count + 1)
				end
				forth
			end
		end

	character_count: INTEGER
			--
		do
			from start until after loop
				Result := Result + item.count
				forth
			end
		end

	joined_character_count: INTEGER
			--
		do
			Result := character_count + (count - 1)
		end

end
