defmodule Test.Bunyan.Formatter do

  use ExUnit.Case

  alias Bunyan.Formatter
  alias Bunyan.Shared.Level
  alias Bunyan.Shared.TestHelpers, as: TH

  @debug Level.of(:debug)
  @info  Level.of(:info)
  @warn  Level.of(:warn)
  @error Level.of(:error)


  @state %{
    use_ansi_color?: false
  }


  test "The format compiler returns a function" do
    result = Formatter.compile_format("first", "extra", @state)
    assert is_function(result)
    assert :erlang.fun_info(result)[:arity] == 1
  end

  test "The format function formats a basic message" do
    f = Formatter.compile_format("first line", "extra_line", @state)
    result = f.(TH.msg("boo!")) |> IO.iodata_to_binary()
    assert result == "first line\n           extra_line\n"
  end

  test "The format function inserts a message and indents the second line" do
    f = Formatter.compile_format("first line: $message", "extra_line", @state)
    result = f.(TH.msg("boo!")) |> IO.iodata_to_binary()
    assert result == "first line: boo!\n            extra_line\n"
  end

  test "A multiline message goes inline with $message" do
    f = Formatter.compile_format("first line: $message", "extra_line", @state)
    result = f.(TH.msg("l1\nl2")) |> IO.iodata_to_binary()
    assert result == "first line: l1\nl2\n            extra_line\n"
  end

  test "A multiline message is split and indented with $message_first_line/$message_rest" do
    f = Formatter.compile_format("first line: $message_first_line", "$message_rest", @state)
    result = f.(TH.msg("l1\nl2\nl3")) |> IO.iodata_to_binary()
    assert result == "first line: l1\n            l2\n            l3\n"
  end


  test "The time is inserted" do
    f = Formatter.compile_format("$time", "", @state)
    result = f.(TH.msg("l1\nl2\nl3")) |> IO.iodata_to_binary()
    assert result == "12:34:56.123\n"
  end

  test "The date is inserted" do
    f = Formatter.compile_format("$date", "", @state)
    result = f.(TH.msg("l1\nl2\nl3")) |> IO.iodata_to_binary()
    assert result == "2020-12-25\n"
  end

  test "The datetime is inserted" do
    f = Formatter.compile_format("$datetime", "", @state)
    result = f.(TH.msg("l1\nl2\nl3")) |> IO.iodata_to_binary()
    assert result == "2020-12-25 12:34:56.123\n"
  end

  test "The log level is inserted" do
    f = Formatter.compile_format("$level", "", @state)
    for { level, expected } <- [ { @debug, "D" }, { @info, "I" }, { @warn, "W" }, { @error, "E" }] do
      result = f.(TH.msg(level, "l1\nl2\nl3")) |> IO.iodata_to_binary()
      assert result == "#{expected}\n"
    end
  end

end
