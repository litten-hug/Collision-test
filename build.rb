require 'fileutils'

shas = `git rev-list --all`.lines.map { |line| line.strip }
if !File.exists?(__dir__ + "/tmp")
	Dir.mkdir __dir__ + "/tmp"
end
File.open(__dir__ + "/index.html", "w") do |file|
  file.write "<html><head><title>Collision Test</title></head><body>"
  shas.each_with_index do |sha, index|
    message = `git log --format=%B -n 1 #{sha}`
    date = `git show --no-patch --no-notes --date=format:'%Y-%m-%d %H:%M:%S' --pretty='%cd' #{sha}`
    file.write "<h1>#{date}</h1>"
    file.write "<p>#{message.lines.first}</p>"
    puts sha
    puts message
    FileUtils.mkdir_p __dir__ + "/tmp/#{index}-#{sha}/src"
    Dir.chdir __dir__ + "/tmp/#{index}-#{sha}/src" do
      File.write "../message", message
      `git init`
      `git remote add origin git@github.com:litten-hug/Collision-test.git`
      `git fetch --depth 1 origin #{sha}`
      `git checkout FETCH_HEAD`
      if File.exists? "package.json"
        `pnpm install`
        `pnpm build`
        file.write "<a href='./tmp/#{index}-#{sha}/src/public/index.html'>Play!</a>"
        file.write "<iframe src='./tmp/#{index}-#{sha}/src/public/index.html'></iframe>"
      end
    end
  end
  file.write "</body></html>"
end
