defmodule MoviesUy.DailyWorker do
  use Oban.Worker, queue: :default

  @impl Oban.Worker
  def perform(_) do
    MoviesUy.MovieCenter.fetch_movies()
  end
end
