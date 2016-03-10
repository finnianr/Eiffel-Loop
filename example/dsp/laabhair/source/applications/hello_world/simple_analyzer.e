indexing
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:19 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	SIMPLE_ANALYZER

inherit
	LB_AUDIO_CLIP_ANALYZER
		redefine
			make, set_praat_script_variables
		end
		
	HELLO_WORLD_SHARED_CONFIGURATION
	
create
	make

feature {NONE} -- Initialization

	make (flash_remote_procedure_invoker: like Result_consumer_type) is
			--
		do
			Precursor (flash_remote_procedure_invoker)
			
			create flash_message_display.make (flash_RPC_request_queue)
			
			Config.register_change_action (
				<< Config.counter_start >>, agent set_counter_start
			)

			Config.register_change_action (
				<< Config.script_file_name >>, agent set_praat_script
			)
		end

feature {NONE} -- Element change

	set_praat_script is
			--
		do
			set_praat_script_from_file (Config.script_file_name.item)
		end

	set_counter_start is
			--
		do
			log.enter ("set_counter_start")
			sample_count := Config.counter_start.item
			log.exit
		end
		
feature {NONE} -- Implementation
	
	set_praat_script_variables is
			--
		do
			Precursor
			-- Note: Praat does not allow variable names that start with uppercase
			praat_assign_integer ("sample_count", sample_count)
		end

	Default_praat_script: STRING is "[
	
		Read from file... 'audio_file_path$'
		sound$ = selected$ ("Sound")
						
		message$ = "Hello world! ('sound$'.wav)"
		sample_count = sample_count + 1
		intensity_db = Get intensity (dB)
		
		select all
		Remove
		
	]"
	
	on_script_executed (script_ctx: EL_PRAAT_SCRIPT_CONTEXT) is
			--
		local
			message: STRING
			intensity_db: INTEGER
		do
			log.enter ("on_script_executed")
			message := script_ctx.string_variable ("message$")
			sample_count := script_ctx.integer_variable ("sample_count")
			intensity_db := script_ctx.integer_variable ("intensity_db")
			
			flash_message_display.display (message, sample_count, intensity_db)
			log.put_integer_field ("Number of samples analyzed", sample_count)
			log.put_new_line

			log.exit
		end

	flash_message_display: MESSAGE_DISPLAY_PROXY
	
	sample_count: INTEGER
	
end


