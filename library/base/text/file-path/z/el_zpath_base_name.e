note
	description: "Modify or query the base name (last step) of path conforming to [$source EL_ZPATH]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-13 16:46:42 GMT (Sunday 13th February 2022)"
	revision: "1"

deferred class
	EL_ZPATH_BASE_NAME

inherit
	EL_ZPATH_IMPLEMENTATION

feature -- Access

	base: ZSTRING
		do
			Result := Shared_base
			Result.wipe_out
			Result.append (internal_base)
		end

	base_sans_extension: ZSTRING
		do
			Result := base_part (1)
		end

	extension: ZSTRING
		do
			Result := base_part (2)
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

feature -- Status query

	base_matches (name: READABLE_STRING_GENERAL): BOOLEAN
		-- `True' if `name' is same string as `base_sans_extension'
		local
			pos_dot: INTEGER
		do
			if step_count > 0 and then attached internal_base as l_base then
				pos_dot := dot_index (l_base)
				if pos_dot > 0 then
					Result := pos_dot - 1 = name.count and then l_base.starts_with_general (name)
				else
					Result := l_base.same_string (name)
				end
			else
				Result := name.is_empty
			end
		ensure
			valid_result: Result implies base_sans_extension.same_string (name)
		end

	has_dot_extension: BOOLEAN
		do
			Result := dot_index (internal_base) > 0
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

	same_extension (a_extension: READABLE_STRING_GENERAL; case_insensitive: BOOLEAN): BOOLEAN
		local
			pos_dot: INTEGER
		do
			if step_count > 0 and then attached internal_base as l_base then
				pos_dot := dot_index (l_base)
				if pos_dot > 0 then
					if case_insensitive then
						Result := l_base.same_caseless_characters_general (a_extension, 1, a_extension.count, pos_dot + 1)
					else
						Result := l_base.same_characters (a_extension, 1, a_extension.count, pos_dot + 1)
					end
				end
			end
		end

feature -- Element change

	add_extension (a_extension: READABLE_STRING_GENERAL)
		local
			str: ZSTRING
		do
			if step_count > 0 then
				str := base
				str.append_character ('.'); str.append_string_general (a_extension)
				put_i_th (Step_table.to_token (str), step_count)
				reset_hash
			end
		end

	replace_extension (a_replacement: READABLE_STRING_GENERAL)
		local
			pos_dot: INTEGER
		do
			if step_count > 0 and then attached base as l_base then
				pos_dot := dot_index (l_base)
				if pos_dot > 0 then
					l_base.replace_substring_general (a_replacement, pos_dot + 1, l_base.count)
					put_i_th (Step_table.to_token (l_base), step_count)
					reset_hash
				end
			end
		end

	set_version_number (number: like version_number)
		require
			has_version_number: has_version_number
		do
			if step_count > 0 and then attached version_interval as interval and then not interval.off
				and then attached base as l_base
			then
				l_base.replace_substring_general (
					Format.integer_zero (number, interval.item_count), interval.item_start_index, interval.item_end_index
				)
				put_i_th (Step_table.to_token (l_base), step_count)
				reset_hash
			end
		ensure
			is_set: version_number = number
		end

feature -- Removal

	remove_extension
		local
			pos_dot: INTEGER
		do
			if step_count > 0 and then attached base as l_base then
				pos_dot := dot_index (l_base)
				if pos_dot > 0 then
					l_base.keep_head (pos_dot - 1)
					put_i_th (Step_table.to_token (l_base), step_count)
					reset_hash
				end
			end
		end

feature {NONE} -- Implementation

	put_i_th (token, i: INTEGER_32)
		-- Replace `i'-th entry, if in index interval, by `v'.
		deferred
		end

	reset_hash
		deferred
		end

end