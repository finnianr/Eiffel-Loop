note
	description: "Youtube video stream channel info"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-20 9:00:33 GMT (Friday 20th September 2024)"
	revision: "5"

class
	EL_YOUTUBE_VIDEO_STREAM

inherit
	EL_YOUTUBE_STREAM
		rename
			type as Video_type
		redefine
			make_default, new_info
		end

create
	make, make_default

feature {NONE} -- Initialization

	make_default
		do
			Precursor
			resolution := [0, 0, Empty_string_8]
		end

feature -- Access

	resolution: TUPLE [x, y: INTEGER; x_y_string: STRING]

	video_height: STRING
		do
			Result := Format.padded_integer (resolution.y, 4) + "h"
		end

	video_width: STRING
		do
			Result := Format.padded_integer (resolution.x, 4) + "w"
		end

feature {NONE} -- Implementation

	name_parts: ARRAY [STRING]
		do
			Result := << index_string, extension_padded, video_width, video_height, data_rate_string >>
		end

	new_description (basic_parts: EL_SPLIT_ZSTRING_LIST; detailed: ZSTRING): ZSTRING
		local
			parts_list: EL_ZSTRING_LIST; padding: ZSTRING; p_index: INTEGER
		do
			parts_list := detailed
			parts_list.start
			if not parts_list.after then
				parts_list.item.enclose ('(', ')') -- Eg. avc1.42001E -> (avc1.42001E)
			end
			if attached basic_parts as list then
--				prepend everything from 4th position onwards
				from list.finish until list.before loop
					if list.index > 3 and list.index /= 5 then
						parts_list.put_front (list.item_copy)
					end
					list.back
				end
			end
			if attached parts_list.first as point_size then
				p_index := point_size.index_of ('p', 1)
				if p_index > 0 and p_index < point_size.count then
					point_size.keep_head (p_index)
				end
				create padding.make_filled (' ', (5 - point_size.count).max (0))
				Result := padding + parts_list.joined_with_string (", ")
			else
				create Result.make_empty
			end
		end

	new_info (line: ZSTRING): TUPLE [basic, detailed: ZSTRING]
		do
			Result := Precursor (line)
			Result.detailed.replace_substring_all (", video only", " video")
		end

	parse_dimensions (list: EL_SPLIT_ZSTRING_LIST)
		do
			if list.item_has ('x') then
				resolution.x_y_string := list.item_copy
				if attached resolution.x_y_string.split ('x') as split
					and then split.count = 2
				then
					resolution.x := split.first.to_integer
					resolution.y := split.last.to_integer
				end
			end
		end

feature {NONE} -- Constants

	Data_rate_digits: INTEGER = 5

	Extension_set: EL_HASH_SET [STRING]
		once
			create Result.make_equal (3)
		end

end