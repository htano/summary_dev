# coding: utf-8
require 'uri'
require 'singleton'
require 'yaml'

class ContentsExtractor::ExtractorFactory
  include Singleton
  CONFIG_FILE = Rails.root.to_s + 
    '/lib/contents-extractor/config/domain-extractor.yml'

  def initialize
    @config = YAML.load_file(CONFIG_FILE)
  end

  def new_extractor(url = nil)
    domain = get_domain(url)
    encoding = get_encoding(domain)
    xpath = get_xpath(domain)
    case get_extractor_type(domain)
    when 'default'
      return ContentsExtractor::MonoExtractor.new(xpath, encoding)
    when 'xpath'
      return ContentsExtractor::XpathExtractor.new(xpath, encoding)
    else
      return ContentsExtractor::MonoExtractor.new(xpath, encoding)
    end
  end

  private
  def get_encoding(domain)
    if @config[domain]
      return @config[domain]["encoding"]
    else
      return nil
    end
  end

  def get_xpath(domain)
    if @config[domain]
      return @config[domain]["xpath"]
    else
      return nil
    end
  end

  def get_extractor_type(domain)
    if @config[domain]
      return @config[domain]["extractor_type"]
    else
      return nil
    end
  end

  def get_domain(url)
    if url
      uri = URI(url)
      domain = uri.host
      return domain
    else
      return nil
    end
  end
end
