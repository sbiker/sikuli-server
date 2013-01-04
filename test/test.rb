$:.unshift(File.expand_path(File.join(File.dirname(__FILE__), "../lib")))
require "sikuli-server"

client = SikuliServer::Client.new

client.focus("Google Chrome.app")
images = File.expand_path(File.join(File.dirname(__FILE__), "images"))
client.click(File.join(images, "SignIn.png"))
