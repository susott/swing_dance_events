class Event < ApplicationRecord
  normalizes :website, with: -> website { website.strip.downcase }
  # strip title, validate title length
  # website should be an URI thingy
  # description can be empty
  # dance_types should be [:lindy, :collegiate_shag, :sankt_luis_shag, :blues, :balboa, west_coast, :charleston, :solo_jazz]
end
