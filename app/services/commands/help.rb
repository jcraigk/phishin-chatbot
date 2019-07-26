# frozen_string_literal: true
class Commands::Help < Commands::Base
  MENU_TEXT = <<~TXT
    ```
    Phish.in' Chatbot Commands
    ===========================================================================================

    {date} [more]
      Sending a date returns show info and setlist.
      Appending the keyword "more" displays more detail.
      EX: "1996-12-31 more", "Jul 31 2013", "feb 23"

    {selector} [{count} {entity}]
      Sending a selector followed by optional count and entity ("track", "show",
      or partial song title) returns the requested data. The entity may be pluralized.
      Selectors: [random|any] [first|debut] [last|recent] [shortest] [longest] [top|liked|best]
      EX: "top 3 shows", "random hoods", "longest track", "recent tweezer"

    jamchart [{song}]
      Sending `jamchart` returns a random Jamchart, optionally constrained to a song.
      EX: "jamchart", "jamchart tweezer"
    ```
  TXT

  def call
    MENU_TEXT
  end
end
