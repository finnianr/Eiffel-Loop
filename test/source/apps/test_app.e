note
	description: "Summary description for {TEST_APP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-28 19:14:33 GMT (Sunday 28th September 2014)"
	revision: "6"

class
	TEST_APP

inherit
	TEST_APPLICATION

	EL_MODULE_STRING

	EL_MODULE_EIFFEL

create
	make

feature -- Basic operations

	test_run
		do
			log.enter ("run")
			run_1
			log.exit
		end

	run_1
		do
			log.put_string (String.hexadecimal_to_natural_64 ("0x00000982").out)
			log.put_new_line
		end

	run_10
		local
			table: HASH_TABLE [INTEGER, STRING_32]
		do
			create table.make_equal (23)

			table.put (table.count + 1,"A")
			table.put (table.count + 1,"A")
			table.put (table.count + 1,"B")

		end

	run_11
		do
			Execution_environment.put ("sausage", "SSL_PW")
			Execution_environment.system ("echo Password: $SSL_PW")
		end

	run_2
			--
		local
			wav_path, xml_dir: EL_DIR_PATH
	 	do
	 		wav_path := "wav"; xml_dir := "XML"
			Test.do_file_tree_test (wav_path, agent directory_creation, 665371111)
			Test.do_file_tree_test (wav_path, agent file_and_directory_creation_with_latin1_chars, 1062593732)

			Test.do_file_test (xml_dir + "linguistic-analysis.smil", agent string_occurrence_intervals, 555824392)
			-- passed on 21 Jan 2011
	 	end

	run_3
			--
		local
			xml_dir: EL_DIR_PATH
	 	do
	 		xml_dir := "XML"
			Test.do_file_test (xml_dir + "linguistic-analysis.smil", agent boyer_moore_search, 555824392)
	 	end

	run_4
		do
			log.put_boolean (has_repeated_hexadecimal_digit (0xAAAAAAAAAAAAAAAA)); log.put_new_line
			log.put_boolean (has_repeated_hexadecimal_digit (0x1AAAAAAAAAAAAAAA)); log.put_new_line
			log.put_boolean (has_repeated_hexadecimal_digit (0xAAAAAAAAAAAAAAA1)); log.put_new_line
		end

	run_5
		local
			dir: EL_DIR_PATH
			temp: EL_FILE_PATH
		do
			create dir.make_from_latin1 ("E:/")
			temp := dir + "temp"
			log.put_string_field ("Path", temp.as_windows.to_string)
		end

	run_6
		local
			tuple: ARRAYED_LIST [ANY]
		do
			create tuple.make (2)
			tuple.extend ("hello")
			tuple.extend (1)
			log.enter_with_args ("run_6", tuple.to_array)
			log.exit
		end

	run_7
		local
			action, action_2: PROCEDURE [ANY, TUPLE [STRING]]
		do
			action := agent hello_routine
			action_2 := action.twin
			action_2.set_operands (["wonderful"])
			action_2.apply
		end

	run_8
		local
			internal: INTERNAL
			color: TUPLE [margins, background: STRING]
		do
			create internal
			create color
			color.margins := "blue"
			color.background := "red"
			log.put_integer_field ("First field", internal.field_count (color))
			log.put_new_line
		end

	run_9
		do
			log.put_string ("")
			io.put_string ("%/65/%/27/[128;0;128mB")
		end

feature -- Tests

	boyer_moore_search (file_path: EL_FILE_PATH)
			--
		local
			search_string, text: EL_TOKENIZED_STRING
		do
			log.enter_with_args ("boyer_moore_search", << file_path >>)
			search ("ionization", "ion ionization ionization")
			search ("<audio", File_system.plain_text (file_path))
--			(<< 1 >>).do_all (agent )
			-- design print
--			create search_string.make_from_array (<< 529, 1107 >>)

			-- print designer
--			create search_string.make_from_array (<< 1107, 422 >>)

