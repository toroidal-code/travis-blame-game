require 'octokit'
require 'travis'

class Helper
    attr_reader :branches, :rapdev
    def initialize(repo,update_interval)
        @repo = repo
        @rapdev = Travis::Repository.find(@repo)
        @branches = branches_reload
        @update_interval = update_interval
    end
    
    def branches_reload
        #branches = Hash[Octokit.branches(repo).collect{ |x| [x["name"], x["commit"]["sha"]] }]
        #branches = Hash[Octokit.branches(repo).collect{ |x| [x["name"],rapdev.builds.find {|b| b if b.commit.sha == x["commit"]["sha"]} ] }]
        @branches = Hash[
             Octokit.branches(@repo).collect do |x|
                 build = @rapdev.builds.find {|b| b if b.commit.sha == x["commit"]["sha"]}
                 [ x["name"], build ]
             end
            ]
    end

    def self.repeat_every(interval)
        Thread.new do
            loop do
                start_time = Time.now
                yield
                elapsed = Time.now - start_time
                sleep([interval - elapsed, 0].max)
            end
        end
    end

    #repeat_every @update_interval do
      #puts "hello repeat"
      #@rapdev.reload
      #@branches_reload
    #end
end
