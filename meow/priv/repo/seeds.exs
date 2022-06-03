# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Meow.Repo.insert!(%Meow.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Meow.Repo
alias Meow.Meerkats.Meerkat

name_prefix = [
  "Big",
  "Little",
  "Cat",
  "Kat",
  "Meery",
  "Miri",
  "Kattie",
  "Rusty",
  "Mean",
  "Sweet",
  "Cute",
  "Slim"
]

names = [
  "Cat Benatar",
  "Jennifurr",
  "Meowsie",
  "Fishbait",
  "Puddy Tat",
  "Purrito",
  "Yeti",
  "Cindy Clawford",
  "Meatball",
  "Cheddar",
  "Marshmallow",
  "Nugget",
  "Ramen",
  "Porkchop",
  "Porky",
  "Sriracha",
  "Tink",
  "Turbo",
  "Rambo",
  "Twinky",
  "Frodo",
  "Burrito",
  "Bacon",
  "Muffin",
  "Hobbes",
  "Quimby",
  "Ricky Ticky Tabby",
  "Boots",
  "Buttons",
  "Bubbles",
  "Cha Cha",
  "Cheerio",
  "Baloo",
  "Jelly",
  "Opie",
  "Stitch",
  "Wasabi",
  "Sushi",
  "Seuss",
  "Kermit",
  "Miss Piggy",
  "Pikachu",
  "Catzilla",
  "Clawdia"
]

ran = fn input -> Enum.random(input) end

meerkat_count = 117
now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)

data =
  for _ <- 1..meerkat_count do
    %{
      name: "#{ran.(name_prefix)} #{ran.(names)}",
      inserted_at: now,
      updated_at: now
    }
  end

Repo.insert_all(Meerkat, data)
