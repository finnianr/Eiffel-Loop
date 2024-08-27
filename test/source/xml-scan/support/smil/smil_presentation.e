note
	description: "SMIL presentation"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-27 7:52:12 GMT (Tuesday 27th August 2024)"
	revision: "18"

class
	SMIL_PRESENTATION

inherit
	EL_FILE_PERSISTENT_BUILDABLE_FROM_XML
		rename
			make_default as make
		redefine
			make, building_action_table, getter_function_table, PI_building_action_table,
			on_context_exit
		end

	OUTPUT_ROUTINES

create
	make_from_file, make_from_string, make

feature {NONE} -- Initialization

	make
			--
		do
			Precursor
			create audio_sequence.make (7)
			create title.make_empty

			create author.make_empty
			create location.make_empty
		end

feature -- Access

	audio_sequence: ARRAYED_LIST [SMIL_AUDIO_SEQUENCE]

	title: STRING

	author: STRING

	location: EL_URI

feature {NONE} -- Evolicity fields

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["to_xml",				agent to_xml],
				["author",				agent: STRING do Result := author end],
				["title", 				agent: STRING do Result := title end],
				["location", 			agent: STRING do Result := location end],
				["audio_sequence",	agent: ITERABLE [SMIL_AUDIO_SEQUENCE] do Result := audio_sequence end]
			>>)
		end

feature {NONE} -- Build from XML

	extend_audio_sequence
			--
		do
			audio_sequence.extend (create {SMIL_AUDIO_SEQUENCE}.make)
			log_extend ("audio_sequence", audio_sequence)
			set_next_context (audio_sequence.last)
		end

	on_create
			--
		do
			lio.put_labeled_string ("on_create node.to_string", node.to_string)
			lio.put_new_line
		end

	on_context_exit
		do
			lio.put_line ("on_context_exit")
			lio.put_string_field ("Presentation", title); lio.put_new_line
			lio.put_string_field ("author", author); lio.put_new_line
			lio.put_path_field ("location", location.to_dir_uri_path)
			lio.put_new_line_x2
		end

	building_action_table: EL_PROCEDURE_TABLE [STRING]
			-- Nodes relative to root element: smil
		do
			create Result.make (<<
				["head/meta[@name='title']/@content", agent do node.set_8 (title) end],
				["head/meta[@name='author']/@content", agent do node.set_8 (author) end],
				["head/meta[@name='base']/@content", agent
					do
						location := node.to_string_8; location.prune_all_trailing ('/')
					end
				],
--				["body/seq[@id='seq_1']", agent extend_audio_sequence],
				["body/seq", agent extend_audio_sequence]
			>>)
		end

	PI_building_action_table: EL_PROCEDURE_TABLE [STRING]
			--
		do
			create Result.make (<<
				["create", agent on_create]
			>>)
		end

feature {NONE} -- Constants

	Template: STRING =
		-- Substitution template

		--| Despite appearances the tab level is 0
		--| All leading tabs are removed by Eiffel compiler to match the first line
	"[
		<?xml version="1.0" encoding="$encoding_name"?>
		<?create {SMIL_PRESENTATION}?>
		<smil xmlns="http://www.w3.org/2001/SMIL20/Language">
			<head>
				<meta name="base" content="file://$location"/>
				<meta name="author" content="$author"/>
				<meta name="title" content="$title"/>
			</head>
			<body>
		#if $audio_sequence.count > 0 then	
			#foreach $sequence in $audio_sequence.audio_clip_list loop
				<seq id="seq_$sequence.id" title="$sequence.title">
				#if $sequence.audio_clip_list.count > 0 then	
					#foreach $clip in $sequence.audio_clip_list loop
					<audio id="audio_$clip.id" src="$clip.source" title="$clip.title" clipBegin="${clip.onset}s" clipEnd="${clip.offset}s"/>
					#end
				#end
				</seq>
			#end
		#end
			</body>
		</smil>
	]"


end