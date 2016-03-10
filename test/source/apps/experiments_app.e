note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-19 16:19:49 GMT (Friday 19th September 2014)"
	revision: "3"

class
	EXPERIMENTS_APP

inherit
	EL_SUB_APPLICATION
		redefine
			Option_name
		end

create
	make

feature {NONE} -- Initialization

	initialize
		do
		end

feature -- Basic operations

	run
			--
		do
			log.enter ("run")
			test_default_tuple_comparison
			log.exit
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
			table: EL_ASTRING_HASH_TABLE [ASTRING]
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

	test_codec
		local
			codec: EL_WINDOWS_1258_CODEC
		do
			log.enter ("test_codec")
			create codec.make
			across << 131, 181 >> as c loop
				log.put_string_field (c.cursor_index.out, codec.unicode_case_change_substitute (c.item).out)
				log.put_new_line
			end
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

feature {NONE} -- Implementation

	new (str: STRING): ASTRING
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

	Mime_type_template: ASTRING
		once
			Result := "text/$S; charset=$S"
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
