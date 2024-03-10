require 'fileutils'

shas = `git rev-list main`.lines.map { |line| line.strip }
if !File.exists?(__dir__ + "/tmp")
	Dir.mkdir __dir__ + "/tmp"
end
File.open(__dir__ + "/index.html", "w") do |file|
  file.write <<-html
<!DOCTYPE html>
<html>
<head>
<style>
body {font-family: "Gill Sans";}
a {
  background-color: blue;
  color: white;
  padding: 1em 1.5em;
  text-decoration: none;
  text-transform: uppercase;
}
</style>
</head>
<body>
<h1>Skye's The Limit</h1>
<p>Here are all versions of the game. You can click the link to play the game at that point in time, thanks to the magic of git!</p>
html
  shas.each_with_index do |sha, index|
    message = `git log --format=%B -n 1 #{sha}`
    date = `git show --no-patch --no-notes --date=format:'%Y-%m-%d %H:%M:%S' --pretty='%cd' #{sha}`
    file.write "<h2>#{date}</h2>"
    file.write "<p>#{message.lines.first}</p>"
    puts sha
    puts message
    FileUtils.mkdir_p __dir__ + "/commit/#{index}-#{sha}/src"
    Dir.chdir __dir__ + "/commit/#{index}-#{sha}/src" do
      `git init`
      `git remote add origin git@github.com:litten-hug/Collision-test.git`
      `git fetch --quiet --depth 1 origin #{sha}`
      `git checkout --quiet FETCH_HEAD`
      `rm -rf .git`
      `rm .gitignore`
      if File.exists? "package.json"
        `pnpm install`
        `pnpm build`
        file.write "<div><a href='./commit/#{index}-#{sha}/src/public/index.html'>Play!</a></div>"
      end
    end
  end
  file.write "</body></html>"
end
