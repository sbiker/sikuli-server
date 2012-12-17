require "json"

module SikuliServer
  class Client
    def initialize
      download_jars
      launch_server
    end

    def server_url
      "http://localhost:7114"
    end

    def focus title
      HTTParty.post("#{server_url}/execute", :body => {
        :method     => "focus",
        :parameters => [title].to_json
      }).body
    end

    private

    def launch_server
      require "fileutils"
      require "childprocess"

      server_path = File.expand_path(File.join(File.dirname(__FILE__), "../../SikuliServer"))
      FileUtils.mkdir_p File.join(server_path, "bin")
      Dir.chdir server_path do
        sikuli_script_jar = [
          "/Applications/Sikuli-IDE.app/Contents/Resources/Java/sikuli-script.jar"
        ].find {|f| File.exist?(f)}

        compile_output = `javac -d bin -classpath lib/gson-2.2.2.jar:#{sikuli_script_jar} src/*.java`
        if $?.exitstatus != 0
          raise compile_output
        end

        @process = ChildProcess.build("java", "-cp", "bin:lib/gson-2.2.2.jar:#{sikuli_script_jar}", "Main")
        @process.io.inherit!
        @process.start
        loop do
          response = HTTParty.get("#{server_url}/version").body rescue nil
          break if response
        end
        at_exit do
          @process.stop
        end
      end
    end

    def download_jars
      gson_path = File.expand_path(File.join(File.dirname(__FILE__), "../../SikuliServer/lib/gson-2.2.2.jar"))

      require "httparty"
      require "tempfile"
      gson_response = HTTParty.get("http://google-gson.googlecode.com/files/google-gson-2.2.2-release.zip")
      temp_file = Tempfile.new("gson.zip")
      temp_file << gson_response.body

      require "zip/zip"
      zip = Zip::ZipFile.open(temp_file.path)
      File.open(gson_path, "w") do |gson_file|
        gson_file.write(zip.read("google-gson-2.2.2/gson-2.2.2.jar"))
      end
    end
  end
end
