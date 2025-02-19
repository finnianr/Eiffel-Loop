note
	description: "URL filters for malicious web-server traffic"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-02-19 17:30:08 GMT (Wednesday 19th February 2025)"
	revision: "13"

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

	EL_URI_FILTER_CONSTANTS

	EL_URI_FILTER_BASE

create
	make

feature {NONE} -- Initialization

	make
		do
			make_equal (Predicate.count)
			create predicate_list.make_from_tuple (Predicate)
			predicate_list.compare_references
			create whitelist_set.make_equal (100)
		end

feature -- Status report

	is_hacker_probe (path_lower, user_agent: STRING): BOOLEAN
		local
			s: EL_STRING_8_ROUTINES
		do
			if user_agent.is_empty then
				Result := True

			elseif whitelist_set.has (path_lower) then
				Result := False

			elseif digit_count_exceeded (path_lower) then
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

feature -- Access

	predicate_list: EL_STRING_8_LIST

feature -- Basic operations

	extend (manifest_lines, predicate_key: STRING)
		require
			predicate_in_list: predicate_list.has (predicate_key)
		do
			extend_table (create {EL_IMMUTABLE_STRING_8_SET}.make (manifest_lines), predicate_key)
		end

	put_whitelist (path_lower: STRING)
		do
			whitelist_set.put (path_lower)
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
					Result := across word_set as set some path_lower.starts_with (set.item) end

				elseif predicate_name = Predicate.ends_with then
					Result := across word_set as set some path_lower.ends_with (set.item) end

				end
			end
		end

feature {NONE} -- Internal attributes

	whitelist_set: EL_HASH_SET [STRING]

end