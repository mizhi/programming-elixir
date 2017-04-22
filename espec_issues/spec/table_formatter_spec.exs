defmodule TableFormatterTest do
  use ESpec
  import ExUnit.CaptureIO

  alias EspecIssues.TableFormatter, as: TF

  let :simple_test_data do
    [ [ c1: "r1 c1", c2: "r1 c2", c3: "r1 c3", c4: "r1+++c4"],
      [ c1: "r2 c1", c2: "r2 c2", c3: "r2 c3", c4: "r2 c4"],
      [ c1: "r3 c1", c2: "r3 c2", c3: "r3 c3", c4: "r3 c4"],
      [ c1: "r4 c1", c2: "r4++c2", c3: "r4 c3", c4: "r4 c4"] ]
  end

  let :headers do
    [:c1, :c2, :c4]
  end

  describe "#split_into_columns" do
    subject do: TF.split_into_columns(simple_test_data, headers)

    it do: expect(length(subject)).to eq(length(headers))
    it do: expect(List.first(subject)).to eq(["r1 c1", "r2 c1", "r3 c1", "r4 c1"])
    it do: expect(List.last(subject)).to eq(["r1+++c4", "r2 c4", "r3 c4", "r4 c4"])
  end

  describe "#widths_of" do
    subject do
      TF.widths_of(
        TF.split_into_columns(simple_test_data, headers)
      )
    end

    it do: is_expected.to eq([5, 6, 7])
  end

  describe "#format_for" do
    subject do: TF.format_for([5, 6, 7])

    let :w1, do: 5
    let :w2, do: 6
    let :w3, do: 7

    it do: is_expected.to eq("~-#{w1}s | ~-#{w2}s | ~-#{w3}s")
  end

  describe "#print_table_for_columns" do
    subject do
      capture_io fn ->
        TF.print_table_for_columns(simple_test_data, headers)
      end
    end

    it do: is_expected.to eq("""
    c1    | c2     | c4
    ------+--------+--------
    r1 c1 | r1 c2  | r1+++c4
    r2 c1 | r2 c2  | r2 c4
    r3 c1 | r3 c2  | r3 c4
    r4 c1 | r4++c2 | r4 c4
    """)
  end
end
