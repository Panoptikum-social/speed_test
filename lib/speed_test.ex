defmodule SpeedTest do
  def run do
    podcast = %{
      next_update: ~N[2018-08-15 21:33:16.624888],
      publication_frequency: 29.6882183908046,
      description: "Ein Podcast, mit dem zwei Lernende ihre Erfahrungen beim Lernen teilen.",
      image_url: "https://aua-uff-co.de/img/logo-itunes.jpg",
      website: "https://aua-uff-co.de",
      id: 104,
      last_build_date: ~N[2018-07-31 13:30:32.000000],
      title: "Aua-uff-Code!",
      latest_episode_publishing_date: ~N[2018-07-30 22:00:00.000000],
      image_title: "https://aua-uff-co.de/img/logo-itunes.jpg",
      update_intervall: 10,
      inserted_at: ~N[2016-10-27 14:09:30.000000],
      episodes_count: 30,
      manually_updated_at: ~N[2017-11-24 00:57:51.552746],
      summary: "Ein Podcast, mit dem zwei Lernende ihre Erfahrungen beim Lernen teilen.",
      updated_at: ~N[2018-08-15 11:33:16.877951]
    }

    start = :os.system_time(:millisecond)
    url = "https://aua-uff-co.de/episodes.mp3.rss"
    # url = "https://api.sr.se/api/rss/pod/itunes/4017"
    headers = ["User-Agent": "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:51.0) Gecko/20100101 Firefox/51.0"]
    options = [recv_timeout: 15_000, timeout: 15_000, hackney: [:insecure]]
    split_time("Ready to download", start)

    {:ok, %HTTPoison.Response{status_code: 200, headers: headers}} = HTTPoison.head(url, headers, options)
    download_finished = split_time("Download finished", start)

    headermap = headers |> Enum.into(%{})
    time = headermap["Last-Modified"]

    {:ok, datetime} = Timex.parse(time, "{WDshort}, {D} {Mshort} {YYYY} {ISOtime} {Zname}")

    # Condition: if last build modfied is not more than 1 minute older than last build date on database
    Timex.diff(podcast.last_build_date, datetime, :seconds) < 61

    require IEx
    IEx.pry()

    # {:ok, %HTTPoison.Response{status_code: 200, body: feed_xml}} = HTTPoison.get(url, headers, options)
    # {:ok, feed_map} = {:ok, Quinn.parse(feed_xml)}
    # items = Quinn.find(feed_map, [:rss, :channel, :items])
  end

  def split_time(message, start_time) do
    milliseconds = :os.system_time(:millisecond) - start_time
                    |> Integer.to_string
    IO.inspect "=== " <> message <> " === " <> milliseconds
    :os.system_time(:millisecond)
  end
end
