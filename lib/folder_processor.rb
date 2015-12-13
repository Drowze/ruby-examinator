module FolderProcessor
  def self.create_folders(cfg)
    FileUtils.makedirs 'temp'
    if cfg['preserve_bins']
      FileUtils.makedirs "#{cfg['tested_binaries_dir']}"
    end
    if cfg['preserve_outs']
      FileUtils.makedirs "#{cfg['tested_outputs_dir']}"
    end
  end

  def self.parse_outputs(cfg, source, counter)
    source_no_extension = source.split('.')[0]
    if cfg['preserve_bins']
      compiler_output = cfg['tested_binaries_dir'] + 
                        source_no_extension + cfg['binary_extension']
    else
      compiler_output = 'temp/a.out'
    end

    if cfg['preserve_outs']
      file_output = cfg['tested_outputs_dir'] + 
                    source_no_extension + "/#{counter}.txt"
    else
      file_output = 'temp/' + 'a.out'
    end
    return compiler_output, file_output
  end

  def self.create_personal_folders(cfg, source)
    source_no_ext = source.split('.')[0]
    FileUtils.makedirs "#{cfg['tested_outputs_dir']}#{source_no_ext}"
  end
end
