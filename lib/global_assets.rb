require 'yaml'
require 'fileutils'
require 'erb'
require 'ostruct'

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
      file_at = File.join(settings[:source_dir], "snippets", name.to_s + ".erb")
      if(File.exists?(file_at))
        ret_val = erb(File.read(file_at), locals)
        return ret_val.html_safe if ret_val.respond_to?(:html_safe)
        return ret_val
      end
      raise Exception, "Could not find Snippet: [#{name.to_s}]"
    end
    
    def erb(template, locals)
      ERB.new(template).result(OpenStruct.new(locals).instance_eval { binding })
    end

    def move_global_files
      # delete all 3 target directories
      puts "Wiping old global directories..."
      [settings[:target_js], settings[:target_css], settings[:target_img]].each do |dir|
        if dir
          FileUtils.rm_rf(dir)
          FileUtils.mkdir_p(dir)
        end
      end
      # copy over all 3 source directories to the target dirs
      if settings[:target_js]
        puts "Moving global JS..."
        FileUtils.cp_r(File.join(settings[:source_dir], "js/."), settings[:target_js])
      end
      if settings[:target_css]
        puts "Moving global CSS..."
        FileUtils.cp_r(File.join(settings[:source_dir], "css/."), settings[:target_css])
      end
      if settings[:target_img]
        puts "Moving global Images..."
        FileUtils.cp_r(File.join(settings[:source_dir], "img/."), settings[:target_img])
      end
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
