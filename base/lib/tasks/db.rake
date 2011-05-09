desc "Change database adapter."
task "db:adapter" do
  Dir.chdir(File.join(File.dirname(__FILE__), "..", "..", "config"))
  if ENV['USE'].nil?
    target = File.readlink("database.yml")
    adapter = target[/database\.(.*)\.yml$/, 1]
    puts "Please specify which adapter to USE (currently #{adapter})."
    exit 1
  else
    File.delete("database.yml") if File.exists?("database.yml")
    File.symlink("../../base/config/database.#{ENV['USE']}.yml", "database.yml")
  end
end

