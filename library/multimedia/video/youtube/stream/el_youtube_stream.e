note
	description: "Youtube stream channel info"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-11 15:19:28 GMT (Thursday 11th January 2024)"
	revision: "15"

deferred class
	EL_YOUTUBE_STREAM

inherit
	ANY

	EL_MODULE_FILE_SYSTEM; EL_MODULE_FORMAT; EL_MODULE_LIO

	EL_ZSTRING_CONSTANTS

	EL_STRING_8_CONSTANTS

	EL_YOUTUBE_CONSTANTS

feature {NONE} -- Initialization

	make (info_line: ZSTRING)
		local
			basic_parts: EL_SPLIT_ZSTRING_LIST
		do
			make_default
			if attached new_info (info_line) as info
				and then (info.basic.count > 0 and info.detailed.count > 0)
			then
				create basic_parts.make (info.basic, ' ')
				parse (basic_parts)
				if code.count > 0 then
					description := new_description (basic_parts, info.detailed)
				end
			end
		end

	make_default
		do
			extension := Empty_string
			code := Empty_string_8
			create description.make_empty
		end

feature -- Access

	code: STRING

	data_rate: INTEGER

	data_rate_string: STRING
		do
			Result := Format.padded_integer (data_rate, Data_rate_digits) + "k"
		end

	description: ZSTRING

	extension: STRING

	extension_padded: STRING
		do
			create Result.make_filled (' ', 4 - extension.count)
			Result.prepend (extension)
		end

	extension_set: EL_HASH_SET [STRING]
		deferred
		end

	index: INTEGER

	index_string: STRING
		do
			Result := Format.padded_integer (index, 2) + "."
		end

	name: ZSTRING
		local
			parts: EL_ZSTRING_LIST
		do
			create parts.make_from_general (name_parts)
			Result := parts.joined_words
		end

	type: STRING
		deferred
		end

feature -- Status query

	has_code_qualifier: BOOLEAN
		do
			Result := code.ends_with ("-1")
		end

feature -- Element change

	set_extension (a_extension: STRING)
		do
			extension_set.put (a_extension)
			extension := extension_set.found_item
		end

	set_index (a_index: like index)
		do
			index := a_index
		end

feature {NONE} -- Implementation

	new_info (line: ZSTRING): TUPLE [basic, detailed: ZSTRING]
		-- Convert `line' as in example
		-- FROM: 249          webm       audio only tiny   46k , webm_dash container, opus  (48000Hz), 492.58KiB
		--   TO: basic: "249 webm audio-track 46k"; detailed: "opus  (48000Hz), 492.58KiB"; type: "Audio"
		local
			parts: EL_SPLIT_INTERVALS; pos: INTEGER
		do
			create parts.make_by_string (line, "k , ") -- split at 46k
			Result := [Empty_string, Empty_string]
			from parts.start until parts.after loop
				inspect parts.index
					when 1 then
						Result.basic := line.substring (parts.item_lower, parts.item_upper + 1)
					when 2 then
						pos := line.substring_index (Container, parts.item_lower)
						if pos > 0 then
							Result.detailed := line.substring (pos + Container.count + 2, parts.item_upper)
						else
							Result.detailed := line.substring (parts.item_lower, parts.item_upper)
						end
				else
				end
				parts.forth
			end
			Result.basic.to_canonically_spaced
			Result.detailed.to_canonically_spaced
		end

	parse (list: EL_SPLIT_ZSTRING_LIST)
		do
			from list.start until list.after loop
				inspect list.index
					when 1 then
						code := list.item_copy
					when 2 then
						set_extension (list.item)
					when 3 then
						parse_dimensions (list)

					when 4, 5 then
						if list.item_has ('k') then
							data_rate := list.item.substring_to ('k').to_integer
						end
				else
				end
				list.forth
			end
		end

feature {NONE} -- Deferred

	data_rate_digits: INTEGER
		deferred
		end

	name_parts: ARRAY [STRING]
		deferred
		end

	new_description (basic_parts: EL_SPLIT_ZSTRING_LIST; detailed: ZSTRING): ZSTRING
		deferred
		end

	parse_dimensions (list: EL_SPLIT_ZSTRING_LIST)
		deferred
		end

feature {NONE} -- Constants

	Container: STRING = "container"

end