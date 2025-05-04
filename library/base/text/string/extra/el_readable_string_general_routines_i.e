note
	description: "Routines for classes conforming to ${READABLE_STRING_GENERAL}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-04 14:58:38 GMT (Sunday 4th May 2025)"
	revision: "43"

deferred class
	EL_READABLE_STRING_GENERAL_ROUTINES_I

inherit
	EL_ROUTINES

	EL_STRING_HANDLER

feature -- Factory

	new_template (general: READABLE_STRING_GENERAL): EL_TEMPLATE [STRING_GENERAL]
		do
			inspect string_storage_type (general)
				when '1' then
					if attached {READABLE_STRING_8} general as str_8 then
						create {EL_TEMPLATE [STRING_8]} Result.make (str_8)
					end

				when 'X' then
					if attached {ZSTRING} general as z_str then
						create {EL_TEMPLATE [ZSTRING]} Result.make (z_str)
					end
			else
				if attached {READABLE_STRING_32} general as str_32 then
					create {EL_TEMPLATE [STRING_32]} Result.make (str_32)
				end
			end
		end

feature -- Measurement

	occurrences (text, search_string: READABLE_STRING_GENERAL): INTEGER
			--
		do
			if attached Shared_intervals as intervals then
				intervals.wipe_out
				intervals.fill_by_string_general (text, search_string, 0)
				Result := intervals.count
			end
		end

	word_count (text: READABLE_STRING_GENERAL; exclude_variable_references: BOOLEAN): INTEGER
		-- count of all substrings of `text' string that have at least one alphabetical character.
		-- If `exclude_variable_references' is `True', exclude any substrings that take either of
		-- the forms: ${name} OR $name
		do
			if attached Once_word_intervals as word_intervals then
				word_intervals.fill (text)
				Result := word_intervals.word_count (text, exclude_variable_references)
			end
		end

feature -- Conversion

	to_unicode_general (general: READABLE_STRING_GENERAL): READABLE_STRING_GENERAL
		do
			if conforms_to_zstring (general) and then attached {ZSTRING} general as z_str then
				Result := z_str.to_general -- Result can be either `STRING_8' or `STRING_32'
			else
				Result := general
			end
		ensure
			not_zstring: not attached {EL_READABLE_ZSTRING} Result
		end

feature -- Basic operations

	search_interval_at_nth (text, search_string: READABLE_STRING_GENERAL; n: INTEGER): INTEGER_INTERVAL
			--
		do
			if attached Shared_intervals as intervals then
				intervals.wipe_out
				intervals.fill_by_string_general (text, search_string, 0)
				from intervals.start until intervals.after or intervals.index > n loop
					intervals.forth
				end
				Result := intervals.item_interval
			else
				create Result.make (0, 0)
			end
		end

feature {NONE} -- Constants

	Once_word_intervals: EL_SPLIT_WORD_INTERVALS
		once
			create Result.make_empty
		end

	Shared_intervals: EL_OCCURRENCE_INTERVALS
		once
			create Result.make_empty
		end
end