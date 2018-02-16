note
	description: "Youtube stream channel info"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-02-12 15:06:17 GMT (Monday 12th February 2018)"
	revision: "1"

class
	YOUTUBE_STREAM_INFO

inherit
	EL_STRING_CONSTANTS

create
	make, make_default

feature {NONE} -- Initialization

	make (line: ZSTRING)
		local
			parts: EL_SPLIT_ZSTRING_LIST
		do
			make_default
			description := line.as_canonically_spaced
			create parts.make (description, Space_string)
			parts.start
			if parts.item.is_integer then
				from until parts.after loop
					inspect parts.index
						when 1 then
							code := parts.item.to_integer
						when 2 then
							extension := parts.item.twin
						when 3 then
							if parts.item ~ Audio then
								type := Audio
							elseif parts.item.has ('x') then
								resolution_x_y := parts.item.twin
								resolution_x := resolution_x_y.split ('x').first.to_integer
							end
					else
						if parts.item ~ Video then
							type := Video
						end
					end
					parts.forth
				end
			end
		end

	make_default
		do
			type := Empty_string
			extension := Empty_string
			resolution_x_y := Empty_string
			description := Empty_string
		end

feature -- Access

	code: INTEGER

	description: ZSTRING

	extension: ZSTRING

	last_output_path: EL_FILE_PATH

	resolution_x: INTEGER

	resolution_x_y: ZSTRING

	type: ZSTRING

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
