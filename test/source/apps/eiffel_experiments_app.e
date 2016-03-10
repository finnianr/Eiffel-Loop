note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-22 12:28:09 GMT (Saturday 22nd June 2013)"
	revision: "2"

class
	EIFFEL_EXPERIMENTS_APP

inherit
	TEST_APPLICATION
		redefine
			Option_name
		end

create
	make

feature -- Basic operations

	run
			--
		do
			log.enter ("run")
--			problem_with_function_returning_real_with_assignment

--			problem_with_function_returning_result_with_set_item

--			find_iteration_order_of_linked_queue

--			test_substitution_template

--			test_random_sequence

--			test_self_deletion_from_batch

			test_escaped_text
			log.exit
		end

feature -- Basic operations

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

feature {NONE} -- Implementation

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

	storable_string_list: STORABLE_STRING_LIST

feature {NONE} -- Constants

	Option_name: STRING = "experiments"

	Description: STRING = "Experiment with Eiffel code to fix bugs"

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := <<
				[{EIFFEL_EXPERIMENTS_APP}, "*"]
			>>
		end

end
