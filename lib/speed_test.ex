defmodule SpeedTest do
  def run do
    start = :os.system_time(:millisecond)
    url = "https://aua-uff-co.de/episodes.mp3.rss"
    # url = "https://api.sr.se/api/rss/pod/itunes/4017"
    headers = ["User-Agent": "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:51.0) Gecko/20100101 Firefox/51.0"]
    options = [recv_timeout: 15_000, timeout: 15_000, hackney: [:insecure]]
    split_time("Ready to download", start)

    {:ok, %HTTPoison.Response{status_code: 200, body: feed_xml}} = HTTPoison.get(url, headers, options)
    download_finished = split_time("Download finished", start)

    {:ok, feed_map} = {:ok, Quinn.parse(feed_xml)}

    items = Quinn.find(feed_map, [:rss, :channel, :items])
    split_time("Parsing items done", download_finished)

    require IEx
    IEx.pry()
  end

  def split_time(message, start_time) do
    milliseconds = :os.system_time(:millisecond) - start_time
                    |> Integer.to_string
    IO.inspect "=== " <> message <> " === " <> milliseconds
    :os.system_time(:millisecond)
  end
end