--			create text.make_from_array (<< 270, 2644, 529, 1107, 422, 2645, 2646, 69, 2647, 150, 2645, 492 >>)
--			search (search_string, text)
			log.exit
		end

	directory_creation (wav_path: EL_DIR_PATH)
			--
		local
			opt_path_steps: EL_PATH_STEPS
			test_dir: EL_DIR_PATH
		do
			log.enter ("directory_creation")
			opt_path_steps := "/opt/program-creation-test"
			if opt_path_steps.is_createable_dir then
				File_system.make_directory (opt_path_steps)
				log.put_string_field ("Path", opt_path_steps.as_directory_path.to_string)
				log.put_string (" created")
				log.put_new_line
			else
				log.put_string_field ("Path", opt_path_steps.as_directory_path.to_string)
				log.put_string (" not creatable")
				log.put_new_line
			end

			test_dir := wav_path.joined_dir_steps (<< "sub1", "sub2", "sub3" >>)
			if test_dir.is_createable then
				File_system.make_directory (test_dir)
				log.put_string_field ("Path", test_dir.to_string)
				log.put_string (" created")
				log.put_new_line
				File_system.copy (wav_path + "pop.wav", test_dir)
			else
				log.put_string_field ("Path", test_dir.to_string)
				log.put_string (" not creatable")
				log.put_new_line
			end

			log.exit
		end

	file_and_directory_creation_with_latin1_chars (dir_path: EL_DIR_PATH)
			--
		local
			file_path: EL_FILE_PATH
		do
			log.enter ("file_and_directory_creation_with_latin1_chars")

			file_path := dir_path + "pop.wav"
			File_system.make_directory (dir_path.joined_dir_path ("Enrique Rodríguez"))
			File_system.move (file_path, dir_path.joined_file_steps (<< "Enrique Rodríguez", "No te Quiero Más.wav" >>))
			log.exit
		end

	hello_routine (a_arg: STRING)
		do
			log.enter_with_args ("hello_routine", << a_arg >>)
			log.exit
		end

	string_occurrence_intervals (file_path: EL_FILE_PATH)
			--
		local
			intervals: EL_OCCURRENCE_SUBSTRINGS
			text, search_string: STRING
		do
			log.enter_with_args ("string_occurrence_intervals", << file_path >>)
			text := File_system.plain_text (file_path)
			search_string := "title="
			log.put_string_field ("Search string", search_string)
			create intervals.make (text, search_string)
			intervals.do_all (
				agent (interval: INTEGER_INTERVAL; a_text: STRING)
					do
						log.put_integer_interval_field ("Interval", interval)
						log.put_line (" " + a_text.substring (interval.lower, interval.upper))

					end (?, text)
			)
			log.put_integer_interval_field ("6th interval", String.search_interval_at_nth (text, search_string, 6))
			log.put_new_line

			log.put_line ("-----------------------")
			String.delimited_list (text, "<audio ").do_all (
				agent (item: ASTRING)
					do
						log.put_line (item)
						log.put_line ("-----------------------")
					end

			)

			text := ", one, two, three, "
			log.put_line (text)
			String.delimited_list (text, ", ").do_all (
				agent (item: ASTRING)
						--
					do
						log.put_string_field ("Item", item)
						log.put_new_line
					end
			)

			log.exit
		end

feature {NONE} -- Implementation

	directory_list: EL_DIRECTORY_PATH_LIST

	has_repeated_hexadecimal_digit (n: NATURAL_64): BOOLEAN
		local
			first, hex_digit: NATURAL_64
			i: INTEGER
		do
			first := n & 0xF
			hex_digit := first
			from i := 1 until hex_digit /= first or i > 15 loop
				hex_digit := n.bit_shift_right (i * 4) & 0xF
				i := i + 1
			end
			Result := i = 16 and then hex_digit = first
		end

	s: UC_STRING

--	latin1_directory_path_list: EL_LATIN1_DIRECTORY_PATH_LIST

	search (search_string, text: STRING_32)
			--
		local
			searcher: EL_BOYER_MOORE_SEARCHER_32
			pos: INTEGER
		do
			create searcher.make (search_string)
			searcher.log_print

			from pos := 1 until pos = 0 loop
				pos := searcher.index (text, pos)
				if pos > 0 then
					log.put_integer_field ("pos", pos)
					log.put_character (' ')
					log.put_string (text.substring (pos, (pos + 19).min (text.count)))
					log.put_new_line
					pos := pos + search_string.count
				end
			end
		end

feature {NONE} -- Constants

	Description: STRING = "Auto test class"

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := <<
				[{TEST_APP}, All_routines],
				[{EL_TEST_ROUTINES}, All_routines],
				[{EL_FIND_FILES_COMMAND}, All_routines],
				[{EL_BOYER_MOORE_SEARCHER_32}, All_routines]
			>>
		end
	Option_name: STRING = "test"

end
