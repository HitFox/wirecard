require "webrick"

class Webserver
  class MyServlet < WEBrick::HTTPServlet::AbstractServlet
    def do_POST (request, response)
      case request.path
        when "/confirm"
          result = request.query
        else
          result = "No such page. 404!"
      end
      response.body = result.to_s + "\n"
    end
  end
  
  def self.server
    @@server ||= WEBrick::HTTPServer.new(Port: 1234)
    @@server.mount('/', MyServlet)
    @@server
  end
  
  def self.start
    server.start 
  end
  
  def self.stop
    server.shutdown 
  end
end