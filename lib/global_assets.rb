require 'yaml'
require 'fileutils'

class GlobalAssets
  class << self
    def inherited(base)
      configs = YAML.load_file("config/#{snake_case(base)}.yml")
      if configs[snake_case(base)] && configs[snake_case(base)]["target_dirs"]
        base.set(:target_js, configs[snake_case(base)]["target_dirs"]["js"])
        base.set(:target_css, configs[snake_case(base)]["target_dirs"]["css"])
        base.set(:target_img, configs[snake_case(base)]["target_dirs"]["img"])
      end
      super
    end

    def snippet(name, locals = {})
      file_at = File.join(settings[:source_dir], "snippets", name.to_s + ".html")
      return File.read(file_at) if(File.exists?(file_at))
      return "Could not find Snippet: [#{name.to_s}]"
    end

    def move_global_files
      # delete all 3 target directories
      [settings[:target_js], settings[:target_js], settings[:target_js]].each do |dir|
        FileUtils.rm_rf(dir)
        FileUtils.mkdir_p(dir)
      end
      # copy over all 3 source directories to the target dirs
      FileUtils.cp_r(File.join(settings[:source_dir], "js"), settings[:target_js])
      FileUtils.cp_r(File.join(settings[:source_dir], "css"), settings[:target_css])
      FileUtils.cp_r(File.join(settings[:source_dir], "img"), settings[:target_img])
    end

    def set(key, val)
      settings[key] = val
    end

    def settings
      @settings ||= {}
    end

    private
    def snake_case(camel_cased_word)
      camel_cased_word.to_s.gsub(/::/, '/').
      gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
      gsub(/([a-z\d])([A-Z])/,'\1_\2').
      tr("-", "_").
      downcase
    end
  end
end

__END__

require './lib/global_assets'
class EMEGlobalAssets; include GlobalAssets; end
EMEGlobalAssets.snippet(:test)
