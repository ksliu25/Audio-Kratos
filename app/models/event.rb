class Event < ActiveRecord::Base
  has_many :playlist_events
  has_many :playlists, through: :playlist_events

  has_many :songs, through: :playlists

  belongs_to :owner, class_name: "User"

  belongs_to :current_song, class_name: "Song"

  def as_json(opts={})
    opts[:whatever]
    hash = super(opts)
    hash[:votes] = self.votes_for_event(opts[:event])
    hash
  end
end

to_json({event:@event})


