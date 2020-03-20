note
	description: "[
		Combined frame ID enumeration codes for ID3 versions: 2.2.0, 2.3.0, 2.4.0
	]"
	notes: "[
		Enumerations are generated from extract of ID3 specification by [$source ID3_FRAME_ENUM_GENERATOR_APP]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-20 9:56:11 GMT (Friday 20th March 2020)"
	revision: "4"

class
	TL_FRAME_ID_ENUM

inherit
	EL_ENUMERATION [NATURAL_8]
		rename
			import_name as from_upper_snake_case,
			export_name as to_upper_snake_case
		export
			{NONE} all
			{ANY} value, is_valid_value, name
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

feature -- Codes B

	BUF: NATURAL_8
		-- Recommended buffer size

	CNT: NATURAL_8
		-- Play counter

feature -- Codes C

	COM: NATURAL_8
		-- Comments

	COMM: NATURAL_8
		-- Comments

	COMR: NATURAL_8
		-- Commercial frame

	CRA: NATURAL_8
		-- Audio encryption

	CRM: NATURAL_8
		-- Encrypted meta frame

feature -- Codes E

	ENCR: NATURAL_8
		-- Encryption method registration

	EQU: NATURAL_8
		-- Equalization

	EQU2: NATURAL_8
		-- Equalisation (2)

	EQUA: NATURAL_8
		-- Equalization

	ETC: NATURAL_8
		-- Event timing codes

	ETCO: NATURAL_8
		-- Event timing codes

feature -- Codes C

	GEO: NATURAL_8
		-- General encapsulated object

	GEOB: NATURAL_8
		-- General encapsulated object

	GRID: NATURAL_8
		-- Group identification registration

feature -- Codes I

	IPL: NATURAL_8
		-- Involved people list

	IPLS: NATURAL_8
		-- Involved people list

feature -- Codes L

	LINK: NATURAL_8
		-- Linked information

	LNK: NATURAL_8
		-- Linked information

feature -- Codes M

	MCDI: NATURAL_8
		-- Music CD identifier

	MCI: NATURAL_8
		-- Music CD Identifier

	MLL: NATURAL_8
		-- MPEG location lookup table

	MLLT: NATURAL_8
		-- MPEG location lookup table

feature -- Codes O

	OWNE: NATURAL_8
		-- Ownership frame

feature -- Codes P

	PCNT: NATURAL_8
		-- Play counter

	PIC: NATURAL_8
		-- Attached picture

	POP: NATURAL_8
		-- Popularimeter

	POPM: NATURAL_8
		-- Popularimeter

	POSS: NATURAL_8
		-- Position synchronisation frame

	PRIV: NATURAL_8
		-- Private frame

feature -- Codes R

	RBUF: NATURAL_8
		-- Recommended buffer size

	REV: NATURAL_8
		-- Reverb

	RVA: NATURAL_8
		-- Relative volume adjustment

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

	SLT: NATURAL_8
		-- Synchronized lyric/text

	STC: NATURAL_8
		-- Synced tempo codes

	SYLT: NATURAL_8
		-- Synchronized lyric/text

	SYTC: NATURAL_8
		-- Synchronized tempo codes

