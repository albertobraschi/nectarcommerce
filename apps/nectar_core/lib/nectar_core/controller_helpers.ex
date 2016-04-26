defmodule NectarCore.ControllerHelpers do

  def request_type(conn) do
    if ajax_request?(conn) do
      :ajax
    else
      :html
    end
  end

  defp ajax_request?(conn) do
    case conn |> Plug.Conn.get_req_header("x-requested-with") do
      ["XMLHttpRequest"] -> true
      _ -> accepts_json?(conn)
    end
  end

  defp accepts_json?(conn) do
    case conn |> Plug.Conn.get_req_header("accept") do
      ["application/json"] -> true
      _ -> false
    end
  end

end
