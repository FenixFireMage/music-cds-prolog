/** <module> music_cd
 *
 * MUSIC CD DATABASE
 * -----------------
 *
 * This program is a database of good ol' music CDs.
 * It allows the user to add and remove CD, search for
 * a CD and filter and sort CDs.
 * It can also save the database to a file and later
 * restore from this file.
 *
 * @author chuckeles
 * @license MIT
 *
 */


:-
  dynamic(music_cd/6).


/**
 * application.
 *
 * Runs the application.
 *
 * @see menu
 * @see action
 */
application :-
  header,
  repeat,
  (
    menu,
    action
  ).


/**
 * header.
 *
 * Show the initial application header.
 */
header :-
  write('MUSIC CD DATABASE'), nl,
  write('by chuckeles'), nl.


/**
 * menu.
 *
 * Shows the main menu.
 */
menu :-
  nl,
  write('MAIN MENU'), nl,
  write('  [add]    Add a new CD.'), nl,
  write('  [remove] Remove a CD.'), nl,
  write('  [list]   List all CDs in the database.'), nl,
  write('  [search] Search for a CD.'), nl,
  write('  [save]   Save the database to a file.'), nl,
  write('  [exit]   Exit the application.'), nl.


/**
 * action.
 *
 * Read user input and take an action.
 */
action :-
  write('Your choice: '),
  read(Choice),
  (
    Choice = 'add' ->
      add_cd,
      fail;

    Choice = 'remove' ->
      remove_cd,
      fail;

    Choice = 'list' ->
      list_cds(_, _, _, _, _, _),
      fail;

    Choice = 'search' ->
      search_cd,
      fail;

    Choice = 'save' ->
      save,
      fail;

    Choice = 'exit' ->
      write('Exiting the application!'), nl,
      !;

    write('What does that mean? I don\'t understand!'), nl,
    fail
  ).


/**
 * add_cd.
 *
 * Add a new music CD to the database.
 */
add_cd :-
  write('Please provide information about this CD:'), nl,
  (
    repeat,
    write('ID number: '),
    read(ID_number),
    (
      not(music_cd(ID_number, _, _, _, _, _)),
      !;
      write('A CD with that ID already exists!'), nl,
      write('Please provide a different one.'), nl,
      fail
    )
  ),
  write('Name: '),
  read(Name),
  write('Author: '),
  read(Author),
  write('Studio: '),
  read(Studio),
  write('Date: '),
  read(Date),
  (
    repeat,
    write('Length in minutes: '),
    read(Length),
    (
      number(Length),
      !;
      write('Please provide a number!'), nl,
      fail
    )
  ),
  asserta(
    music_cd(
      ID_number,
      Name,
      Author,
      Studio,
      Date,
      Length
    )
  ),
  write('Added the new CD to the database.'), nl.


/**
 * remove_cd.
 *
 * Remove a CD from the database.
 */
remove_cd :-
  write('What is the ID number of the CD you want to remove?'), nl,
  write('ID number: '),
  read(ID_number),
  retract(
    music_cd(ID_number, _, _, _, _, _)
  ),
  write('Removed a CD with ID '),
  write(ID_number),
  write(' from the database.'), nl.


/**
 * list_cds.
 *
 * List CDs in the database.
 * This can show all CDs or search by an attribute.
 */
list_cds(
  ID_number,
  Name,
  Author,
  Studio,
  Date,
  Length
) :-
  write('CDs in the database:'), nl,
  repeat,
  (
    music_cd(
      ID_number,
      Name,
      Author,
      Studio,
      Date,
      Length
    );
    !,
    fail
  ),
  nl,
  write('ID_number: '),
  write(ID_number), nl,
  write('Name: '),
  write(Name), nl,
  write('Author: '),
  write(Author), nl,
  write('Studio: '),
  write(Studio), nl,
  write('Date: '),
  write(Date), nl,
  write('Length: '),
  write(Length), nl,
  fail.


/**
 * search_cd.
 *
 * Search for a CD by one of it's attributes.
 */
search_cd :-
  write('What do you want to search by?'), nl,
  write('  [id]     ID number'), nl,
  write('  [name]   Name'), nl,
  write('  [author] Author'), nl,
  write('  [studio] Studio'), nl,
  write('  [date]   Date'), nl,
  write('  [length] Length'), nl,
  repeat,
  write('Search by: '),
  read(Choice),
  (
    Choice = 'id' ->
      search_by_id,
      !;

    Choice = 'name' ->
      search_by_name,
      !;

    Choice = 'author' ->
      search_by_author,
      !;

    Choice = 'studio' ->
      search_by_studio,
      !;

    Choice = 'date' ->
      search_by_date,
      !;

    Choice = 'length' ->
      search_by_length,
      !;


    write('Unknown attribute '),
    write(Choice),
    write('. Try again.'), nl,
    fail
  ).


/**
 * search_by_id.
 *
 * Search for a CD by it's id number.
 */
search_by_id :-
  write('ID number: '),
  read(ID_number),
  list_cds(ID_number, _, _, _, _, _);
  true.


/**
 * search_by_name.
 *
 * Search for a CD by it's name.
 */
search_by_name :-
  write('Name: '),
  read(Name),
  list_cds(_, Name, _, _, _, _);
  true.


/**
 * search_by_author.
 *
 * Search for a CD by it's author.
 */
search_by_author :-
  write('Author: '),
  read(Author),
  list_cds(_, _, Author, _, _, _);
  true.


/**
 * search_by_studio.
 *
 * Search for a CD by it's studio.
 */
search_by_studio :-
  write('Studio: '),
  read(Studio),
  list_cds(_, _, _, Studio, _, _);
  true.


/**
 * search_by_date.
 *
 * Search for a CD by it's date.
 */
search_by_date :-
  write('Date: '),
  read(Date),
  list_cds(_, _, _, _, Date, _);
  true.


/**
 * search_by_length.
 *
 * Search for a CD by it's length.
 */
search_by_length :-
  write('Length: '),
  read(Length),
  list_cds(_, _, _, _, _, Length);
  true.

/**
 * save.
 *
 * Save the database to a file.
 */
save :-
  write('File name: '),
  read(File),
  tell(File),
  list_cds_to_file;
  told,
  write('Saved the database to the file.'), nl.

/**
 * list_cds_to_file.
 *
 * Writes all CDs to a file that is open.
 */
list_cds_to_file :-
  repeat,
  (
    music_cd(
      ID_number,
      Name,
      Author,
      Studio,
      Date,
      Length
    );
    !,
    fail
  ),
  write(
    music_cd(
      ID_number,
      Name,
      Author,
      Studio,
      Date,
      Length
    )
  ),
  write('.'), nl,
  fail.
