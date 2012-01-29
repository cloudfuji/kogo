# {"name":"JobName",
#  "url":"JobUrl",
#   "build":{
#     "number":1,
#     "phase":"STARTED",
#     "status":"FAILED",
#           "url":"job/project/5",
#           "fullUrl":"http://ci.jenkins.org/job/project/5"
#   "parameters":{"branch":"master"}
#  }
# }
class BushidoBuildHooks < Bushido::EventObserver
  def build_started
    prepare_data!

    Channel.announce("#{@name} build started (branch #{@branch}) at #{@url}")
  end

  # We don't care about build_ended, it's not actionable. Just respond to the build_failed and build_passed events
  def build_failed
    prepare_data!

    Channel.announce("#{@name} build FAILED (branch #{@branch}) at #{@url}")
  end

  def build_passed
    prepare_data!

    Channel.announce("#{@name} build PASSED (branch #{@branch}) at #{@url}")
  end

  private

  def prepare_data!
    "prepping data.."
    puts params.inspect
    @data = params['data']
    @name = @data['name']
    @url        = @data['full_url']
    @number     = @data['number']
    @status     = @data['status']
    @parameters = @data['parameters']
    if @parameters
      @branch = @parameters['branch']
    end
  end
end

