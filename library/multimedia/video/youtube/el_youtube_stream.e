note
	description: "Youtube stream channel info"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-04-22 10:36:01 GMT (Saturday 22nd April 2023)"
	revision: "12"

class
	EL_YOUTUBE_STREAM

inherit
	ANY

	EL_MODULE_FILE_SYSTEM; EL_MODULE_LIO

	EL_ZSTRING_CONSTANTS

	EL_STRING_8_CONSTANTS

	EL_YOUTUBE_CONSTANTS


create
	make, make_default

feature {NONE} -- Initialization

	make (a_url, info_line: ZSTRING)
		local
			part_list: EL_SPLIT_ZSTRING_LIST
		do
			make_default
			url := a_url
			create part_list.make (info_line.as_canonically_spaced, ' ')
			parse (part_list)
			if code > 0 then
				set_name_description (part_list)
			end
		end

	make_default
		do
			url := Empty_string
			type := Empty_string_8
			extension := Empty_string
			resolution_x_y := Empty_string
			create description.make_empty
			create name.make_empty
		end

feature -- Access

	code: NATURAL

	description: ZSTRING

	extension: ZSTRING

	name: ZSTRING

	resolution_x: INTEGER

	resolution_x_y: ZSTRING

	type: STRING

	url: ZSTRING

feature -- Status query

	is_audio: BOOLEAN
		do
			Result := type = Audio
		end

	is_video: BOOLEAN
		do
			Result := type = Video
		end

feature {NONE} -- Implementation

	parse (list: EL_SPLIT_ZSTRING_LIST)
		do
			list.start
			if list.item.is_integer then
				from until list.after loop
					inspect list.index
						when 1 then
							code := list.natural_item
						when 2 then
							extension := list.item_copy
						when 3 then
							if list.item_same_as (Audio) then
								type := Audio
							elseif list.item.has ('x') then
								resolution_x_y := list.item_copy
								resolution_x := resolution_x_y.split_list ('x').first.to_integer
							end
					else
						if list.item_same_as (Video) then
							type := Video
						end
					end
					list.forth
				end
			end
		end

	set_name_description (list: EL_SPLIT_ZSTRING_LIST)
		local
			i, col_width, padding_count: INTEGER; str: ZSTRING
		do
			from list.start until list.after loop
				col_width := 0
				inspect list.index
					when 1 then
						str := name
					when 2 then
						str := name; col_width := 4
					when 3 then
						str := name
						if is_video then
							col_width := 9
						end
				else
					str := description
				end
				if str.count > 0 then
					str.append_character (' ')
				end
				list.append_item_to (str)
				if col_width > 0 then
					padding_count := col_width - list.item_count
					from i := 1 until i > padding_count loop
						str.append_character (' ')
						i := i + 1
					end
				end
				list.forth
			end
			description.replace_substring_all (" ,", ",")
		end

feature {NONE} -- Constants

	Audio: STRING = "audio"

	Video: STRING = "video"

end