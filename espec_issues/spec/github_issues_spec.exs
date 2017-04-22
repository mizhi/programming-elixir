defmodule GithubIssuesSpec do
  use ESpec

  alias EspecIssues.GithubIssues, as: GithubIssues

  let :github_url, do: Application.get_env(:espec_issues, :github_url)

  describe "#fetch" do
    subject do: GithubIssues.fetch(user, project)
    let :user, do: "auser"
    let :project, do: "project"
    let :issue_url, do: GithubIssues.issues_url(user, project)

    let :parsed_response do
      "parsed #{http_response_body}"
    end

    before do
      issue_url_param = issue_url
      allow(HTTPoison).to accept(:get, fn(^issue_url_param, _) -> http_response end)

      http_response_body_var = http_response_body
      allow(Poison.Parser).to accept(:parse!, fn(^http_response_body_var) -> parsed_response end)
    end

    context "when successful" do
      let :http_response do
        {
          :ok,
          %{
            status_code: 200,
            body: http_response_body
          }
        }
      end

      let :http_response_body, do: "#{user} #{project} success"

      it do: is_expected.to eq({:ok, parsed_response})
    end

    context "when unsuccessful" do
      let :http_response do
        {
          :error,
          %{
            status_code: 404,
            body: http_response_body
          }
        }
      end

      let :http_response_body, do: "#{user} #{project} failure"

      it do: is_expected.to eq({:error, parsed_response})
    end
  end

  describe "#handle_response" do
    describe "when response is HTTP response" do
      subject do: GithubIssues.handle_response({status, %{status_code: status_code, body: body}})

      before do
        allow(Poison.Parser).to accept(:parse!, fn (text) -> "Parsed: #{text}" end)
      end

      context "response is for success" do
        let :status, do: :ok
        let :status_code, do: 200
        let :body, do: "success"

        let :parsed_body, do: "Parsed: #{body}"

        it do: is_expected.to eq({:ok, parsed_body})
      end

      context "response is for failure" do
        let :status, do: :error
        let :status_code, do: 400
        let :body, do: "failure"

        let :parsed_body, do: "Parsed: #{body}"

        it do: is_expected.to eq({:error, parsed_body})
      end
    end

    describe "when network error occurs" do
      subject do: GithubIssues.handle_response({:error, %HTTPoison.Error{id: id, reason: reason}})
      let :id, do: 123
      let :reason, do: "fooerror"

      it do: is_expected.to eq({:error, "ID: #{id}, Reason: #{reason}"})
    end
  end
end
