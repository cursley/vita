# Vita 🌱

Vita is a tool for [digital gardening](https://maggieappleton.com/garden-history): creating, tending and publishing a collection of notes and ideas.

Vita takes a folder of plain text files and links them together to form a ~~graph~~ garden of knowledge. Vita takes influence from note-taking software like [Obsidian](https://obsidian.md/) and [Roam Research](https://roamresearch.com/).

An example note shown using Vita:

<img src="doc/notes.png" style="width: 100%" alt="Screenshot of a note titled &quot;Cohesion&quot;">

## Installation

Vita requires [Ruby 3.3.0](https://www.ruby-lang.org/en/news/2023/12/25/ruby-3-3-0-released/).

To install:

```
$ gem install vita
```

## Usage

In a folder containing text files, run `vita` to view your notes in a web browser:

```
$ vita
       _ _
__   _(_) |_ __ _
\ \ / / | __/ _` |
 \ V /| | || (_| |
  \_/ |_|\__\__,_|

Starting Vita at http://localhost:9000
```

Your web browser refreshes as you make changes to your files.

To publish:

```
$ vita publish
```

Vita creates a `publish` folder containing HTML files for publishing to a web server.

## Links between notes

Vita looks for connections between notes. When a note's title (or a [synonym](#synonyms)) appears in the content of another note, Vita creates a link between the two.

When viewing a note, links in the note's content are hyperlinked:

<img src="doc/outlinks.png" alt="Screenshot of a note in Vita, showing hyperlinks from a note's content to other notes" style="width: 75%">

A list of links from other notes to the current note follows the note's content:

<img src="doc/backlinks.png" alt="Screenshot of the &quot;links to this note&quot; panel in Vita, showing notes that reference the current note" style="width: 75%">

Each link includes an excerpt from the other note. Clicking one of these links navigates to the other note.

## Synonyms

Synonyms allow referring to notes using multiple names. Adding synonyms can be helpful when a note's title appears in other notes in different forms or tenses.

For example, notes may refer to a note titled "Cohesion" using terms like "cohesive", "coherent", or "coherence". Adding these words as synonyms to the "Cohesion" note allows Vita to connect the notes with links.

To specify a note's synonyms, add a `Synonyms:` line at the start of the file containing a comma-separated list of alternative names. For example, in a file called `Cohesion.txt`:

```
Synonyms: cohesive, coherent, coherence

A module is cohesive if the elements in the module are related and the module is coherent as a whole.
```

## Home note

If a note titled Home exists, it is treated as a home page and shown when you open your notes. Other notes cannot link to the Home note.

## File format

Vita uses plain text files. You can create them using any text editor and save them with any file extension. You can optionally use Markdown or [Org-mode](https://orgmode.org/) syntax (`.org` files only) to add formatting to your notes.

## Appearance

You can customise Vita's appearance by creating a file named `note.html.erb` in your notes folder. This file overrides the [default template](https://github.com/cursley/vita/blob/main/templates/note.html.erb). A good starting point is to copy the default template and make changes.

## Name

Vita is named for Vita Sackville-West, a twentieth-century author and garden designer and creator of [Sissinghurst Castle Garden](https://www.nationaltrust.org.uk/visit/kent/sissinghurst-castle-garden), a favourite place of mine.
