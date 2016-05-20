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
  dynamic(music_cd/7).


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
  write('  [genres] List CDs grouped by genres.'), nl,
  write('  [search] Search for a CD.'), nl,
  write('  [sort]   Sort CDs by an attribute.'), nl,
  write('  [save]   Save the database to a file.'), nl,
  write('  [load]   Load the database from a file.'), nl,
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
      list_cds(_, _, _, _, _, _, _),
      fail;

    Choice = 'genres' ->
      genres,
      fail;

    Choice = 'search' ->
      search_cd,
      fail;

    Choice = 'sort' ->
      sort_cds,
      fail;

    Choice = 'save' ->
      save,
      fail;

    Choice = 'load' ->
      load,
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
      not(music_cd(ID_number, _, _, _, _, _, _)),
      !;
      write('A CD with that ID already exists!'), nl,
      write('Please provide a different one.'), nl,
      fail
    )
  ),
  write('Name: '),
  read(Name),
  write('Genre: '),
  read(Genre),
  write('Author: '),
  read(Author),
  write('Studio: '),
  read(Studio),
  (
    repeat,
    write('Date [MM-YY]: '),
    read(Date),
    (
      Date = Month-Year,
      Month >= 1,
      Month =< 12,
      Year < 100,
      !;
      write('Wrong format!'), nl,
      fail
    )
  ),
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
  assertz(
    music_cd(
      ID_number,
      Name,
      Genre,
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
    music_cd(ID_number, _, _, _, _, _, _)
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
  Genre,
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
      Genre,
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
  write('Genre: '),
  write(Genre), nl,
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
 * genres.
 *
 * List CD names grouped by genres.
 */
genres :-
  write('Music CDs by genre:'), nl,
  findall(Genre, music_cd(_, _, Genre, _, _, _, _), GenreList),
  unique(GenreList, UniqueList),
  print_genres(UniqueList).


/**
 * print_genres(+Genres).
 *
 * Print CD names grouped by genres in a list.
 */
print_genres([]).
print_genres([Genre | Tail]) :-
  print_genre(Genre);
  print_genres(Tail).


/**
 * print_genre(+Genre).
 *
 * Print all CDs of a genre.
 */
print_genre(Genre) :-
  nl,
  write(Genre),
  write(:), nl,
  repeat,
  (
    music_cd(
      _,
      Name,
      Genre,
      _,
      _,
      _,
      _
    );
    !,
    fail
  ),
  write('  '),
  write(Name), nl,
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
  write('  [genre]  Genre'), nl,
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

    Choice = 'genre' ->
      search_by_genre,
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
  list_cds(ID_number, _, _, _, _, _, _);
  true.


/**
 * search_by_name.
 *
 * Search for a CD by it's name.
 */
search_by_name :-
  write('Name: '),
  read(Name),
  list_cds(_, Name, _, _, _, _, _);
  true.


/**
 * search_by_genre.
 *
 * Search for a CD by it's genre.
 */
search_by_genre :-
  write('Genre: '),
  read(Genre),
  list_cds(_, _, Genre, _, _, _, _);
  true.



/**
 * search_by_author.
 *
 * Search for a CD by it's author.
 */
search_by_author :-
  write('Author: '),
  read(Author),
  list_cds(_, _, _, Author, _, _, _);
  true.


/**
 * search_by_studio.
 *
 * Search for a CD by it's studio.
 */
search_by_studio :-
  write('Studio: '),
  read(Studio),
  list_cds(_, _, _, _, Studio, _, _);
  true.


/**
 * search_by_date.
 *
 * Search for a CD by it's date.
 */
search_by_date :-
  write('Date: '),
  read(Date),
  list_cds(_, _, _, _, _, Date, _);
  true.


/**
 * search_by_length.
 *
 * Search for a CD by it's length.
 */
search_by_length :-
  write('Length: '),
  read(Length),
  list_cds(_, _, _, _, _, _, Length);
  true.


/**
 * sort_cds.
 *
 * Show CDs sorted by an attribute.
 */
sort_cds :-
  write('What do you want to sort by?'), nl,
  write('  [name]   Name'), nl,
  write('  [author] Author'), nl,
  write('  [date]   Date'), nl,
  write('  [length] Length'), nl,
  findall([
      ID_number,
      Name,
      Genre,
      Author,
      Studio,
      Date,
      Length],
    music_cd(
      ID_number,
      Name,
      Genre,
      Author,
      Studio,
      Date,
      Length
    ), CDList),
  repeat,
  write('Search by: '),
  read(Choice),
  (
    Choice = 'name' ->
      sort_by(name, CDList),
      !;

    Choice = 'author' ->
      sort_by(author, CDList),
      !;

    Choice = 'date' ->
      sort_by(date, CDList),
      !;

    Choice = 'length' ->
      sort_by(length, CDList),
      !;


    write('Unknown attribute '),
    write(Choice),
    write('. Try again.'), nl,
    fail
  ).


/**
 * print_cd_list(CDList).
 *
 * Print a list of CDs.
 */
print_cd_list([]).
print_cd_list([[
    ID_number,
    Name,
    Genre,
    Author,
    Studio,
    Date,
    Length] | Tail]) :-
  nl,
  write('ID_number: '),
  write(ID_number), nl,
  write('Name: '),
  write(Name), nl,
  write('Genre: '),
  write(Genre), nl,
  write('Author: '),
  write(Author), nl,
  write('Studio: '),
  write(Studio), nl,
  write('Date: '),
  write(Date), nl,
  write('Length: '),
  write(Length), nl,
  print_cd_list(Tail).


/**
 * sort_by(+Attribute, +CDList).
 *
 * Show CDs sorted by an attribute.
 */
sort_by(Attribute, CDList) :-
  nl,
  write('CDs sorted by '),
  write(Attribute),
  write(':'), nl,
  sort_list_by(Attribute, CDList, SortedList),
  print_cd_list(SortedList).


/**
 * sort_list_by(+Attribute, +Unsorted, -Sorted).
 *
 * Sort a list of CDs by an attribute.
 */
sort_list_by(Attribute, Unsorted, Sorted) :-
  sort_list_by_acc(Attribute, Unsorted, [], Sorted).
sort_list_by_acc(_, [], Acc, Acc).
sort_list_by_acc(Attribute, [Head | Tail], Acc, Sorted) :-
  atom_concat(insert_by_, Attribute, InsertName),
  Insert =.. [InsertName, Head, Acc, NewAcc],
  Insert,
  sort_list_by_acc(Attribute, Tail, NewAcc, Sorted).


/**
 * insert_by_name(+Element, +List, -ListWithElement).
 *
 * Insert sort the Element into the List.
 */
insert_by_name(X, [], [X]).
insert_by_name([
    EID_number,
    EName,
    EGenre,
    EAuthor,
    EStudio,
    EDate,
    ELength], [[
    ID_number,
    Name,
    Genre,
    Author,
    Studio,
    Date,
    Length] | InTail], [[
    ID_number,
    Name,
    Genre,
    Author,
    Studio,
    Date,
    Length] | OutTail]) :-
  EName @> Name,
  insert_by_name([
    EID_number,
    EName,
    EGenre,
    EAuthor,
    EStudio,
    EDate,
    ELength], InTail, OutTail).
insert_by_name([
    EID_number,
    EName,
    EGenre,
    EAuthor,
    EStudio,
    EDate,
    ELength], [[
    ID_number,
    Name,
    Genre,
    Author,
    Studio,
    Date,
    Length] | Tail], [[
    EID_number,
    EName,
    EGenre,
    EAuthor,
    EStudio,
    EDate,
    ELength], [
    ID_number,
    Name,
    Genre,
    Author,
    Studio,
    Date,
    Length] | Tail]) :-
  EName @=< Name.


/**
 * insert_by_author(+Element, +List, -ListWithElement).
 *
 * Insert sort the Element into the List.
 */
insert_by_author(X, [], [X]).
insert_by_author([
    EID_number,
    EName,
    EGenre,
    EAuthor,
    EStudio,
    EDate,
    ELength], [[
    ID_number,
    Name,
    Genre,
    Author,
    Studio,
    Date,
    Length] | InTail], [[
    ID_number,
    Name,
    Genre,
    Author,
    Studio,
    Date,
    Length] | OutTail]) :-
  EAuthor @> Author,
  insert_by_author([
    EID_number,
    EName,
    EGenre,
    EAuthor,
    EStudio,
    EDate,
    ELength], InTail, OutTail).
insert_by_author([
    EID_number,
    EName,
    EGenre,
    EAuthor,
    EStudio,
    EDate,
    ELength], [[
    ID_number,
    Name,
    Genre,
    Author,
    Studio,
    Date,
    Length] | Tail], [[
    EID_number,
    EName,
    EGenre,
    EAuthor,
    EStudio,
    EDate,
    ELength], [
    ID_number,
    Name,
    Genre,
    Author,
    Studio,
    Date,
    Length] | Tail]) :-
  EAuthor @=< Author.


/**
 * insert_by_date(+Element, +List, -ListWithElement).
 *
 * Insert sort the Element into the List.
 */
insert_by_date(X, [], [X]).
insert_by_date([
    EID_number,
    EName,
    EGenre,
    EAuthor,
    EStudio,
    EDate,
    ELength], [[
    ID_number,
    Name,
    Genre,
    Author,
    Studio,
    Date,
    Length] | InTail], [[
    ID_number,
    Name,
    Genre,
    Author,
    Studio,
    Date,
    Length] | OutTail]) :-
  EDate = EM-EY,
  Date = M-Y,
  % EDate > Date
  (
    EY > Y;
    EY =:= Y,
    EM > M
  ),
  insert_by_date([
    EID_number,
    EName,
    EGenre,
    EAuthor,
    EStudio,
    EDate,
    ELength], InTail, OutTail).
insert_by_date([
    EID_number,
    EName,
    EGenre,
    EAuthor,
    EStudio,
    EDate,
    ELength], [[
    ID_number,
    Name,
    Genre,
    Author,
    Studio,
    Date,
    Length] | Tail], [[
    EID_number,
    EName,
    EGenre,
    EAuthor,
    EStudio,
    EDate,
    ELength], [
    ID_number,
    Name,
    Genre,
    Author,
    Studio,
    Date,
    Length] | Tail]) :-
  EDate = EM-EY,
  Date = M-Y,
  % EDate @=< Date
  (
    EY < Y;
    EY =:= Y,
    EM =< M
  ).


/**
 * insert_by_length(+Element, +List, -ListWithElement).
 *
 * Insert sort the Element into the List.
 */
insert_by_length(X, [], [X]).
insert_by_length([
    EID_number,
    EName,
    EGenre,
    EAuthor,
    EStudio,
    EDate,
    ELength], [[
    ID_number,
    Name,
    Genre,
    Author,
    Studio,
    Date,
    Length] | InTail], [[
    ID_number,
    Name,
    Genre,
    Author,
    Studio,
    Date,
    Length] | OutTail]) :-
  ELength > Length,
  insert_by_length([
    EID_number,
    EName,
    EGenre,
    EAuthor,
    EStudio,
    EDate,
    ELength], InTail, OutTail).
insert_by_length([
    EID_number,
    EName,
    EGenre,
    EAuthor,
    EStudio,
    EDate,
    ELength], [[
    ID_number,
    Name,
    Genre,
    Author,
    Studio,
    Date,
    Length] | Tail], [[
    EID_number,
    EName,
    EGenre,
    EAuthor,
    EStudio,
    EDate,
    ELength], [
    ID_number,
    Name,
    Genre,
    Author,
    Studio,
    Date,
    Length] | Tail]) :-
  ELength =< Length.


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
      Genre,
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
      Genre,
      Author,
      Studio,
      Date,
      Length
    )
  ),
  write('.'), nl,
  fail.


/**
 * load.
 *
 * Load a database from a file.
 */
load :-
  write('File name: '),
  read(File),
  see(File),
  read_cds_from_file;
  seen,
  write('Loaded the database from the file.'), nl.


/**
 * read_cds_from_file.
 *
 * Read CDs from the opened file and add them to the database.
 */
read_cds_from_file :-
  repeat,
  read(CD),
  (
    CD = end_of_file ->
      !,
      fail;

    assertz(CD),
    fail
  ).


/**
 * unique(+List, -UniqueList).
 *
 * Makes every element of the List appear in the UniqueList
 * only once.
 */
unique([], []).
unique([LHead | LTail], [LHead | UTail]) :-
  remove_all(LHead, LTail, LWithoutHead),
  unique(LWithoutHead, UTail).


/**
 * remove_all(?Element, +List, -ListWithoutElement).
 *
 * Remove all elements Element from List.
 */
remove_all(_, [], []).
remove_all(Element, [Element | LTail], LWETail) :-
  remove_all(Element, LTail, LWETail).
remove_all(Element, [LHead | LTail], [LHead | LWETail]) :-
  Element \= LHead,
  remove_all(Element, LTail, LWETail).
