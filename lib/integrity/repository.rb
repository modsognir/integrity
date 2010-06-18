module Integrity
  class Repository
    def initialize(id, permalink, uri, branch, commit)
      @id        = id
      @permalink = permalink
      @uri       = uri
      @branch    = branch
      @commit    = commit == "HEAD" ? head : commit
    end

    def checkout
      unless cloned?
        cached? ? clone_cache : clone
      end
      run "git fetch origin"
      run "git checkout origin/#{@branch}"
      run "git reset --hard #{@commit}"
    end

    def metadata
      format = "---%nid: %H%nauthor: %an " \
        "<%ae>%nmessage: >-%n  %s%ntimestamp: %ci%n"

      dump = YAML.load(`cd #{directory} && git show -s \
        --pretty=format:"#{format}" #{@commit}`)

      dump.update("timestamp" => Time.parse(dump["timestamp"]))
    end

    def head
      `git ls-remote --heads #{@uri} #{@branch} | cut -f1`.chomp
    end

    def directory
      @directory ||= Integrity.directory.join(@id.to_s)
    end
    
    def cached?
      cache_directory.directory?
    end
    
    def clone_cache
      run "cp -R #{cache_directory} #{directory}", false
    end
    
    def clone
      run "git clone #{@uri} #{cache_directory}", false
      clone_cache
    end
    
    def cache_directory
      Integrity.directory.join("cache", @permalink)
    end
    
    private
      def cloned?
        directory.join(".git").directory?
      end

      def run(cmd, cd=true)
        cmd = "(#{cd ? "cd #{directory} && " : ""}#{cmd} > /dev/null 2>&1)"
        Integrity.logger.debug(cmd)
        system(cmd) || fail("Couldn't run `#{cmd}`")
      end
  end
end
