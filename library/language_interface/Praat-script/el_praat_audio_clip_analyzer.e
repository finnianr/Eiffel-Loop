note
	description: "Invokes praat analysis engine with using default script"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:28 GMT (Sunday 16th December 2012)"
	revision: "1"

deferred class
	EL_PRAAT_AUDIO_CLIP_ANALYZER [RESULT_TYPE]

inherit
	EL_CONSUMER_THREAD [STRING]
		rename
			make as make_consumer_thread,
			consume_product as analyze_audio_clip,
			product as audio_clip_name,
			exit as thread_exit
		redefine
			execute
		end

	EL_DIRECTORY_CONSTANTS
		export
			{NONE} all
		end

	EL_LOGGING
		rename
			sleep as sleep_nanosecs
		undefine
			sleep_nanosecs, thread_exit
		end

	EL_AUDIO_CLIP_SAVER_CONSTANTS

feature -- Initialization

	make (result_consumer: like Result_consumer_type)
			--
		do
			make_consumer_thread
			create result_queue.make
			create initialized_praat_script.make (Default_praat_script.count + 30)
			create audio_file_path.make (Temp_directory_name.count)
			praat_script := Default_praat_script

			result_queue.attach_consumer (result_consumer)
		end

feature -- Element change

	set_praat_script_from_file (a_file_name: STRING)
			-- If configuration script file name is set to "default" then set script to default
			-- else read it from the script file
		local
			script_file: PLAIN_TEXT_FILE
		do
			if a_file_name.is_equal (Default_script_file_name) then
				praat_script := Default_praat_script
			else
				create script_file.make_open_read (a_file_name)
				script_file.read_stream (script_file.count)
				praat_script := script_file.last_string
				script_file.close
			end
		end

feature {NONE} -- Basic operations

	analyze_audio_clip
			-- Analyse chunk when prompted
		do
			log.enter_with_args ("analyze_audio_clip", << audio_clip_name >>)

			if audio_clip_name /= Silent_clip_name then
				initialized_praat_script.clear_all
				set_praat_script_variables

				initialized_praat_script.append (praat_script)

				call_praat_script

				if not script_interpreter.script_had_error then
					on_script_executed (script_interpreter)
				else
					log.put_line ("Error in script!")
				end
			else
				on_silent_clip
			end
			log.exit
		end

	call_praat_script
			--
		local
			file: RAW_FILE
		do
			log.enter ("call_praat_script")
			log.set_timer
			log.put_string_field_to_max_length (
				"SCRIPT:", initialized_praat_script, initialized_praat_script.count
			)
			log.put_new_line

			script_interpreter.execute (initialized_praat_script)

			create file.make (audio_file_path)
			file.delete

			if not script_interpreter.script_had_error then
				log.put_elapsed_time
			end
			log.exit
		end

	set_praat_script_variables
			--
		do
			-- Set path to audio sample clip
			audio_file_path.clear_all
			audio_file_path.append (Temp_directory_name)
			audio_file_path.append_character ('\')
			audio_file_path.append (audio_clip_name)

			praat_assign_string ("audio_file_path$", audio_file_path)

		end


	on_script_executed (script_ctx: EL_PRAAT_SCRIPT_CONTEXT)
			--
		deferred
		end

	on_silent_clip
			-- audio_clip_name is Silent_clip_name
		do
		end

feature {NONE} -- Implementation

	execute
			--
		do
			set_default_thread_log_file_name
			Precursor
		end

	result_queue: EL_THREAD_PRODUCT_QUEUE [RESULT_TYPE]

	audio_file_path: STRING

	script_interpreter: EL_PRAAT_INTERPRETER
			--
		do
			Result := Praat_engine.script_interpreter
		end

	Praat_engine: EL_PRAAT_ENGINE
			--
		once
			create Result.make
		end

	praat_script: STRING

	initialized_praat_script: STRING
			-- Praat script with audio_file_path$ set to current audio clip and
			-- various other script variables initialized

	Default_praat_script: STRING
			--
		deferred
		end

	praat_assign_string (variable_name, value: STRING)
			--
		require
			praat_string_names_end_with_dollor: variable_name.item (variable_name.count) = '$'
			first_letter_not_uppercase: not variable_name.item (1).is_upper
		do
			initialized_praat_script.append (variable_name)
			initialized_praat_script.append (" = %"")
			initialized_praat_script.append (value)
			initialized_praat_script.append ("%"%N")
		end

	praat_assign_double (variable_name: STRING; value: DOUBLE)
			--
		require
			first_letter_not_uppercase: not variable_name.item (1).is_upper
		do
			initialized_praat_script.append (variable_name)
			initialized_praat_script.append (" = ")
			initialized_praat_script.append_double (value)
			initialized_praat_script.append_character ('%N')
		end

	praat_assign_integer (variable_name: STRING; value: INTEGER)
			--
		require
			first_letter_not_uppercase: not variable_name.item (1).is_upper
		do
			initialized_praat_script.append (variable_name)
			initialized_praat_script.append (" = ")
			initialized_praat_script.append_integer (value)
			initialized_praat_script.append_character ('%N')
		end

feature {NONE} -- Constants

	Default_script_file_name: STRING = "default"

	Result_consumer_type: EL_CONSUMER [RESULT_TYPE]
			-- An example consumer used purely as an anchor type (Never instantiated)

invariant
	Result_consumer_purely_for_reference_as_an_anchor_type: Result_consumer_type = Void

end







