note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-22 10:44:36 GMT (Wednesday 22nd June 2016)"
	revision: "5"

class
	EXPERIMENTS_APP

inherit
	EL_SUB_APPLICATION
		rename
			run as test_container_extension
		redefine
			Option_name
		end

	EL_MODULE_EXECUTION_ENVIRONMENT

create
	make

feature {NONE} -- Initialization

	initialize
		do
		end

feature -- Basic operations

	equality_question
		local
			s1: STRING; s2: READABLE_STRING_GENERAL
			s1_equal_to_s2: BOOLEAN
		do
			log.enter ("equality_question")
			s1 := "abc"; s2 := "abc"
			s1_equal_to_s2 := s1 ~ s2
			log.put_labeled_string ("s1 is equal to s2", s1_equal_to_s2.out)
			log.exit
		end

	problem_with_function_returning_real_with_assignment
			--
		local
			event: AUDIO_EVENT
		do
			log.enter ("problem_with_function_returning_real_with_assignment")
			create event.make (1.25907 ,1.38513)
			log.put_string ("Is threshold exceeded: ")
			if event.is_threshold_exceeded (0.12606) then
				log.put_string ("true")
			else
				log.put_string ("false")
			end
			log.put_new_line
			log.exit
		end

	problem_with_function_returning_result_with_set_item
			-- if {AUDIO_EVENT}
		local
			event_list: LINKED_LIST [AUDIO_EVENT]
			event: AUDIO_EVENT
		do
			log.enter ("problem_with_function_returning_result_with_set_item")
			create event_list.make
			create event.make (1.25907 ,1.38513)
			event_list.extend (event)

			log.put_real_field ("event_list.last.duration", event_list.last.duration)
			log.put_new_line
			log.exit
		end

	find_iteration_order_of_linked_queue
			--
		local
			queue: LINKED_QUEUE [INTEGER]
		do
			log.enter ("find_iteration_order_of_linked_queue")
			create queue.make
			queue.extend (1)
			queue.extend (2)
			queue.extend (3)
			queue.linear_representation.do_all (
				agent (n: INTEGER) do
					log.put_integer (n)
					log.put_new_line
				end
			)
			log.exit
		end

	automatic_object_initialization
		local
			country: COUNTRY
			table: EL_ZSTRING_HASH_TABLE [ZSTRING]
		do
			log.enter ("automatic_object_initialization")

			create table.make (<<
				["code", new ("IE")],
				["literacy_rate", new ("0.9")],
				["population", new ("6500000")],
				["name", new ("Ireland")]
			>>)
			create country.make (table)
			log.put_labeled_string ("Country", country.name)
			log.put_new_line
			log.put_labeled_string ("Country code", country.code)
			log.put_new_line
			log.put_real_field ("literacy_rate", country.literacy_rate)
			log.put_new_line
			log.put_integer_field ("population", country.population)
			log.put_new_line

			log.exit
		end

	test_audio_info_parsing
		local
			s: ZSTRING; parts: EL_ZSTRING_LIST
		do
			log.enter ("test_audio_info_parsing")
			s := "Stream #0.0(und): Audio: aac, 44100 Hz, stereo, fltp, 253 kb/s"
			create parts.make_with_separator (s, ',', True)
			across parts as part loop
				log.put_string_field (part.cursor_index.out, part.item)
				log.put_new_line
			end
			log.exit
		end

	test_substitution_template
			--
		local
			template: EL_SUBSTITUTION_TEMPLATE [STRING]
		do
			log.enter ("test_substitution_template")
			create template.make ("x=$x, y=$y")
			template.set_variable ("x", "100")
			template.set_variable ("y", "200")
			log.put_line (template.substituted)
			log.exit
		end

	test_random_sequence
			--
		local
			random: RANDOM
			odd, even: INTEGER
			time: TIME
		do
			log.enter ("test_random_sequence")
			create time.make_now
			create random.make
			random.set_seed (time.compact_time)
			log.put_integer_field ("random.seed", random.seed)
			log.put_new_line
			from  until random.index > 200 loop
				log.put_integer_field (random.index.out, random.item)
				log.put_new_line
				if random.item \\ 2 = 0 then
					even := even + 1
				else
					odd := odd + 1
				end
				random.forth
			end
			log.put_new_line
			log.put_integer_field ("odd", odd)
			log.put_new_line
			log.put_integer_field ("even", even)
			log.put_new_line
			log.exit
		end

	test_self_deletion_from_batch
		do
			Execution_environment.launch ("cmd /C D:\Development\Eiffel\Eiffel-Loop\test\uninstall.bat")
		end

	test_escaped_text
		do
			log.enter ("test_escaped_text")
			log.put_string_field ("&aa&bb&", escaped_text ("&aa&bb&").as_string_8)
			log.exit
		end

	test_template
		local
			type: STRING
		do
			log.enter ("test_template")
			type := "html"
			log.put_string_field ("Content", Mime_type_template #$ [type, "UTF-8"])
			log.put_new_line
			log.put_string_field ("Content", Mime_type_template #$ [type, "UTF-8"])
			log.exit
		end

	test_time_input_formats
		local
			from_time, to_time: TIME; duration: TIME_DURATION
			format, from_str, to_str: STRING
		do
			log.enter ("test_time_input_formats")
			format := "mi:ss.ff3"
--			from_str := "1:01.500"; to_str := "1:03.001"
			from_str := "0:05.452"; to_str := "5:34.49"
			if is_valid_time (from_str) and is_valid_time (to_str) then
				create from_time.make_from_string (from_str, format)
				create to_time.make_from_string (to_str, format)
				log.put_labeled_string ("From", from_str); log.put_labeled_string (" to", to_str)
				log.put_new_line
				log.put_labeled_string ("From", from_time.out); log.put_labeled_string (" to", to_time.out)
				log.put_new_line
				duration := to_time.relative_duration (from_time)
				log.put_double_field ("Fine seconds", duration.fine_seconds_count)
			else
				log.put_line ("Invalid time format")
			end
			log.exit
		end

	test_time_parsing
		local
			time_str, format: STRING; time: TIME
			checker: TIME_VALIDITY_CHECKER
		do
			log.enter ("test_time_parsing")
			time_str := "21:15"; format := "hh:mi"
			create checker
			if True or checker.time_valid (time_str, format) then
				create time.make_from_string (time_str, format)
			else
				create time.make (0, 0, 0)
			end
			log.put_labeled_string ("Time", time.formatted_out ("hh:[0]mi"))
			log.put_new_line
			log.exit
		end

	test_url_string
		local
			str: EL_URL_STRING
		do
			create str.make_empty
			str.append_utf_8 ("freilly8@gmail.com")
		end

	test_default_tuple_comparison
		do
			log.enter ("test_default_tuple_comparison")
			if ["one"] ~ ["one"] then
				log.put_string ("is_object_comparison")
			else
				log.put_string ("is_reference_comparison")
			end
			log.exit
		end

	test_circular_removal
		local
			list: TWO_WAY_CIRCULAR [STRING]
		do
			log.enter ("test_circular_removal")
			create list.make
			list.extend ("a")
			list.extend ("b")
--			list.extend ("c")

			list.start
			list.remove
			list.start
			log.put_string_field ("first item", list.item)
			log.put_new_line
			log.exit
		end

	test_system_path
		do
			Execution_environment.system ("cp /home/finnian/Music/Foxtrot/Cristian\ Vasile/Saruta-Ma\!.01.mp3 ~/Desktop/Music")
		end

	test_procedure_call
		local
			procedure: PROCEDURE [like Current, TUPLE]
		do
			log.enter ("test_procedure_call")
			procedure := agent log_integer (?, "n")
			procedure (2)
			log.exit
		end

	test_integer_64
			-- is it possible to store 2 negative INTEGER_32's in one INTEGER_64
		local
			n: INTEGER_64
		do
			log.enter ("test_integer_64")
			n := ((10).to_integer_64 |<< 32) | -10
			log.put_integer_field ("low", n.to_integer_32) -- yes you can
			log.put_integer_field (" hi", (n |>> 32).to_integer_32) -- yes you can
			log.exit
		end

	test_generic_types
		local
			type_8, type_32: TYPE [LIST [READABLE_STRING_GENERAL]]
		do
			log.enter ("test_generic_types")
			type_8 := {ARRAYED_LIST [STRING]}
			type_32 := {ARRAYED_LIST [STRING_32]}
			log.exit
		end

	test_type_conforming_test
		local
			escaper: EL_DO_NOTHING_CHARACTER_ESCAPER [STRING]
			is_do_nothing_escaper: BOOLEAN
		do
			log.enter ("test_type_conforming_test")
			create escaper
			is_do_nothing_escaper := {EL_DO_NOTHING_CHARACTER_ESCAPER [STRING_GENERAL]} < escaper.generating_type
			log.put_labeled_string ("Is do nothing escaper", is_do_nothing_escaper.out)
			log.exit
		end

	test_file_position
		local
			file: PLAIN_TEXT_FILE
		do
			log.enter ("test_file_position")
			create file.make_open_write ("test.txt")
			file.put_string ("one two three")
			log_or_io.put_integer_field ("file.position", file.position)
			file.close
			file.delete
			log.exit
		end

	test_pointer_width
		local
			ptr: POINTER
		do
			log.enter ("test_pointer_width")
			ptr := $test_pointer_width
			log.put_integer_field (ptr.out, ptr.out.count)
			log.exit
		end

	test_substitution
		local
			template: EL_SUBSTITUTION_TEMPLATE [STRING]
		do
			log.enter ("test_substitution")
			create template.make ("from $var := 1 until $var > 10 loop")
			template.set_variable ("var", "i")
			log.put_line (template.substituted)
			log.exit
		end

	test_replace_delimited_substring_general
		local
			email: ZSTRING
		do
			log.enter ("test_replace_delimited_substring_general")
			across << "freilly8@gmail.com", "finnian@gmail.com", "finnian-buyer@eiffel-loop.com" >> as address loop
				email := address.item
				log.put_string (email)
				email.replace_delimited_substring_general ("finnian", "@eiffel", "", False, 1)
				log.put_string (" -> "); log.put_string (email)
				log.put_new_line
			end
			log.exit
		end

	test_boolean_ref
		local
			b1: BOOLEAN
			b1_ref, b2_ref: BOOLEAN
		do
			log.enter ("test_boolean_ref")
			b1_ref := b1.to_reference
			b2_ref := not b1_ref
			log.put_string ("b2_ref.item: ")
			log.put_boolean (b2_ref.item)
			log.exit
		end

	test_container_extension
		do
			log.enter ("test_container_extension")
			extend_container (create {ARRAYED_LIST [EL_DIR_PATH]}.make (0))
			log.exit
		end

feature {NONE} -- Implementation

	extend_container (container: LIST [EL_PATH])
		do
			container.extend (Directory.current_working)
		end

	log_integer (n: INTEGER; str: STRING)
		do
			log.put_integer_field (str, n)
			log.put_new_line
		end

	is_valid_time (str: STRING): BOOLEAN
		local
			parts: LIST [STRING]; mins, secs: STRING
		do
			parts := str.split (':')
			if parts.count = 2 then
				mins := parts [1]; secs := parts [2]
				secs.prune_all_leading ('0')
				Result := mins.is_integer and secs.is_real
			end
		end

	new (str: STRING): ZSTRING
		do
			Result := str
		end

	escaped_text (s: READABLE_STRING_GENERAL): READABLE_STRING_GENERAL
			-- `text' with doubled ampersands.
		local
			n, l_count: INTEGER
			l_amp_code: NATURAL_32
			l_string_32: STRING_32
		do
			l_amp_code := ('&').code.as_natural_32
			l_count := s.count
			n := s.index_of_code (l_amp_code, 1)

			if n > 0 then
					-- There is an ampersand present in `s'.
					-- Replace all occurrences of "&" with "&&".
					--| Cannot be replaced with `{STRING_32}.replace_substring_all' because
					--| we only want it to happen once, not forever.
				from
					create l_string_32.make (l_count + 1)
					l_string_32.append_string_general (s)
				until
					n > l_count
				loop
					n := l_string_32.index_of_code (l_amp_code, n)
					if n > 0 then
						l_string_32.insert_character ('&', n)
							-- Increase count local by one as a character has been inserted.
						l_count := l_count + 1
						n := n + 2
					else
						n := l_count + 1
					end
				end
				Result := l_string_32
			else
				Result := s
			end
		ensure
			ampersand_occurrences_doubled: Result.as_string_32.occurrences ('&') =
				(old s.twin.as_string_32).occurrences ('&') * 2
		end

	pi: DOUBLE
			-- Given that Pi can be estimated using the function 4 * (1 - 1/3 + 1/5 - 1/7 + ..)
			-- with more terms giving greater accuracy, write a function that calculates Pi to
			-- an accuracy of 5 decimal places.
		local
			limit, term, four: DOUBLE; divisor: INTEGER
		do
			log.enter ("pi")
			four := 4.0; limit := 0.5E-5; divisor := 1
			from term := four until term.abs < limit loop
				Result := Result + term
				four := four.opposite
				divisor := divisor + 2
				term := four / divisor
			end
			log.put_integer_field ("divisor", divisor)
			log.put_new_line
			log.exit
		end

	storable_string_list: STORABLE_STRING_LIST

feature {NONE} -- Constants

	Mime_type_template: ZSTRING
		once
			Result := "text/%S; charset=%S"
		end

	Option_name: STRING = "experiments"

	Description: STRING = "Experiment with Eiffel code to fix bugs"

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := <<
				[{EXPERIMENTS_APP}, All_routines]
			>>
		end

end
