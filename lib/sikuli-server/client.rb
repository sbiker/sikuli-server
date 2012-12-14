module SikuliServer
  class Client
    def initialize
      download_jars
      launch_server
    end

    def app_focus title
    end

    private

    def launch_server
      require "fileutils"
      server_path = File.expand_path(File.join(File.dirname(__FILE__), "../../SikuliServer"))
      FileUtils.mkdir_p File.join(server_path, "bin")
      puts server_path
      Dir.chdir server_path do
        system "javac -d bin -sourcepath src -cp lib/gson-2.2.2.jar src/*.java"
        system "java -cp bin:lib/gson-2.2.2.jar Main"
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
