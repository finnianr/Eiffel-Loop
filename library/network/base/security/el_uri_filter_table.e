note
	description: "URL filters for malicious web-server traffic"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-02-23 8:11:11 GMT (Sunday 23rd February 2025)"
	revision: "17"

class
	EL_URI_FILTER_TABLE

inherit
	EL_HASH_TABLE [EL_IMMUTABLE_STRING_8_SET, STRING]
		rename
			make as make_table,
			extend as extend_table
		export
			{NONE} all
		end

	EL_URI_FILTER_BASE

	EL_SHARED_STRING_8_BUFFER_POOL

create
	make

feature {NONE} -- Initialization

	make
		do
			make_equal (Predicate.count)
			create predicate_list.make_from_tuple (Predicate)
			predicate_list.compare_references
			create whitelist_set.make_equal (100)
			create whitelist_stem_list.make (10)
			create excluded_first_characters.make (10)
		end

feature -- Status report

	has_excluded_first_characters: BOOLEAN
		do
			Result := excluded_first_characters.count > 0
		end

	is_hacker_probe (path_lower: STRING): BOOLEAN
		local
			s: EL_STRING_8_ROUTINES
		do
			if digit_count_exceeded (path_lower) then
				-- filter requests like: "GET /87543bde9176626b120898f9141058 HTTP/1.1"
				-- but allow: "GET /images/favicon/196x196.png HTTP/1.1"
				Result := True
			else
				from start until after or Result loop
					Result := iteration_item_matches (path_lower, s.substring_to (path_lower, '/'), dot_extension (path_lower))
					forth
				end
			end
		end

	is_whitelisted (path_lower: STRING): BOOLEAN
		-- True if `path_lower' is whitelisted
		do
			Result := whitelist_set.has (path_lower)
			if not Result then
				Result := across whitelist_stem_list as list some path_lower.starts_with (list.item) end
			end
		end

feature -- Access

	predicate_list: EL_STRING_8_LIST

feature -- Basic operations

	extend (manifest_lines, predicate_key: STRING)
		require
			no_trailing_empty_line: manifest_lines.count > 0 implies manifest_lines [manifest_lines.count] /= '%N'
			predicate_in_list: predicate_list.has (predicate_key)
		local
			string_set: EL_IMMUTABLE_STRING_8_SET
		do
			create string_set.make (manifest_lines)
			extend_table (string_set, predicate_key)

		-- Optimize single character comparison by putting them in `excluded_first_characters'			
			if predicate_key = Predicate.starts_with then
				across string_set.to_array as list loop
					if attached list.item as word and then word.count = 1 then
						excluded_first_characters.extend (word [1])
						string_set.prune (word)
					end
				end
			end
		ensure
			starts_with_table_has_no_string_count_eq_1: has_key (Predicate.starts_with) implies
				across found_item as table all
					table.item.count /= 1
				end
		end

	put_whitelist (path_lower: STRING)
		local
			s: EL_STRING_8_ROUTINES
		do
			if s.ends_with_character (path_lower, '*') then
				whitelist_stem_list.extend (path_lower.substring (1, path_lower.count - 1))
			else
				whitelist_set.put (path_lower)
			end
		end

feature {NONE} -- Implementation

	iteration_item_matches (path_lower, path_first_step, path_extension: STRING): BOOLEAN
		do
			if attached key_for_iteration as predicate_name and then attached item_for_iteration as word_set then
				if predicate_name = Predicate.has_extension and then path_extension.count > 0 then
					Result := word_set.has_8 (path_extension)

				elseif predicate_name = Predicate.first_step then
					Result := word_set.has_8 (path_first_step)

				elseif predicate_name = Predicate.starts_with then
					if path_lower.count > 0 then
						Result := excluded_first_characters.has (path_lower [1])
					end
					if not Result then
						Result := across word_set as set some path_lower.starts_with (set.item) end
					end

				elseif predicate_name = Predicate.ends_with then
					Result := across word_set as set some path_lower.ends_with (set.item) end

				end
			end
		end

	match_output_dir: DIR_PATH
		-- location of "match-*.txt" files for use in EL_URI_FILTER_TABLE
		do
			create Result
		end

feature {NONE} -- Internal attributes

	excluded_first_characters: STRING
		-- characters that should not be the first character in URI path

	whitelist_stem_list: EL_STRING_8_LIST
		-- list of URI path stems matched with `starts_with'
		-- eg. "images/apple-touch-icon" matches "images/apple-touch-icon-152x152.png"

	whitelist_set: EL_HASH_SET [STRING]

end