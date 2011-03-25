desc "Change database adapter."
task "db:adapter" do
  Dir.chdir(File.dirname(__FILE__) + "/../../config")
  File.delete("database.yml") if File.exists?("database.yml")
  File.symlink("../../base/config/database.#{ENV['USE']}.yml", "database.yml")
end

