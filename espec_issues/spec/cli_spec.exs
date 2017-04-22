defmodule CliSpec do
  use ESpec

  import EspecIssues.CLI, only: [parse_args: 1]

  it do: expect(parse_args(["--help", "anything"])).to eq(:help)
  it do: expect(parse_args(["--h", "anything"])).to eq(:help)

  it "returns the three values if three given" do
    expect(parse_args(["user", "project", "99"])).to eq({ "user", "project", 99 })
  end

  it "uses a default value for count if only two values are given" do
    expect(parse_args(["user", "project"])).to eq({ "user", "project", 4 })
  end
end
