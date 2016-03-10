note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-01-01 14:17:41 GMT (Thursday 1st January 2015)"
	revision: "5"

class
	SMIL_PRESENTATION

inherit
	EL_BUILDABLE_XML_FILE_PERSISTENT
		rename
			make_default as make
		redefine
			make, building_action_table, getter_function_table, PI_building_action_table,
			on_context_exit
		end

	EL_MODULE_LOG
		undefine
			default_create
		end

	EL_MODULE_URL
		undefine
			default_create
		end

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
			create location
		end

feature -- Access

	audio_sequence: ARRAYED_LIST [SMIL_AUDIO_SEQUENCE]

	title: STRING

	author: STRING

	location: EL_DIR_PATH

feature {NONE} -- Evolicity fields

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["to_xml",				agent to_xml],
				["author",				agent: STRING do Result := author end],
				["title", 				agent: STRING do Result := title end],
				["location", 			agent: STRING do Result := location.to_string end],
				["audio_sequence",	agent: ITERABLE [SMIL_AUDIO_SEQUENCE] do Result := audio_sequence end]
			>>)
		end

feature {NONE} -- Build from XML

	extend_audio_sequence
			--
		do
			log.enter ("extend_audio_sequence")
			audio_sequence.extend (create {SMIL_AUDIO_SEQUENCE}.make)
			set_next_context (audio_sequence.last)
			log.exit
		end

	on_create
			--
		do
			log.enter ("on_create")
			log.put_line (node.to_string)
			log.exit
		end

	on_context_exit
		do
			log.enter ("on_context_exit")
			log.put_string_field ("Presentation", title); log.put_new_line
			log.put_string_field ("author", author); log.put_new_line
			log.put_string_field ("location", location.to_string); log.put_new_line
			log.exit
		end

	building_action_table: like Type_building_actions
			-- Nodes relative to root element: smil
		do
			create Result.make (<<
				["head/meta[@name='title']/@content", agent do title := node.to_string end],
				["head/meta[@name='author']/@content", agent do author := node.to_string end],
				["head/meta[@name='base']/@content", agent
					do
						location := URL.remove_protocol_prefix (node.to_string)
						location.base.prune_all_trailing ('/')
					end
				],
--				["body/seq[@id='seq_1']", agent extend_audio_sequence],
				["body/seq", agent extend_audio_sequence]
			>>)
		end

	PI_building_action_table: like Type_building_actions
			--
		do
			create Result.make (<<
				["processing-instruction('create')", agent on_create]
			>>)
		end

	Root_node_name: STRING = "smil"

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
