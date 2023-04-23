note
	description: "Youtube audio stream channel info"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-04-23 18:05:28 GMT (Sunday 23rd April 2023)"
	revision: "1"

class
	EL_YOUTUBE_AUDIO_STREAM

inherit
	EL_YOUTUBE_STREAM
		redefine
			new_info
		end

create
	make, make_default

feature {NONE} -- Implementation

	name_parts: ARRAY [STRING]
		do
			Result := << index_string, extension_padded, type, data_rate_string >>
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
			Result.basic.replace_substring_all ("audio only tiny", type)
		end

	parse_dimensions (list: EL_SPLIT_ZSTRING_LIST)
		do
		end

feature {NONE} -- Constants

	Data_rate_digits: INTEGER = 3

	Type: STRING = "audio"

end