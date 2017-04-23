defmodule EspecIssues.GithubIssues do
  require Logger

  @github_url Application.get_env(:espec_issues, :github_url)
  @user_agent [ {"User-agent", "Elixir foo@foo.com"} ]

  def fetch(user, project) do
    Logger.info "Retrieving issues for #{user}/#{project}"
    issues_url(user, project)
    |> HTTPoison.get(@user_agent)
    |> handle_response
  end

  def issues_url(user, project) do
    "#{@github_url}/repos/#{user}/#{project}/issues"
  end

  def handle_response({:ok, %{status_code: 200, body: body}}) do
    Logger.info "Successful response"
    Logger.debug fn -> inspect(body) end
    {:ok, Poison.Parser.parse!(body)}
  end

  def handle_response({_, %{status_code: status_code, body: body}}) do
    Logger.error "Error #{status_code}"
    {:error, Poison.Parser.parse!(body)}
  end

  def handle_response({_, %HTTPoison.Error{id: id, reason: reason}}) do
    Logger.error "Network error #{id} (#{reason})"
    {:error, "ID: #{id}, Reason: #{reason}"}
  end
end
