note
	description: "Youtube audio stream channel info"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-20 9:15:22 GMT (Friday 20th September 2024)"
	revision: "4"

class
	EL_YOUTUBE_AUDIO_STREAM

inherit
	EL_YOUTUBE_STREAM
		rename
			type as Audio_type
		redefine
			new_info
		end

create
	make, make_default

feature {NONE} -- Implementation

	name_parts: ARRAY [STRING]
		do
			Result := << index_string, extension_padded, Audio_type, data_rate_string >>
		end

	new_description (basic_parts: EL_SPLIT_ZSTRING_LIST; detailed: ZSTRING): ZSTRING
		local
			parts_list: EL_ZSTRING_LIST
		do
			parts_list := detailed
			if attached basic_parts as list then
--				prepend everything from 4th position onwards
				from list.finish until list.before loop
					if list.index > 4 then
						parts_list.put_front (list.item_copy)
					end
					list.back
				end
			end
			Result := parts_list.joined_with_string (", ")
		end

	new_info (line: ZSTRING): TUPLE [basic, detailed: ZSTRING]
		do
			Result := Precursor (line)
			Result.basic.replace_substring_all ("audio only tiny", Audio_type)
		end

	parse_dimensions (list: EL_SPLIT_ZSTRING_LIST)
		do
		end

feature {NONE} -- Constants

	Extension_set: EL_HASH_SET [STRING]
		once
			create Result.make_equal (3)
		end

	Data_rate_digits: INTEGER = 3

end