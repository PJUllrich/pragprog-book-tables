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

genders = ["M", "F", "?"]

# 12 years
max_age = 10 * 365

max_weight = 970
min_weight = 100

# In millimeter
max_height = 3500
min_height = 500

ran = fn input -> Enum.random(input) end

meerkat_count = 100
now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)

data =
  for _ <- 1..meerkat_count do
    %{
      name: "#{ran.(name_prefix)} #{ran.(names)}",
      gender: ran.(genders),
      age: ran.(0..max_age),
      weight: max(ran.(0..max_weight), min_weight),
      height: max(ran.(0..max_height), min_height),
      inserted_at: now,
      updated_at: now
    }
  end

Repo.insert_all(Meerkat, data)
