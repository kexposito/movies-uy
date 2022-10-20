defmodule MoviesUy.MovieCenter do
  require Logger

  def fetch_movies() do
    movie_url = "https://api.movie.com.uy/api/billboard/cinema/weekly?nextReleases=false"

    request = Finch.build(:get, movie_url) |> Finch.request(MoviesUyFinch)

    with {:ok, %Finch.Response{body: data}} <- request,
         %{"items" => movies} <- Jason.decode!(data),
         %ExTwitter.Model.Tweet{id: tweet_id} <- post_message()
    do
      movies
      |> Enum.map(&post_thread_message(&1, tweet_id))
    else
      error ->
        Logger.error error
    end
  end

  defp post_thread_message(%{"content" => %{"title" => title, "id" => id, "urlSlug" => slug}}, tweet_id) do
    "#{title} - https://www.movie.com.uy/movie/#{id}/#{slug}"
    |> ExTwitter.update(in_reply_to_status_id: tweet_id)
  end

  defp post_message do
    %Date{day: day, month: month, year: year} = Date.utc_today

    "Cartelera de Movie Center del #{day}/#{month}/#{year}"
    |> ExTwitter.update
  end
end
