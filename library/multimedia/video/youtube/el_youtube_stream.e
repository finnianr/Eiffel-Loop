note
	description: "Youtube stream channel info"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "11"

class
	EL_YOUTUBE_STREAM

inherit
	ANY

	EL_MODULE_LIO

	EL_ZSTRING_CONSTANTS

	EL_YOUTUBE_CONSTANTS

	EL_MODULE_FILE_SYSTEM

create
	make, make_default

feature {NONE} -- Initialization

	make (a_url, info_line: ZSTRING)
		local
			parts: EL_SPLIT_ZSTRING_LIST
		do
			make_default
			url := a_url
			description := info_line
			create parts.make (info_line.as_canonically_spaced, ' ')
			parts.start
			if parts.item.is_integer then
				from until parts.after loop
					inspect parts.index
						when 1 then
							code := parts.natural_item
						when 2 then
							extension := parts.item_copy
						when 3 then
							if parts.item_same_as (Audio) then
								type := Audio
							elseif parts.item.has ('x') then
								resolution_x_y := parts.item_copy
								resolution_x := resolution_x_y.split_list ('x').first.to_integer
							end
					else
						if parts.item_same_as (Video) then
							type := Video
						end
					end
					parts.forth
				end
			end
		end

	make_default
		do
			url := Empty_string
			type := Empty_string
			extension := Empty_string
			resolution_x_y := Empty_string
			description := Empty_string
		end

feature -- Access

	code: NATURAL

	description: ZSTRING

	extension: ZSTRING

	resolution_x: INTEGER

	resolution_x_y: ZSTRING

	type: ZSTRING

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

feature {NONE} -- Constants

	Audio: ZSTRING
		once
			Result := "audio"
		end

	Video: ZSTRING
		once
			Result := "video"
		end

end