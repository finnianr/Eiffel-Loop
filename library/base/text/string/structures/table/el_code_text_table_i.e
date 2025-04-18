note
	description: "[
		Abstraction for table of text looked up by an ${INTEGER_64} from an indented table
		manifest. Codes that have already been found are cached in a hash table of type
		${HASH_TABLE [ZSTRING, INTEGER_64]}.
	]"
	notes: "[
		Manifest format must be an integer code followed by a colon, and then 1 or more indented
		lines using a tab character.
		
		**Example**
				
			0:
				No error, the operation was successful.
			-1:
				A generic error code indicating an I/O error. It typically means there
				was an error in the file handling outside of zlib.

	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-08 19:05:18 GMT (Tuesday 8th April 2025)"
	revision: "7"

deferred class
	EL_CODE_TEXT_TABLE_I

inherit
	EL_LAZY_ATTRIBUTE
		rename
			new_item as new_cache,
			cached_item as actual_cache
		end

	EL_STRING_GENERAL_ROUTINES_I

	EL_MODULE_CONVERT_STRING

	EL_SHARED_IMMUTABLE_8_MANAGER; EL_SHARED_STRING_8_BUFFER_POOL

	EL_ZSTRING_CONSTANTS

feature -- Status query

	has_key (code: INTEGER_64): BOOLEAN
		local
			line_list: EL_SPLIT_IMMUTABLE_STRING_8_ON_CHARACTER
		do
			if cache.has_key (code) then
				found_item := cache.found_item

			elseif attached new_manifest as manifest then
				if manifest.is_string_8 and then attached {READABLE_STRING_8} manifest as str_8 then
					create line_list.make (Immutable_8.as_shared (str_8), '%N')
					search (code, line_list, False)

				elseif attached String_8_pool.borrowed_item as borrowed then
					create line_list.make (Immutable_8.as_shared (borrowed.copied_general_as_utf_8 (manifest)), '%N')
					search (code, line_list, True)
					borrowed.return
				end
			end
			Result := found
		end

feature -- Access

	item alias "[]" (code: INTEGER_64): ZSTRING
		do
			if has_key (code) then
			end
			Result := found_item
		end

	found_item: ZSTRING

feature -- Status query

	found: BOOLEAN
		do
			Result := found_item /= default_item
		end

feature -- Contract Support

	valid_manifest (a_manifest: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := across a_manifest.split ('%N') as line all
				valid_line (line.item)
			end
		end

feature {NONE} -- Implementation

	cache: like new_cache
		do
			Result := lazy_item
		end

	search (code: INTEGER_64; line_list: EL_SPLIT_IMMUTABLE_STRING_8_ON_CHARACTER; utf_8_encoded: BOOLEAN)
		local
			done, code_found: BOOLEAN; unindented: IMMUTABLE_STRING_8
		do
			found_item := default_item
			across line_list as list until done loop
				if attached list.item as line and then attached super_readable_8 (line) as super_line then
					if code_found then
						if super_line.starts_with_character ('%T') then
							if found_item.count > 0 then
								found_item.append_character_8 ('%N')
							end
							if line.valid_index (2) then
								unindented := line.shared_substring (2, line.count)
							else
								unindented := line
							end
							if utf_8_encoded then
								found_item.append_utf_8 (unindented)
							else
								found_item.append_string_general (unindented)
							end
						else
							done := True
						end
					elseif super_line.ends_with_character (':')
						and then not super_line.starts_with_character ('%T')
						and then code = Convert_string.substring_to_integer_64 (line, 1, line.count - 1)
					then
						code_found := True
						create found_item.make (300)
					end
				end
			end
			if found then
				found_item.trim
				cache.put (found_item, code)
			end
		end

	valid_line (line: READABLE_STRING_GENERAL): BOOLEAN
		do
			if line.count >= 2 then
				if line [1] /= '%T' and then line [line.count] = ':' then
					Result := line.substring (1, line.count - 1).to_string_8.is_integer_64
				else
					Result := line [1] = '%T'
				end
			end
		end

feature {NONE} -- Implementation

	new_cache: EL_HASH_TABLE [ZSTRING, INTEGER_64]
		do
			create Result.make_equal (11)
		end

feature {NONE} -- Deferred

	default_item: ZSTRING
		deferred
		end

	new_manifest: READABLE_STRING_GENERAL
		deferred
		end

end