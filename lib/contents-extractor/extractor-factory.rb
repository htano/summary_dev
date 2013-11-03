# coding: utf-8
require 'uri'

# TODO: Singletonを使う
class ContentsExtractor::ExtractorFactory
  def initialize
    @config = Hash.new
  end

  def read_config_file(filename)
  end

  def new_extractor(url = nil)
    case get_extractor_type(url)
    when 'default'
      return ContentsExtractor::MonoExtractor.new
    else
      return ContentsExtractor::MonoExtractor.new
    end
  end

  def get_extractor_type(url = nil)
    if url
      uri = URI(url)
      domain = uri.host
      if @config[domain]
        return @config[domain]
      else
        return 'default'
      end
    else
      return 'default'
    end
  end
end
