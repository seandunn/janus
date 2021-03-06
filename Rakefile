module VIM
  Dirs = %w[ after autoload doc plugin ruby snippets syntax ftdetect ftplugin colors indent ]
end

directory "tmp"
VIM::Dirs.each do |dir|
  directory(dir)
end

def vim_plugin_task(name, repo=nil)
  cwd = File.expand_path("../", __FILE__)
  dir = File.expand_path("tmp/#{name}")
  subdirs = VIM::Dirs

  namespace(name) do
    if repo
      file dir => "tmp" do
        if repo =~ /git$/
          sh "git clone #{repo} #{dir}"

        elsif repo =~ /download_script/
          if filename = `curl --silent --head #{repo} | grep attachment`[/filename=(.+)/,1]
            filename.strip!
            sh "curl #{repo} > tmp/#{filename}"
          else
            raise ArgumentError, 'unable to determine script type'
          end

        elsif repo =~ /(tar|gz|vba|zip)$/
          filename = File.basename(repo)
          sh "curl #{repo} > tmp/#{filename}"

        else
          raise ArgumentError, 'unrecognized source url for plugin'
        end

        case filename
        when /zip$/
          sh "unzip -o tmp/#{filename} -d #{dir}"

        when /tar\.gz$/
          dirname  = File.basename(filename, '.tar.gz')

          sh "tar zxvf tmp/#{filename}"
          sh "mv #{dirname} #{dir}"

        when /vba(\.gz)?$/
          if filename =~ /gz$/
            sh "gunzip -f tmp/#{filename}"
            filename = File.basename(filename, '.gz')
          end

          # TODO: move this into the install task
          mkdir_p dir
          lines = File.readlines("tmp/#{filename}")
          current = lines.shift until current =~ /finish$/ # find finish line

          while current = lines.shift
            # first line is the filename (possibly followed by garbage)
            # some vimballs use win32 style path separators
            path = current[/^(.+?)(\t\[{3}\d)?$/, 1].gsub '\\', '/'

            # then the size of the payload in lines
            current = lines.shift
            num_lines = current[/^(\d+)$/, 1].to_i

            # the data itself
            data = lines.slice!(0, num_lines).join

            # install the data
            Dir.chdir dir do
              mkdir_p File.dirname(path)
              File.open(path, 'w'){ |f| f.write(data) }
            end
          end
        end
      end

      task :pull => dir do
        if repo =~ /git$/
          Dir.chdir dir do
            sh "git pull"
          end
        end
      end

      task :install => [:pull] + subdirs do
        Dir.chdir dir do
          if File.exists?("Rakefile") and `rake -T` =~ /^rake install/
            sh "rake install"
          elsif File.exists?("install.sh")
            sh "sh install.sh"
          else
            subdirs.each do |subdir|
              if File.exists?(subdir)
                sh "cp -rf #{subdir}/* #{cwd}/#{subdir}/"
              end
            end
          end
        end

        yield if block_given?
      end
    else
      task :install => subdirs do
        yield if block_given?
      end
    end
  end

  desc "Install #{name} plugin"
  task name do
    puts
    puts "*" * 40
    puts "*#{"Installing #{name}".center(38)}*"
    puts "*" * 40
    puts
    Rake::Task["#{name}:install"].invoke
  end
  task :default => name
end


vim_plugin_task "abolish.vim",      "http://github.com/tpope/vim-abolish.git"
vim_plugin_task "ag.vim",           "https://github.com/rking/ag.vim.git"
vim_plugin_task "airline",          "https://github.com/bling/vim-airline.git"
vim_plugin_task "Tabular",          "http://github.com/godlygeek/tabular.git"
vim_plugin_task "ctrlp",            "http://github.com/kien/ctrlp.vim.git"
vim_plugin_task "coffee",            "https://github.com/kchmck/vim-coffee-script.git"
vim_plugin_task "fugitive",         "http://github.com/tpope/vim-fugitive.git"
vim_plugin_task "git",              "http://github.com/tpope/vim-git.git"
vim_plugin_task "Gundo",            "http://github.com/sjl/gundo.vim.git"
vim_plugin_task "javascript",       "http://github.com/pangloss/vim-javascript.git"
# vim_plugin_task "javascript-syntax", "http://github.com/jelera/vim-javascript-syntax.git"
vim_plugin_task "javascript-indent", "https://github.com/vim-scripts/JavaScript-Indent.git"
vim_plugin_task "tern",             "http://github.com/marijnh/tern_for_vim.git"
# vim_plugin_task "typescript",       "https://github.com/leafgarland/typescript-vim.git"
vim_plugin_task "jshint",           "http://github.com/walm/jshint.vim.git"
# vim_plugin_task "LargeFiles",       "http://www.vim.org/scripts/download_script.php?src_id=9277"
vim_plugin_task "nerdtree",         "http://github.com/wycats/nerdtree.git"
vim_plugin_task "ledger",           "http://github.com/philips/vim-ledger.git"
vim_plugin_task "pandoc",           "git@github.com:vim-pandoc/vim-pandoc.git"
vim_plugin_task "rails",            "http://github.com/tpope/vim-rails.git"
vim_plugin_task "repeat",           "http://github.com/tpope/vim-repeat.git"
vim_plugin_task "ruby-text-object", "http://github.com/nelstrom/vim-textobj-rubyblock.git"
vim_plugin_task "supertab",         "http://github.com/ervandew/supertab.git"
vim_plugin_task "surround",         "http://github.com/tpope/vim-surround.git"
# vim_plugin_task "Syntastic",        "http://github.com/scrooloose/syntastic.git"
vim_plugin_task "TComment",         "http://github.com/tomtom/tcomment_vim.git"
# vim_plugin_task "splice",           "https://github.com/sjl/splice.vim.git"
vim_plugin_task "tlib",             "http://github.com/tomtom/tlib_vim.git"
vim_plugin_task "vim-tmuxify",      "http://github.com/mhinz/vim-tmuxify.git"
vim_plugin_task "unimpaired",       "http://github.com/tpope/vim-unimpaired.git"
vim_plugin_task "vim-textobj-user", "http://github.com/kana/vim-textobj-user.git"
vim_plugin_task "vim-visual-star",  "http://github.com/nelstrom/vim-visual-star-search.git"
vim_plugin_task "vitality",         "http://github.com/sjl/vitality.vim.git"
vim_plugin_task "zoomwin",          "http://www.vim.org/scripts/download_script.php?src_id=9865"
vim_plugin_task "matchit",          "http://www.vim.org/scripts/download_script.php?src_id=8196"


desc "Update the documentation"
task :update_docs do
  puts "Updating VIM Documentation..."
  system "vim -e -s <<-EOF\n:helptags ~/.vim/doc\n:quit\nEOF"
end

desc "link vimrc to ~/.vimrc"
task :link_vimrc do
  %w[ vimrc gvimrc ].each do |file|
    dest = File.expand_path("~/.#{file}")
    unless File.exist?(dest)
      ln_s(File.expand_path("../#{file}", __FILE__), dest)
    end
  end
end

task :clean do
  system "git clean -dfx"
end

desc "Pull the latest"
task :pull do
  system "git pull"
end

task :default => [
  :update_docs,
  :link_vimrc
]

desc "Clear out all build artifacts and rebuild the latest Janus"
task :upgrade => [:clean, :pull, :default]

