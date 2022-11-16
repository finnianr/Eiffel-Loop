note
	description: "Enumeration `TagLib::ID3v2::AttachedPictureFrame::Type' from header `attachedpictureframe.h'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "7"

class
	TL_PICTURE_TYPE_ENUM

inherit
	EL_ENUMERATION [NATURAL_8]
		rename
			foreign_naming as English
		export
			{NONE} all
			{ANY} value, is_valid_value, name, list
		redefine
			initialize_fields
		end

create
	make

feature {NONE} -- Initialization

	initialize_fields
		do
			artist := 0x08
			back_cover := 0x04
			band := 0x0A
			band_logo := 0x13
			coloured_fish := 0x11
			composer := 0x0B
			conductor := 0x09
			during_performance := 0x0F
			during_recording := 0x0E
			file_icon := 0x01
			front_cover := 0x03
			illustration := 0x12
			lead_artist := 0x07
			leaflet_page := 0x05
			lyricist := 0x0C
			media := 0x06
			movie_screen_capture := 0x10
			other := 0x00
			other_file_icon := 0x02
			publisher_logo := 0x14
			recording_location := 0x0D
		end

feature -- Access

	artist: NATURAL_8
		-- Picture of the artist or performer

	back_cover : NATURAL_8
		-- Back cover image of the album

	band: NATURAL_8
		-- Picture of the band or orchestra

	band_logo: NATURAL_8
		-- Logo of the band or performer

	coloured_fish: NATURAL_8
		-- Picture of a large, coloured fish

	composer: NATURAL_8
		-- Picture of the composer

	conductor: NATURAL_8
		-- Picture of the conductor

	during_performance: NATURAL_8
		-- Picture of the artists during performance

	during_recording: NATURAL_8
		-- Picture of the artists during recording

	file_icon: NATURAL_8
		-- 32x32 PNG image that should be used as the file icon

	front_cover: NATURAL_8
		-- Front cover image of the album

	illustration: NATURAL_8
		-- Illustration related to the track

	lead_artist: NATURAL_8
		-- Picture of the lead artist or soloist

	leaflet_page: NATURAL_8
		-- Inside leaflet page of the album

	lyricist: NATURAL_8
		-- Picture of the lyricist or text writer

	media: NATURAL_8
		-- Image from the album itself

	movie_screen_capture: NATURAL_8
		-- Picture from a movie or video related to the track

	other: NATURAL_8
		-- A type not enumerated below

	other_file_icon: NATURAL_8
		-- File icon of a different size or format

	publisher_logo: NATURAL_8
		-- Logo of the publisher (record company)

	recording_location: NATURAL_8
		-- Picture of the recording location or studio

feature {NONE} -- Constants

	English: EL_ENGLISH_NAME_TRANSLATER
		once
			create Result.make
		end
end