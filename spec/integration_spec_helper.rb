require "open3"
require "net/http"

module IntegrationSpecHelper
  def run_vita(*)
    Open3.capture2e(vita_executable, *, chdir: garden_path)
  end

  def start_vita(*)
    stdin, stdout_stderr, wait_thread = Open3.popen2e(
      vita_executable, *, chdir: garden_path
    )
    @vita_pid = wait_thread.pid

    stdin.close

    # Wait for the web server to start
    loop do
      break if stdout_stderr.gets.include? "Listening"
    end
  end

  def stop_vita
    if @vita_pid
      Process.kill "KILL", @vita_pid
      @vita_pid = nil
    end
  end

  def http_get(url)
    Net::HTTP.get_response(URI(url))
  end

  private

  def vita_executable
    File.join(Vita::BASE_DIRECTORY, "bin", "vita")
  end
end
