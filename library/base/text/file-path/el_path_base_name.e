note
	description: "Modify or query the base name (last step) of path conforming to [$source EL_ZPATH]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "4"

deferred class
	EL_PATH_BASE_NAME

inherit
	EL_MODULE_FORMAT

feature -- Access

	base: ZSTRING

	base_sans_extension: ZSTRING
		local
			index: INTEGER
		do
			index := dot_index
			if index > 0 then
				Result := base.substring (1, index - 1)
			else
				Result := base
			end
		end

	extension: ZSTRING
			--
		local
			index: INTEGER
		do
			index := dot_index
			if index > 0 then
				Result := base.substring_end (index + 1)
			else
				create Result.make_empty
			end
		end

	version_interval: EL_SPLIT_ZSTRING_LIST
		-- `Result.item' is last natural number between two dots
		-- if `Result.off' then there is no interval
		do
			create Result.make (base, '.')
			from Result.finish until Result.before or else Result.item.is_natural loop
				Result.back
			end
		end

	version_number: INTEGER
			-- value of numeric value immediately before extension and separated by dots
			-- `-1' if no version number found

			-- Example: "myfile.02.mp3" returns 2
		do
			if attached version_interval as interval then
				if interval.off then
					Result := -1
				elseif attached base.substring (interval.item_start_index, interval.item_end_index) as number then
					number.prune_all_leading ('0')
					if number.is_empty then
						Result := 0
					elseif number.is_integer then
						Result := number.to_integer
					else
						Result := -1
					end
				end
			end
		end

feature -- Measurement

	dot_index: INTEGER
		-- index of last dot, 0 if none
		do
			if not base.is_empty then
				Result := base.last_index_of ('.', base.count)
			end
		end

feature -- Status Query

	base_matches (name: READABLE_STRING_GENERAL; case_insensitive: BOOLEAN): BOOLEAN
		-- `True' if `name' is same string as `base_sans_extension'
		local
			pos_dot: INTEGER
		do
			if base.is_empty then
				Result := name.is_empty
			else
				pos_dot := dot_index
				if pos_dot > 0 then
					Result := pos_dot - 1 = name.count and then base.same_substring (name, 1, case_insensitive)
				else
					Result := base.count = name.count and then base.same_substring (name, 1, case_insensitive)
				end
			end
		ensure
			valid_result: Result and not case_insensitive implies base_sans_extension.same_string_general (name)
			valid_result: Result and case_insensitive implies base_sans_extension.same_caseless_characters_general (name, 1, name.count, 1)

		end

	has_dot_extension: BOOLEAN
		do
			Result := dot_index > 0
		end

	has_extension (a_extension: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := same_extension (a_extension, False)
		end

	has_some_extension (extension_list: ITERABLE [READABLE_STRING_GENERAL]; case_insensitive: BOOLEAN): BOOLEAN
		do
			Result := across extension_list as l_extension some
				same_extension (l_extension.item, case_insensitive)
			end
		end

	has_version_number: BOOLEAN
		do
			Result := not version_interval.off
		end

	same_base (a_base: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := base.same_string_general (a_base)
		end

	same_extension (a_extension: READABLE_STRING_GENERAL; case_insensitive: BOOLEAN): BOOLEAN
		local
			index: INTEGER
		do
			index := base.count - a_extension.count
			if index > 0 and then base [index] = '.' then
				if case_insensitive then
					Result := base.same_caseless_characters_general (a_extension, 1, a_extension.count, index + 1)
				else
					Result := base.same_characters_general (a_extension, 1, a_extension.count, index + 1)
				end
			end
		end

feature -- Element change

	add_extension (a_extension: READABLE_STRING_GENERAL)
		local
			str: ZSTRING
		do
			create str.make (base.count + a_extension.count + 1)
			str.append (base); str.append_character ('.'); str.append_string_general (a_extension)
			base := str
			reset_hash
		end

	remove_extension
		local
			index: INTEGER
		do
			index := dot_index
			if index > 0 then
				base.remove_tail (base.count - index + 1)
			end
		end

	rename_base (new_name: READABLE_STRING_GENERAL; preserve_extension: BOOLEAN)
			-- set new base to new_name, preserving extension if preserve_extension is True
		local
			l_extension: like extension
		do
			l_extension := extension
			base.wipe_out
			base.append_string_general (new_name)
			if preserve_extension and then not has_extension (l_extension) then
				add_extension (l_extension)
			end
			reset_hash
		end

	replace_extension (a_replacement: READABLE_STRING_GENERAL)
		local
			index: INTEGER
		do
			index := dot_index
			if index > 0 then
				base.replace_substring_general (a_replacement, index + 1, base.count)
			end
			reset_hash
		end

	set_base (a_base: READABLE_STRING_GENERAL)
		local
			s: EL_ZSTRING_ROUTINES
		do
			base := s.as_zstring (a_base)
			reset_hash
		end

	set_version_number (number: like version_number)
		require
			has_version_number: has_version_number
		do
			if attached version_interval as interval and then not interval.off then
				base.replace_substring_general (
					Format.integer_zero (number, interval.item_count), interval.item_start_index, interval.item_end_index
				)
			end
			reset_hash
		end

feature {NONE} -- Deferred implementation

	reset_hash
		deferred
		end

end