Dynamo.under_test(Sparkler.Dynamo)
Dynamo.Loader.enable
ExUnit.start

defmodule Sparkler.TestCase do
  use ExUnit.CaseTemplate

  # Enable code reloading on test cases
  setup do
    Dynamo.Loader.enable
    :ok
  end
end
