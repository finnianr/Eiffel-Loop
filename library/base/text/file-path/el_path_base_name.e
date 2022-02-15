note
	description: "Modify or query the base name (last step) of path conforming to [$source EL_ZPATH]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-15 17:18:43 GMT (Tuesday 15th February 2022)"
	revision: "4"

deferred class
	EL_PATH_BASE_NAME

inherit
	EL_PATH_CONSTANTS

	EL_MODULE_DIRECTORY
	EL_MODULE_FORMAT

feature -- Access

	base: ZSTRING
		do
			Result := shared_base
			Result.wipe_out
			Result.append (internal_base)
		end

	base_sans_extension: ZSTRING
		do
			Result := base_parts [1].twin
		end

	extension: ZSTRING
		do
			Result := base_parts [2].twin
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

	base_matches (name: READABLE_STRING_GENERAL; case_insensitive: BOOLEAN): BOOLEAN
		-- `True' if `name' is same string as `base_sans_extension'
		local
			pos_dot: INTEGER
		do
			if step_count > 0 and then attached internal_base as l_base then
				pos_dot := dot_index (l_base)
				if pos_dot > 0 then
					Result := pos_dot - 1 = name.count and then l_base.same_substring (name, 1, case_insensitive)
				else
					Result := l_base.count = name.count and then l_base.same_substring (name, 1, case_insensitive)
				end
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
					Result := l_base.same_substring (a_extension, pos_dot + 1, case_insensitive)
				else
					Result := a_extension.is_empty
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
				put_base (str)
				reset_hash
			end
		end

	rename_base (new_name: READABLE_STRING_GENERAL; preserve_extension: BOOLEAN)
			-- set new base to new_name, preserving extension if preserve_extension is True
		local
			parts: like base_parts; l_base: ZSTRING
		do
			parts := base_parts
			l_base := parts [1]
			l_base.wipe_out; l_base.append_string_general (new_name)
			if preserve_extension then
				l_base.append_character_8 ('.')
				l_base.append_string_general (parts [2])
				put_base (l_base)
			end
			reset_hash
		end

	replace_extension (a_replacement: READABLE_STRING_GENERAL)
		do
			if step_count > 0 and then attached base_parts [1] as l_base then
				l_base.append_character_8 ('.')
				l_base.append_string_general (a_replacement)
				put_base (l_base)
				reset_hash
			end
		end

	set_base (a_base: READABLE_STRING_GENERAL)
		local
			s: EL_ZSTRING_ROUTINES
		do
			if step_count = 0 then
				append_step (a_base)
			else
				put_base (s.as_zstring (a_base))
				reset_hash
			end
		ensure
			base_set: internal_base.same_string (a_base)
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
				put_base (l_base)
				reset_hash
			end
		ensure
			is_set: version_number = number
		end

feature -- Removal

	remove_extension
		do
			put_base (base_parts [1])
			reset_hash
		end

feature {NONE} -- Implementation

	base_parts: EL_ZSTRING_LIST
		local
			pos_dot: INTEGER; l_base: like base
		do
			l_base := base
			Result := Base_parts_list
			Result [1] := l_base; Result [2].wipe_out
			pos_dot := dot_index (l_base)
			if pos_dot > 0 then
				Result [2].append_substring (l_base, pos_dot + 1, l_base.count)
				l_base.keep_head (pos_dot - 1)
			end
		end

	dot_index (str: ZSTRING): INTEGER
		-- index of last dot, 0 if none
		do
			if str.count > 0 then
				Result := str.last_index_of ('.', str.count)
			end
		end

	replace_part (a_replacement: READABLE_STRING_GENERAL; index: INTEGER)
		-- replace name before extension or extension
		require
			valid_index: index = 1 or index = 2
		local
			pos_dot, start_index, end_index: INTEGER
		do
			if step_count > 0 and then attached base as l_base then
				start_index := 1
				pos_dot := dot_index (l_base)
				if pos_dot > 0 then
					if index = 1 then
						end_index := pos_dot - 1
					else
						start_index := pos_dot + 1; end_index := l_base.count
					end
				else
					if index = 1 then
						end_index := l_base.count
					else
						end_index := 0
					end
				end
				if end_index > start_index then
					-- base
					l_base.replace_substring_general (a_replacement, start_index, end_index)
					put_base (l_base)
					reset_hash
				end
			end
		end

feature {NONE} -- Deferred implementation

	append_step (a_step: READABLE_STRING_GENERAL)
		require
			is_step: not a_step.has (Separator)
		deferred
		ensure
			base_set: base.same_string (a_step)
		end

	internal_base: ZSTRING
		deferred
		end

	put_base (a_step: READABLE_STRING_GENERAL)
		deferred
		end

	new_path (a_step_count: INTEGER): like Current
		deferred
		end

	reset_hash
		deferred
		end

	shared_base: ZSTRING
		deferred
		end

	step_count: INTEGER
		deferred
		end

feature {NONE} -- Constants

	Base_parts_list: EL_ZSTRING_LIST
		once
			create Result.make_from_array (<< shared_base, create {ZSTRING}.make_empty >>)
		end

end