defmodule Pastry do
  @moduledoc """
  Documentation for Pastry.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Pastry.hello
      :world

  """
  def main(args) do
    IO.puts "Welcome to Pastry"
    numNodes=String.to_integer(Enum.at(args,0))
    numRequests=String.to_integer(Enum.at(args,1))
    IO.puts(numNodes)
    IO.puts(numRequests)
  end
end
