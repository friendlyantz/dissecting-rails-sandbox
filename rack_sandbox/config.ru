app = Proc.new do |env|
  req = Rack::Request.new(env)

  case req.path_info
  in /hello/
    [200, { "some-header" => "badabing" }, ["Hello World!"]]
  in '/'
    [200, { "content-type" => "text/html" }, [File.open("rickrollview").read]]
  else
    [404, { "content-type" => "text/html" }, ["<h1>Not Found</h1>"]]
  end
end

run app
