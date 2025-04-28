note
	description: "[
		Combined frame ID enumeration codes for ID3 versions: 2.2.0, 2.3.0, 2.4.0
	]"
	notes: "[
		Enumerations are generated from extract of ID3 specification by ${ID3_FRAME_CODE_CLASS_GENERATOR_APP}
		from cluster [./tool/eiffel/eiffel.root.html eiffel.ecf#root]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-28 17:28:31 GMT (Monday 28th April 2025)"
	revision: "17"

class
	TL_FRAME_ID_ENUM

inherit
	EL_ENUMERATION_NATURAL_8
		rename
			new_table_text as Empty_text,
			foreign_naming as Snake_case_upper
		export
			{NONE} all
			{ANY} value, valid_value, name
		end

create
	make

feature -- Codes A

	AENC: NATURAL_8
		-- Audio encryption

	APIC: NATURAL_8
		-- Attached picture

	ASPI: NATURAL_8
		-- Audio seek point index

feature -- Codes C

	COMM: NATURAL_8
		-- Comments

	COMR: NATURAL_8
		-- Commercial frame

feature -- Codes E

	ENCR: NATURAL_8
		-- Encryption method registration

	EQU2: NATURAL_8
		-- Equalisation (2)

	EQUA: NATURAL_8
		-- Equalization

	ETCO: NATURAL_8
		-- Event timing codes

feature -- Codes C

	GEOB: NATURAL_8
		-- General encapsulated object

	GRID: NATURAL_8
		-- Group identification registration

feature -- Codes I

	IPLS: NATURAL_8
		-- Involved people list

feature -- Codes L

	LINK: NATURAL_8
		-- Linked information

feature -- Codes M

	MCDI: NATURAL_8
		-- Music CD identifier

	MLLT: NATURAL_8
		-- MPEG location lookup table

feature -- Codes O

	OWNE: NATURAL_8
		-- Ownership frame

feature -- Codes P

	PCNT: NATURAL_8
		-- Play counter

	POPM: NATURAL_8
		-- Popularimeter

	POSS: NATURAL_8
		-- Position synchronisation frame

	PRIV: NATURAL_8
		-- Private frame

feature -- Codes R

	RBUF: NATURAL_8
		-- Recommended buffer size

	RVA2: NATURAL_8
		-- Relative volume adjustment (2)

	RVAD: NATURAL_8
		-- Relative volume adjustment

	RVRB: NATURAL_8
		-- Reverb

feature -- Codes S

	SEEK: NATURAL_8
		-- Seek frame

	SIGN: NATURAL_8
		-- Signature frame

	SYLT: NATURAL_8
		-- Synchronized lyric/text

	SYTC: NATURAL_8
		-- Synchronized tempo codes

feature -- Codes T

	TALB: NATURAL_8
		-- Album/Movie/Show title

	TBPM: NATURAL_8
		-- BPM (beats per minute)

	TCOM: NATURAL_8
		-- Composer

	TCON: NATURAL_8
		-- Content type

	TCOP: NATURAL_8
		-- Copyright message

	TDAT: NATURAL_8
		-- Date

	TDEN: NATURAL_8
		-- Encoding time

	TDLY: NATURAL_8
		-- Playlist delay

	TDOR: NATURAL_8
		-- Original release time

	TDRC: NATURAL_8
		-- Recording time

	TDRL: NATURAL_8
		-- Release time

	TDTG: NATURAL_8
		-- Tagging time

	TENC: NATURAL_8
		-- Encoded by

	TEXT: NATURAL_8
		-- Lyricist/Text writer

	TFLT: NATURAL_8
		-- File type

	TIME: NATURAL_8
		-- Time

	TIPL: NATURAL_8
		-- Involved people list

	TIT1: NATURAL_8
		-- Content group description

	TIT2: NATURAL_8
		-- Title/songname/content description

	TIT3: NATURAL_8
		-- Subtitle/Description refinement

	TKEY: NATURAL_8
		-- Initial key

	TLAN: NATURAL_8
		-- Language(s)

	TLEN: NATURAL_8
		-- Length

	TMCL: NATURAL_8
		-- Musician credits list

	TMED: NATURAL_8
		-- Media type

	TMOO: NATURAL_8
		-- Mood

	TOAL: NATURAL_8
		-- Original album/movie/show title

	TOFN: NATURAL_8
		-- Original filename

	TOLY: NATURAL_8
		-- Original lyricist(s)/text writer(s)

	TOPE: NATURAL_8
		-- Original artist(s)/performer(s)

	TORY: NATURAL_8
		-- Original release year

	TOWN: NATURAL_8
		-- File owner/licensee

	TPE1: NATURAL_8
		-- Lead performer(s)/Soloist(s)

	TPE2: NATURAL_8
		-- Band/orchestra/accompaniment

	TPE3: NATURAL_8
		-- Conductor/performer refinement

	TPE4: NATURAL_8
		-- Interpreted, remixed, or otherwise modified by

	TPOS: NATURAL_8
		-- Part of a set

	TPRO: NATURAL_8
		-- Produced notice

	TPUB: NATURAL_8
		-- Publisher

	TRCK: NATURAL_8
		-- Track number/Position in set

	TRDA: NATURAL_8
		-- Recording dates

	TRSN: NATURAL_8
		-- Internet radio station name

	TRSO: NATURAL_8
		-- Internet radio station owner

	TSIZ: NATURAL_8
		-- Size

	TSOA: NATURAL_8
		-- Album sort order

	TSOP: NATURAL_8
		-- Performer sort order

	TSOT: NATURAL_8
		-- Title sort order

	TSRC: NATURAL_8
		-- ISRC (international standard recording code)

	TSSE: NATURAL_8
		-- Software/Hardware and settings used for encoding

	TSST: NATURAL_8
		-- Set subtitle

	TXXX: NATURAL_8
		-- User defined text information frame

	TYER: NATURAL_8
		-- Year

feature -- Codes U

	UFID: NATURAL_8
		-- Unique file identifier

	USER: NATURAL_8
		-- Terms of use

	USLT: NATURAL_8
		-- Unsychronized lyric/text transcription

feature -- Codes W

	WCOM: NATURAL_8
		-- Commercial information

	WCOP: NATURAL_8
		-- Copyright/Legal information

	WOAF: NATURAL_8
		-- Official audio file webpage

	WOAR: NATURAL_8
		-- Official artist/performer webpage

	WOAS: NATURAL_8
		-- Official audio source webpage

	WORS: NATURAL_8
		-- Official internet radio station homepage

	WPAY: NATURAL_8
		-- Payment

	WPUB: NATURAL_8
		-- Publishers official webpage

	WXXX: NATURAL_8
		-- User defined URL link frame

feature {NONE} -- Constants

	Snake_case_upper: EL_SNAKE_CASE_TRANSLATER
		once
			Result := {EL_CASE}.Upper
		end
end