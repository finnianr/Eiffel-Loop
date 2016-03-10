note
	description: "Summary description for {EL_EYED3_TAG_TEST_APP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:31 GMT (Tuesday 2nd September 2014)"
	revision: "4"

class
	EL_EYED3_TAG_TEST_APP

inherit
	TEST_APPLICATION
		redefine
			Option_name, initialize
		end

	ID3_TAG_TEST

	EL_EYED3_VERSION_CONSTANTS

create
	make

feature {NONE} -- Initialization

	initialize
			--
		do
			Precursor
--			set_string_from_word_option ("mp3", agent set_mp3_path, "mp3/Song.ID3v2.3.mp3")
--			set_string_from_word_option ("mp3", agent set_mp3_path, "mp3/Song.unicode.ID3v2.2.mp3")

		end

feature -- Basic operations

	test_run
			--
		do
			read_version (2.3)
		end

	read_version (ver: REAL)
			--
		do
			log.enter_with_args ("read_version", << ver >>)
			Args.set_string_from_word_option ("mp3", agent set_mp3_path, "mp3/Song.ID3v" + ver.out + ".mp3")

			set_mp3_path_to_working_copy ("")

			if mp3_path.exists then
				create id3_tag.make (mp3_path.to_string.to_latin1)
				id3_tag.set_title (id3_tag.title + " (MODIFIED)")
--				log.put_real_field ("VERSION", id3_tag.version)
--				log.put_new_line
				log.put_string_field ("TITLE", id3_tag.title)
				log.put_new_line
				log.put_string_field ("ARTIST", id3_tag.artist)
				log.put_new_line
				log.put_string_field ("GENRE", id3_tag.genre)
				log.put_new_line
				log.put_integer_field ("YEAR", id3_tag.year)
				log.put_new_line
				id3_tag.update (ID3_V2_3)

			end
			log.exit
		end

feature {NONE} -- Implementation

	id3_tag: EL_EYED3_TAG

feature {NONE} -- Constants

	Option_name: STRING = "eyeD3"

	Description: STRING = "Test class EL_EYED3_TAG"

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := <<
				[{EL_EYED3_TAG_TEST_APP}, All_routines]
--				[{EL_EYED3_TAG}, All_routines]
			>>
		end

end