feature -- Codes T

	TAL: NATURAL_8
		-- Album/Movie/Show title

	TALB: NATURAL_8
		-- Album/Movie/Show title

	TBP: NATURAL_8
		-- BPM (Beats Per Minute)

	TBPM: NATURAL_8
		-- BPM (beats per minute)

	TCM: NATURAL_8
		-- Composer

	TCO: NATURAL_8
		-- Content type

	TCOM: NATURAL_8
		-- Composer

	TCON: NATURAL_8
		-- Content type

	TCOP: NATURAL_8
		-- Copyright message

	TCR: NATURAL_8
		-- Copyright message

	TDA: NATURAL_8
		-- Date

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

	TDY: NATURAL_8
		-- Playlist delay

	TEN: NATURAL_8
		-- Encoded by

	TENC: NATURAL_8
		-- Encoded by

	TEXT: NATURAL_8
		-- Lyricist/Text writer

	TFLT: NATURAL_8
		-- File type

	TFT: NATURAL_8
		-- File type

	TIM: NATURAL_8
		-- Time

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

	TKE: NATURAL_8
		-- Initial key

	TKEY: NATURAL_8
		-- Initial key

	TLA: NATURAL_8
		-- Language(s)

	TLAN: NATURAL_8
		-- Language(s)

	TLE: NATURAL_8
		-- Length

	TLEN: NATURAL_8
		-- Length

	TMCL: NATURAL_8
		-- Musician credits list

	TMED: NATURAL_8
		-- Media type

	TMOO: NATURAL_8
		-- Mood

	TMT: NATURAL_8
		-- Media type

	TOA: NATURAL_8
		-- Original artist(s)/performer(s)

	TOAL: NATURAL_8
		-- Original album/movie/show title

	TOF: NATURAL_8
		-- Original filename

	TOFN: NATURAL_8
		-- Original filename

	TOL: NATURAL_8
		-- Original Lyricist(s)/text writer(s)

	TOLY: NATURAL_8
		-- Original lyricist(s)/text writer(s)

	TOPE: NATURAL_8
		-- Original artist(s)/performer(s)

	TOR: NATURAL_8
		-- Original release year

	TORY: NATURAL_8
		-- Original release year

	TOT: NATURAL_8
		-- Original album/Movie/Show title

	TOWN: NATURAL_8
		-- File owner/licensee

	TP1: NATURAL_8
		-- Lead artist(s)/Lead performer(s)/Soloist(s)/Performing group

	TP2: NATURAL_8
		-- Band/Orchestra/Accompaniment

	TP3: NATURAL_8
		-- Conductor/Performer refinement

	TP4: NATURAL_8
		-- Interpreted, remixed, or otherwise modified by

	TPA: NATURAL_8
		-- Part of a set

	TPB: NATURAL_8
		-- Publisher

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

	TRC: NATURAL_8
		-- ISRC (International Standard Recording Code)

	TRCK: NATURAL_8
		-- Track number/Position in set

	TRD: NATURAL_8
		-- Recording dates

	TRDA: NATURAL_8
		-- Recording dates

	TRK: NATURAL_8
		-- Track number/Position in set

	TRSN: NATURAL_8
		-- Internet radio station name

	TRSO: NATURAL_8
		-- Internet radio station owner

	TSI: NATURAL_8
		-- Size

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

	TSS: NATURAL_8
		-- Software/hardware and settings used for encoding

	TSSE: NATURAL_8
		-- Software/Hardware and settings used for encoding

	TSST: NATURAL_8
		-- Set subtitle

	TT1: NATURAL_8
		-- Content group description

	TT2: NATURAL_8
		-- Title/Songname/Content description

	TT3: NATURAL_8
		-- Subtitle/Description refinement

	TXT: NATURAL_8
		-- Lyricist/text writer

	TXX: NATURAL_8
		-- User defined text information frame

	TXXX: NATURAL_8
		-- User defined text information frame

	TYE: NATURAL_8
		-- Year

	TYER: NATURAL_8
		-- Year

feature -- Codes U

	UFI: NATURAL_8
		-- Unique file identifier

	UFID: NATURAL_8
		-- Unique file identifier

	ULT: NATURAL_8
		-- Unsychronized lyric/text transcription

	USER: NATURAL_8
		-- Terms of use

	USLT: NATURAL_8
		-- Unsychronized lyric/text transcription

feature -- Codes W

	WAF: NATURAL_8
		-- Official audio file webpage

	WAR: NATURAL_8
		-- Official artist/performer webpage

	WAS: NATURAL_8
		-- Official audio source webpage

	WCM: NATURAL_8
		-- Commercial information

	WCOM: NATURAL_8
		-- Commercial information

	WCOP: NATURAL_8
		-- Copyright/Legal information

	WCP: NATURAL_8
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

	WPB: NATURAL_8
		-- Publishers official webpage

	WPUB: NATURAL_8
		-- Publishers official webpage

	WXX: NATURAL_8
		-- User defined URL link frame

	WXXX: NATURAL_8
		-- User defined URL link frame

end
